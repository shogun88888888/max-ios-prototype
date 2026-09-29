# MAX App Store Submission Guide

## Purpose and status

This is an account-neutral submission package for MAX 1.0.0. It does not create an App Store Connect record, select a seller, submit a build, or assert that a physical-device test passed.

MAX is a foreground-only nearby push-to-talk app. It discovers nearby MAX devices while the app is open, creates an encrypted Multipeer Connectivity session, and relays live microphone audio only while a connected person holds Talk. It has no account system, backend, cloud relay, recording, message history, advertising, analytics SDK, purchases, or subscriptions.

## Required publisher decisions

Complete these only after choosing the App Store publisher.

| Item | Required decision |
| --- | --- |
| Seller | Individual or organization shown on the App Store product page |
| Signing team | Active paid Apple Developer Program team for that seller |
| Bundle ID | Register a final, unique bundle identifier under that team; do not assume `com.maxprototype.app` can move between teams |
| App record | Create the iOS App Store Connect record before uploading an archive |
| Version and build | Start with 1.0.0 (build 1 unless that team has already uploaded a build with that identifier) |
| Support URL | Public HTTPS support page with a working contact route |
| Privacy policy URL | Public, stable HTTPS URL containing the completed policy template |
| Copyright and rights | Confirm the publisher owns or has permission for the MAX name, icon, screenshots, and all source assets |
| Availability | Countries/regions, price, age rating, tax category, and manual or automatic release choice |

## Proposed App Store metadata

Review this copy for legal accuracy and naming clearance before entering it.

| Field | Proposed value |
| --- | --- |
| Name | MAX |
| Subtitle | Nearby Push-to-Talk |
| Category | Utilities |
| Promotional text | Talk directly with nearby MAX devices while both apps are open. |
| Description | MAX is a simple nearby push-to-talk app for people in the same area. Open MAX on two nearby iPhones, find a device, connect, then hold Talk to send live audio. MAX works only while the app is open in the foreground. It does not provide Internet calling, background operation, accounts, message history, recordings, cloud storage, or subscriptions. |
| Keywords | nearby,push to talk,local audio,voice communication,walkie talkie |
| Support URL | `[PUBLISHER_SUPPORT_URL]` |
| Marketing URL | Optional: `[PUBLISHER_MARKETING_URL]` |
| Privacy policy URL | `[PUBLISHER_PRIVACY_POLICY_URL]` |

Keep keywords within Apple’s current character limit when entered. Do not claim a range, reliability level, emergency use, encryption guarantee beyond the implementation, background capability, or offline/Internet capability that has not been physically verified.

## App privacy declaration

### Current code facts

- The project contains no third-party SDKs, accounts, analytics, advertising, server calls, cloud storage, or local audio recording.
- The microphone is accessed only after the user begins a push-to-talk action and grants iOS microphone permission.
- Live audio is transmitted directly to connected nearby peers while Talk is held. It is not sent to a developer-operated server or retained by the app.
- Nearby peer display names are shown during discovery and connection. The current implementation derives the local display name from the iPhone’s device name.

### Submission decision

The Account Holder must review the final binary and answer App Store Connect’s App Privacy questionnaire. The expected answer is likely **No, we do not collect data from this app** only if the final binary remains serverless, has no added SDK, and neither the publisher nor a third-party partner retains or accesses the direct peer traffic. This is a review item, not a legal conclusion. Update the declaration if any analytics, crash reporter, support SDK, account feature, recording, relay, or data retention is added.

## App Review information

Use the following as a starting point in App Store Connect, then replace bracketed fields.

```text
MAX requires no account, login, payment, special hardware, or external service.

To test its primary feature, use two nearby physical iPhones with MAX installed. Open MAX on both devices and allow Local Network and Microphone access when prompted. On one phone, tap Find Nearby Devices, select the other MAX device, and tap Connect. On the second phone, accept the Nearby connection request. On either connected phone, hold Talk while speaking. The other phone should play the live audio. Repeat in the other direction.

MAX is intentionally foreground-only. There is no background walkie-talkie, cloud relay, message history, or recording feature.

Review contact: [NAME, EMAIL, PHONE]
Demonstration video: [PRIVATE_REVIEW_VIDEO_URL]
```

Record the private review video only after the full test plan passes. It should show the same submitted build on two physical iPhones, discovery, connection, A-to-B audio, B-to-A audio, and the foreground-only behavior.

## Screenshots and release evidence

Capture real-device screenshots from the candidate build after testing:

1. Main screen before discovery, showing the app’s foreground-only explanation.
2. Nearby devices list.
3. Connected state with the Talk control available.
4. Talking state on one device and receiving state on the other, only if it is visually clear and reproducible.

Do not manufacture functionality in screenshots. Retain the raw recording, the exact build number, device models, iOS versions, date, location conditions, tester names/initials, and pass/fail results with the test record.

## Final release gate

Do not archive or submit until all are true:

- [ ] Two-iPhone test plan passed for the exact candidate build.
- [ ] Physical evidence video exists and reviewer instructions are complete.
- [ ] Microphone and Local Network denial/recovery behavior is tested.
- [ ] Final signing team and bundle ID are set by the chosen publisher.
- [ ] Public support and privacy-policy URLs work without login.
- [ ] Final App Privacy responses reflect the submitted binary.
- [ ] Name, icon, and listing copy rights are confirmed.
- [ ] Export-compliance questions are reviewed by the Account Holder for the final binary.
- [ ] Archive upload, App Store Connect processing, and the submission metadata are checked in the chosen account.

## State language

Use these as separate statuses: source prepared; unsigned build compiled; device build installed; two-device test passed; evidence recorded; archive uploaded; TestFlight tested; submitted; in review; approved; released; publicly available. One status does not imply another.
