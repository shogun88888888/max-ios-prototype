# MAX iOS Prototype

Status as of August 19, 2026: native iPhone project metadata only. No application code has been written.

## Answer classification

- **Fact:** This repository contains an Xcode project with an empty iPhone application target named `MAX`.
- **Fact:** There are no Swift source files, external dependencies, entitlements, cloud services, or executable application features.
- **Fact:** The privacy manifest declares no tracking, collected-data categories, or required-reason API use for this empty scaffold.
- **Limitation:** The empty target cannot compile into a working application until an application entry point is separately authorized and added.

## Current files

- `MAX.xcodeproj`: Xcode project and shared-scheme metadata.
- `MAX/Assets.xcassets`: Empty asset catalog and App Icon placeholder metadata.
- `MAX/PrivacyInfo.xcprivacy`: Initial privacy manifest for the empty target.
- `.gitignore`: Xcode, macOS, local-configuration, and secret exclusions.

## Intended first implementation stages

Implementation remains subject to separate authorization. The approved sequence is:

1. Create a native SwiftUI application shell and verify that it compiles.
2. Add foreground nearby offline push-to-talk using Multipeer Connectivity.

The initial scope does not include LiveKit, cloud services, subscriptions, TestFlight distribution, background Push to Talk, Wi-Fi Aware, mesh relaying, or external radio hardware.

## Development environment

Use Xcode 26.6 through:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
```

Project parsing can be checked without building application code:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project MAX.xcodeproj -list
```
