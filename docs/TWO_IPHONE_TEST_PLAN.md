# MAX Two-iPhone Acceptance Test Plan

## Scope

This plan validates the exact foreground nearby push-to-talk behavior that cannot be proven in the iOS Simulator. Run it on the same signed build intended for TestFlight or App Store submission.

## Equipment and environment

- Two physical iPhones capable of running the candidate build.
- Both devices updated to a documented iOS version and connected to power or at least 50% battery.
- MAX installed from the same signed archive/build number on both phones.
- Both phones near each other, unlocked, and able to keep MAX open in the foreground.
- A third phone/camera for the review-evidence video, or a reliable way to capture both screens and audible results.
- A quiet room for the baseline pass, then a normal indoor environment for the range/recovery observation.

Record before testing:

| Field | Device A | Device B |
| --- | --- | --- |
| Model |  |  |
| iOS version |  |  |
| MAX version/build |  |  |
| Wi-Fi/Bluetooth state |  |  |
| Tester |  |  |
| Date/time and place |  |  |

## Test cases

Mark each as Pass, Fail, or Not Run. A failure blocks a submission candidate until investigated and retested.

| ID | Procedure | Expected result |
| --- | --- | --- |
| PTT-01 | Fresh-install/open MAX on both devices. | App launches; no crash. |
| PTT-02 | Allow Local Network permission when prompted. | Discovery can be started. |
| PTT-03 | Allow Microphone permission when prompted. | No error appears when beginning a connected transmission. |
| PTT-04 | On both devices, tap Find Nearby Devices. | Each phone shows the other device within a reasonable nearby-test period. Record the elapsed time. |
| PTT-05 | On Device A, select Device B and tap Connect. On Device B, accept the Nearby connection request. | Both devices show a connected state. |
| PTT-06 | With Device A connected to Device B, hold Talk on A and speak a unique short sentence. | B plays the sentence live; A changes to Talking while held; audio stops after release. |
| PTT-07 | Repeat PTT-06 from B to A with a different sentence. | A plays the sentence live; B changes to Talking while held; audio stops after release. |
| PTT-08 | Repeat directional audio three times each. | No crash or permanent loss of connection; note latency, dropouts, or feedback. |
| PTT-09 | Release Talk, wait 30 seconds, then transmit again. | A new held transmission works. |
| PTT-10 | Stop Nearby Sharing on one device, then restart it and reconnect. | Devices recover without relaunching both apps. |
| PTT-11 | Close/background MAX on one device. | The other device does not claim background service; document the observed disconnect or unavailable state. |
| PTT-12 | On a fresh install or after resetting permissions, deny Microphone permission and attempt Talk after connecting. | MAX presents a clear microphone-permission error and does not crash. |
| PTT-13 | On a fresh install or after resetting permissions, deny Local Network permission and start discovery. | MAX does not crash; document the actual iOS/app behavior and whether a clearer recovery path is needed. |
| PTT-14 | Disconnect/reconnect with both devices still open. | Connection status returns to the correct state and talk works in both directions. |

## Acceptance standard

The candidate passes only when PTT-01 through PTT-10 and PTT-14 pass on the same build. PTT-11 through PTT-13 must be documented and must not crash; any unclear or unrecoverable permission failure is a release issue to fix before submission.

## Review-evidence video

After a passing run, record a continuous 60 to 90 second private video that shows:

1. Both iPhones showing the same MAX version/build and open app.
2. Nearby discovery and connection.
3. Device A holding Talk and Device B audibly receiving a spoken sentence.
4. Device B holding Talk and Device A audibly receiving a different sentence.
5. Release of Talk stopping transmission.
6. The app remaining in the foreground throughout.

Use a private, stable link for App Review. Do not publish the video unless the publisher separately decides to do so. Keep the raw original and a written result table with the candidate release materials.
