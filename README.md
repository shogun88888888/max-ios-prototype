# MAX iOS Prototype

Status as of August 20, 2026: a native SwiftUI foreground nearby push-to-talk checkpoint is implemented.

## Answer classification

- **Fact:** `MAX` is a native SwiftUI iPhone app with no external dependencies, accounts, cloud services, or background-audio capability.
- **Fact:** While open in the foreground, two nearby MAX devices can discover each other and create an encrypted Multipeer Connectivity session.
- **Fact:** A connected user can hold the Talk control to capture temporary 16 kHz mono PCM microphone audio and relay it to connected peers. Received audio is played immediately.
- **Fact:** Audio is not recorded to disk or uploaded by this prototype.
- **Limitation:** Real discovery and end-to-end audio require two physical iPhones. The Simulator cannot validate the nearby radio path.
- **Limitation:** This is an experimental prototype, not a background walkie-talkie service or a production-quality audio transport.

## Current files

- `MAX.xcodeproj`: Xcode project, microphone and local-network permission descriptions, and shared-scheme metadata.
- `MAX/MAXApp.swift`, `MAX/ContentView.swift`: App entry point and foreground interface.
- `MAX/NearbySession.swift`: Nearby peer discovery, connection state, and temporary in-memory packet relay.
- `MAX/AudioRelay.swift`: Microphone capture, PCM conversion, and immediate playback.
- `MAX/Assets.xcassets`: Asset catalog, including the MAX dog app icon.
- `MAX/PrivacyInfo.xcprivacy`: Privacy manifest with no declared tracking or collected-data categories.
- `.gitignore`: Xcode, macOS, local-configuration, and secret exclusions.

## Intended first implementation stages

The first two authorized implementation stages are now present:

1. Native SwiftUI application shell.
2. Foreground nearby offline push-to-talk using Multipeer Connectivity.

The initial scope does not include LiveKit, cloud services, subscriptions, TestFlight distribution, background Push to Talk, Wi-Fi Aware, mesh relaying, or external radio hardware.

## Development environment

Use Xcode 26.6 through:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
```

Build the Simulator target:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project MAX.xcodeproj -scheme MAX -destination 'platform=iOS Simulator,name=iPhone 16' build
```
