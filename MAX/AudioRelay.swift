import Foundation
@preconcurrency import AVFAudio

@MainActor
final class AudioRelay {
    private final class InputBufferProvider: @unchecked Sendable {
        private let buffer: AVAudioPCMBuffer
        private let lock = NSLock()
        private var hasProvidedBuffer = false

        init(buffer: AVAudioPCMBuffer) {
            self.buffer = buffer
        }

        func nextBuffer() -> AVAudioPCMBuffer? {
            lock.lock()
            defer { lock.unlock() }

            guard !hasProvidedBuffer else { return nil }
            hasProvidedBuffer = true
            return buffer
        }
    }

    enum RelayError: LocalizedError {
        case microphonePermissionDenied
        case microphoneUnavailable
        case unsupportedAudioFormat

        var errorDescription: String? {
            switch self {
            case .microphonePermissionDenied:
                return "MAX needs microphone permission to send live audio."
            case .microphoneUnavailable:
                return "This device does not currently have a usable microphone input."
            case .unsupportedAudioFormat:
                return "MAX could not prepare the microphone audio format on this device."
            }
        }
    }

    var onAudioData: ((Data) -> Void)?

    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let voiceFormat = AVAudioFormat(
        commonFormat: .pcmFormatInt16,
        sampleRate: 16_000,
        channels: 1,
        interleaved: false
    )!
    private var converter: AVAudioConverter?
    private var isTapInstalled = false

    func beginTransmitting() async throws {
        guard !isTapInstalled else { return }

        let granted = await AVAudioApplication.requestRecordPermission()
        guard granted else { throw RelayError.microphonePermissionDenied }

        try configureAndStartEngine()
        try installInputTap()
    }

    func stopTransmitting() {
        guard isTapInstalled else { return }

        engine.inputNode.removeTap(onBus: 0)
        isTapInstalled = false
    }

    func receive(_ data: Data) {
        guard data.count.isMultiple(of: MemoryLayout<Int16>.size), !data.isEmpty else { return }

        do {
            try configureAndStartEngine()
        } catch {
            return
        }

        let frameCount = AVAudioFrameCount(data.count / MemoryLayout<Int16>.size)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: voiceFormat, frameCapacity: frameCount),
              let samples = buffer.int16ChannelData else {
            return
        }

        buffer.frameLength = frameCount
        samples[0].withMemoryRebound(to: UInt8.self, capacity: data.count) { destination in
            data.copyBytes(to: destination, count: data.count)
        }
        playerNode.scheduleBuffer(buffer)

        if !playerNode.isPlaying {
            playerNode.play()
        }
    }

    private func configureAndStartEngine() throws {
        if engine.isRunning { return }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(
            .playAndRecord,
            mode: .voiceChat,
            options: [.defaultToSpeaker, .allowBluetoothHFP]
        )
        try audioSession.setActive(true)

        if engine.attachedNodes.contains(playerNode) == false {
            engine.attach(playerNode)
            engine.connect(playerNode, to: engine.mainMixerNode, format: voiceFormat)
        }

        try engine.start()
    }

    private func installInputTap() throws {
        let inputNode = engine.inputNode
        let inputFormat = inputNode.inputFormat(forBus: 0)

        guard inputFormat.sampleRate > 0,
              inputFormat.channelCount > 0,
              let converter = AVAudioConverter(from: inputFormat, to: voiceFormat) else {
            throw RelayError.unsupportedAudioFormat
        }

        self.converter = converter
        inputNode.installTap(onBus: 0, bufferSize: 1_024, format: inputFormat) { [weak self] buffer, _ in
            self?.send(buffer)
        }
        isTapInstalled = true
    }

    private func send(_ inputBuffer: AVAudioPCMBuffer) {
        guard let converter else { return }

        let ratio = voiceFormat.sampleRate / inputBuffer.format.sampleRate
        let capacity = AVAudioFrameCount((Double(inputBuffer.frameLength) * ratio).rounded(.up)) + 1
        guard let outputBuffer = AVAudioPCMBuffer(pcmFormat: voiceFormat, frameCapacity: capacity) else {
            return
        }

        let provider = InputBufferProvider(buffer: inputBuffer)
        var conversionError: NSError?
        let status = converter.convert(to: outputBuffer, error: &conversionError) { _, outputStatus in
            if let sourceBuffer = provider.nextBuffer() {
                outputStatus.pointee = .haveData
                return sourceBuffer
            }

            outputStatus.pointee = .noDataNow
            return nil
        }

        guard status == .haveData,
              conversionError == nil,
              outputBuffer.frameLength > 0,
              let samples = outputBuffer.int16ChannelData else {
            return
        }

        let byteCount = Int(outputBuffer.frameLength) * MemoryLayout<Int16>.size
        let data = Data(bytes: samples[0], count: byteCount)
        Task { @MainActor [weak self] in
            self?.onAudioData?(data)
        }
    }
}
