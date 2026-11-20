# Recording meter for NotchShelf

Enable **Recording animation in NotchShelf** in PocketFlow Studio settings. During dictation and meeting capture, a compatible running shelf can display the meter. While the shelf presents the meter, Studio hides the floating live transcript preview. The preview returns with the capsule if the connection drops. Prompts and errors remain in Studio. Use Studio’s shortcut or menu to finish a recording.

Both apps use the current login session’s DistributedNotificationCenter. The prefix is `io.github.jsc2304.pocketflow-studio.meter.v1.` and the notification object is an ephemeral UUID string. The interface carries presentation state only. It grants no recording controls. Local processes can observe or spoof these notifications.

| Event | Direction | Content |
| --- | --- | --- |
| probe | Studio → shelf | Sent on capture and once per second during capture |
| ready | shelf → Studio | Echo the probe’s UUID to acknowledge support |
| level | Studio → shelf | Numeric userInfo.level from 0 through 1, sampled at 8 Hz after acknowledgement |
| end | Studio → shelf | Clear the active session |

Studio restores the floating meter after two seconds without acknowledgement. The shelf clears stale levels after two seconds without a sample. Disabling the setting ends the session. The default is off, including for existing workspaces. No audio samples, words, titles or identifiers from saved meetings are sent.
