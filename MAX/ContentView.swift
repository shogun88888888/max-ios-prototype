import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "waveform")
                .font(.system(size: 52, weight: .medium))
                .foregroundStyle(.tint)

            VStack(spacing: 8) {
                Text("MAX")
                    .font(.largeTitle.bold())

                Text("Private push-to-talk prototype")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Label("Setup complete", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.green)

                Text("Audio and nearby connection testing have not been enabled.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))

            Button("Hold to Talk") {}
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(true)

            Text("App shell only")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(24)
    }
}
