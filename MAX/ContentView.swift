import SwiftUI

struct ContentView: View {
    @StateObject private var nearby = NearbySession()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "waveform")
                        .font(.system(size: 52, weight: .medium))
                        .foregroundStyle(.tint)

                    VStack(spacing: 8) {
                        Text("MAX")
                            .font(.largeTitle.bold())

                        Text("Nearby push-to-talk prototype")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Label(nearby.connectionStatus, systemImage: nearby.connectedPeerNames.isEmpty ? "dot.radiowaves.left.and.right" : "checkmark.circle.fill")
                            .font(.headline)
                            .foregroundStyle(nearby.connectedPeerNames.isEmpty ? Color.primary : Color.green)

                        Text("Discovery runs only while this app is open in the foreground. No account or cloud service is used.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))

                    Button(nearby.isDiscovering ? "Stop Nearby Sharing" : "Find Nearby Devices") {
                        nearby.isDiscovering ? nearby.stopDiscovery() : nearby.startDiscovery()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    if !nearby.discoveredPeerNames.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Nearby devices")
                                .font(.headline)

                            ForEach(nearby.discoveredPeerNames, id: \.self) { peerName in
                                HStack {
                                    Text(peerName)
                                    Spacer()
                                    Button("Connect") {
                                        nearby.connect(to: peerName)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button("Hold to Talk") {}
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(true)

                    Text("Nearby connection is this checkpoint. Live microphone relay is next.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("Nearby connection issue", isPresented: Binding(
            get: { nearby.errorMessage != nil },
            set: { if !$0 { nearby.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(nearby.errorMessage ?? "")
        }
    }
}
