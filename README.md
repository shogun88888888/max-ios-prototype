# MAX iOS Prototype

Status: a native SwiftUI foreground nearby push-to-talk build is implemented. It has not yet completed the required two-physical-iPhone acceptance test or App Store submission.

## Answer classification

- **Fact:** `MAX` is a native SwiftUI iPhone app with no external dependencies, accounts, cloud services, or background-audio capability.
- **Implemented behavior:** While open in the foreground, two nearby MAX devices can discover each other and create an encrypted Multipeer Connectivity session.
- **Implemented behavior:** A connected user can hold the Talk control to capture temporary 16 kHz mono PCM microphone audio and relay it to connected peers. Received audio is played immediately.
- **Implemented behavior:** Audio is not recorded to disk or uploaded by the app.
- **Unverified:** Real discovery and end-to-end audio require two physical iPhones. The Simulator cannot validate the nearby radio path.
- **Limitation:** MAX is a foreground-only nearby communication app. It does not provide background walkie-talkie operation, cloud relay, Internet calling, recording, or message history.

## Current files

- `MAX.xcodeproj`: Xcode project, microphone and local-network permission descriptions, and shared-scheme metadata.
- `MAX/MAXApp.swift`, `MAX/ContentView.swift`: App entry point and foreground interface.
- `MAX/NearbySession.swift`: Nearby peer discovery, connection state, and temporary in-memory packet relay.
- `MAX/AudioRelay.swift`: Microphone capture, PCM conversion, and immediate playback.
- `MAX/Assets.xcassets`: Asset catalog, including the current MAX app icon.
- `MAX/PrivacyInfo.xcprivacy`: Privacy manifest with no declared tracking or collected-data categories.
- `docs/APP_STORE_SUBMISSION.md`: Account-neutral App Store listing, privacy, review, and release checklist.
- `docs/TWO_IPHONE_TEST_PLAN.md`: Required physical-device acceptance and review-video procedure.
- `docs/PRIVACY_POLICY_TEMPLATE.md`: Publisher-neutral privacy-policy copy to publish at a stable HTTPS URL before submission.
- `.gitignore`: Xcode, macOS, local-configuration, and secret exclusions.

## Intended first implementation stages

The first two authorized implementation stages are now present:

1. Native SwiftUI application shell.
2. Foreground nearby offline push-to-talk using Multipeer Connectivity.

The initial scope does not include LiveKit, cloud services, subscriptions, TestFlight distribution, background Push to Talk, Wi-Fi Aware, mesh relaying, or external radio hardware.

## App Store readiness

The source is prepared for a 1.0.0 submission candidate, but it is not ready to submit until the physical-device test plan passes and the selected publisher configures its own signing team, bundle identifier, App Store Connect record, public support URL, and public privacy-policy URL. See `docs/APP_STORE_SUBMISSION.md`.

## Development environment

Use Xcode 26.6 through:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
```

Build the Simulator target:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project MAX.xcodeproj -scheme MAX -destination 'platform=iOS Simulator,name=iPhone 16' build
```
