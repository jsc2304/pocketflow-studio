# PocketFlow Studio
Guardrails version: 8 · Last gate run: never · State: released

## Purpose and users

Mac users can dictate into the active app and take meeting notes using local speech models. PocketFlow Studio is an independently maintained BetterWispr fork. Source is public. The fork currently builds from source.

## Scope and non-goals

Dictation, history, meeting detection, call-end stopping and opt-in meeting access for MCP clients are available. Combining dictation history with PocketFlow on iOS is planned. Storage, consent and conflict resolution for shared history are open.

## Exposure

The desktop app runs on the user's Mac. Its optional meeting connector uses a local stdio process. The app does not host a public meeting service.

## Data

Settings, vocabulary, meeting notes and dictation history live in the user's Application Support directory. API connection keys use macOS Keychain. The [README](../README.md#privacy) describes optional external processing. No cross-device transfer has been implemented.

## AI usage

Built-in speech recognition runs locally with zero provider spend. Users can select external transcription, cleanup or notes providers. Those providers' account limits and charges apply. The fork does not publish a hosted AI service or supply a shared API key.

## Architecture and stack

SwiftUI and AppKit on macOS, a shared Swift core, local files and a read-only MCP endpoint. See [architecture](architecture.md) for the recording and transcription lifecycle.

## Deviations from the guardrails

The fork has no published Studio update feed yet. A signed installer and installed-build update test are pending for the first Studio binary release.

## Release gate

| Row | Applies | Status | Evidence | Date |
|---|---|---|---|---|
| G1 Secrets | yes | open | | |
| G2 Client boundary | | open | | |
| G3 Input and business rules | | open | | |
| G4 Identity and access | | open | | |
| G5 Rate limits and budgets | | open | | |
| G6 AI | | open | | |
| G7 Exposure | | open | | |
| G8 Data | yes | open | Privacy and storage documented in README. Cross-device restore exercise pending. | 20.11.2026 |
| G9 Dependencies | | open | | |
| G10 Public repository | | open | | |
| G11 Version | yes | done | About reads the packaged version. VERSION and CHANGELOG.md are tracked. | 20.11.2026 |
| G12 Design | | open | | |
| G13 README and repo page | | open | | |
| G14 In-app updates | yes | open | Fork feed and signing configuration isolated. First signed update test pending. | 20.11.2026 |

## Waivers

None.

## Open points

- Verify an installed update using the fork's release key.
- Decide how iPhone and Mac users opt in to shared history and delete entries on both devices.
