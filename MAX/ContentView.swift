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

                        Text("Nearby push-to-talk")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Label(nearby.connectionStatus, systemImage: nearby.connectedPeerNames.isEmpty ? "dot.radiowaves.left.and.right" : "checkmark.circle.fill")
                            .font(.headline)
                            .foregroundStyle(nearby.connectedPeerNames.isEmpty ? Color.primary : Color.green)

                        Text("Discovery runs only while MAX is open in the foreground. No account or cloud service is used.")
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

                    Text(nearby.isTalking ? "Talking…" : "Hold to Talk")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(nearby.isTalking ? Color.red : Color.accentColor, in: Capsule())
                        .opacity(nearby.connectedPeerNames.isEmpty ? 0.5 : 1)
                        .onLongPressGesture(minimumDuration: 0, maximumDistance: 60, pressing: { isPressing in
                            if isPressing {
                                nearby.beginTalking()
                            } else {
                                nearby.endTalking()
                            }
                        }, perform: {})
                        .accessibilityLabel(nearby.isTalking ? "Talking" : "Hold to Talk")
                        .accessibilityHint(
                            nearby.connectedPeerNames.isEmpty
                                ? "Connect to a nearby MAX device before using push-to-talk."
                                : "Hold while speaking to send live audio to nearby connected devices."
                        )
                        .accessibilityAddTraits(.isButton)
                        .allowsHitTesting(!nearby.connectedPeerNames.isEmpty)

                    Text("Live audio is sent only while you hold the button. Nothing is recorded or uploaded.")
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
        .alert("Nearby connection request", isPresented: Binding(
            get: { nearby.incomingInvitationPeerName != nil },
            set: { if !$0 { nearby.declineIncomingInvitation() } }
        )) {
            Button("Decline", role: .cancel) {
                nearby.declineIncomingInvitation()
            }
            Button("Connect") {
                nearby.acceptIncomingInvitation()
            }
        } message: {
            Text("Allow \(nearby.incomingInvitationPeerName ?? "this device") to connect for nearby push-to-talk?")
        }
    }
}
