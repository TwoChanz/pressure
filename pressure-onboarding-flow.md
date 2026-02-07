# Onboarding Flow Specification

## Overview

Onboarding is the single highest-leverage retention moment. Pressure's onboarding is designed to demonstrate the product's voice before asking the user to configure anything. The user writes their first commitment before seeing any settings, tutorials, or feature explanations.

Total onboarding steps: **5 screens**
Target completion time: **Under 60 seconds**
Goal: User lands on home screen with tomorrow's commitment already set.

---

## Flow Diagram

```
┌─────────────┐    ┌─────────────────┐    ┌──────────────────┐
│  Cold Open   │───►│  Personality     │───►│  Notification    │
│  (commit)    │    │  Preview         │    │  Permission      │
└─────────────┘    └─────────────────┘    └──────────────────┘
                                                    │
                          ┌─────────────┐           │
                          │ Home Screen  │◄──────────┤
                          │ (done)       │    ┌──────────────────┐
                          └─────────────┘◄───│  Set Deadline     │
                                             └──────────────────┘
```

---

## Screen 1: Cold Open

### Purpose
Capture the user's first commitment immediately. No splash, no branding, no explanation. The product demonstrates itself through action.

### Layout
- Full-screen, single focus
- Background: solid black or near-black (#1A1A1A)
- Text color: white
- No navigation, no back button, no skip

### Content
```
[Top 1/3 — empty space]

"What's the one thing you
 need to do tomorrow?"

[Text input field — single line, white border, no placeholder]

[Bottom — "Continue" button, disabled until text is entered]
```

### Behavior
- Text field auto-focuses on appear (keyboard slides up)
- Max 280 characters (matches commitment limit)
- "Continue" button activates when 1+ character entered
- No validation beyond non-empty
- Commitment text is stored locally, used on next screen

### Design Notes
- The question is in Professional mode by default
- No app name visible on this screen
- The starkness is intentional — it mirrors the product's philosophy

---

## Screen 2: Personality Preview

### Purpose
Let the user experience both personality modes using their own commitment. This is the "show a friend" moment — the screen most likely to be screenshotted.

### Layout
- Split-screen comparison (left/right on iPad, stacked on iPhone)
- Each side shows a mock notification using the commitment from Step 1

### Content
```
┌─────────────────────┬─────────────────────┐
│   PROFESSIONAL      │   BRUTAL [PRO]      │
│                     │                     │
│  "You committed to  │  "[Commitment].     │
│   [commitment].     │   Did you do it     │
│   Check in when     │   or not?"          │
│   it's done."       │                     │
│                     │                     │
│      [SELECT]       │      [SELECT]       │
└─────────────────────┴─────────────────────┘

"Which voice do you want in your head?"
```

### Behavior
- Both columns are tappable; tapping one selects it (highlighted border)
- Brutal column shows a subtle "PRO" badge in the corner
- If user taps Brutal and is not subscribed, show a brief inline message: "Brutal mode is available with Pressure Pro." with a "Start Free Trial" link and a "Continue with Professional" fallback
- Default selection: Professional (pre-highlighted)
- "Continue" button at bottom

### Design Notes
- The PRO badge on Brutal is subtle — don't gate the preview, gate the selection
- Users should SEE Brutal copy even if they can't select it yet
- This is a conversion moment: experiencing Brutal copy creates desire

---

## Screen 3: Notification Permission

### Purpose
Explain why notifications are essential before the OS prompt fires. Frame it as accountability, not marketing.

### Layout
- Centered content, single CTA
- Dark background continues from onboarding theme

### Content
```
"Pressure only works if
 it can reach you."

"Without notifications, the app
 can't hold you accountable."

        [Enable Notifications]

              Not now
```

### Behavior
- "Enable Notifications" triggers the iOS notification permission dialog
- If granted: proceed to Step 4, store `notifications_enabled = true`
- If denied: proceed to Step 4, store `notifications_enabled = false`
- "Not now" skips the OS prompt, proceeds to Step 4
- If notifications denied/skipped, a persistent but non-blocking banner appears on the home screen: "Notifications are off. Pressure can't reach you."

### Design Notes
- The "Not now" link is intentionally small and de-emphasized
- Do NOT use the word "allow" — iOS already uses it in the system prompt
- Frame as accountability ("can't hold you accountable"), not features ("get reminders")

---

## Screen 4: Set Deadline

### Purpose
Configure the two time boundaries that govern the entire product loop.

### Layout
- Two time pickers stacked vertically
- Brief explanation text above each

### Content
```
"Your commitment locks at this time.
 No edits after."

Commitment Deadline:    [ 9:00 AM  ▼ ]

"Check in before this time or
 the day is a miss."

Check-in Window Close:  [ 10:00 PM ▼ ]

"You can change these later in Settings."

              [Start]
```

### Behavior
- Commitment deadline picker: 6:00 AM – 12:00 PM, 30-minute increments
- Check-in window close picker: 6:00 PM – 11:59 PM, 30-minute increments
- Validation: window close must be at least 4 hours after commitment deadline
- Defaults: 9:00 AM and 10:00 PM
- "Start" button proceeds to home screen

### Design Notes
- Keep this screen fast — most users will accept defaults
- The explanation text is minimal on purpose; detailed settings live in the settings screen
- Don't show timezone — use device timezone silently

---

## Screen 5: Home Screen (First Load)

### Purpose
The user sees their commitment already set for tomorrow. Zero friction to first value.

### State on First Load
- Commitment: the text entered in Step 1, status PENDING
- Streak: 0
- Escalation tier: 0
- Status indicator: neutral (not red or green — first day hasn't happened yet)

### Welcome Element
On first load only, show a brief inline message above the commitment:

**Professional:** "Your commitment is set for tomorrow. The clock starts at [deadline time]."

**Brutal:** "Tomorrow. [Deadline time]. No excuses."

This message dismisses on tap and never appears again.

---

## Analytics Events

Track these during onboarding for funnel analysis:

| Event                          | Trigger                                    |
|:-------------------------------|:-------------------------------------------|
| `onboarding_started`           | Cold open screen appears                   |
| `commitment_entered`           | User taps Continue on Step 1               |
| `personality_previewed`        | User views Step 2                          |
| `personality_brutal_tapped`    | User taps Brutal column (even if not selected) |
| `personality_selected`         | User taps Continue on Step 2               |
| `notification_prompt_shown`    | Step 3 appears                             |
| `notification_granted`         | OS permission granted                      |
| `notification_denied`          | OS permission denied                       |
| `notification_skipped`         | "Not now" tapped                           |
| `deadline_configured`          | User changes default deadline              |
| `onboarding_completed`         | Home screen loads                          |

### Key Funnel Metrics

- **Step 1 → Step 2 drop-off:** If high, the cold open question isn't landing
- **Brutal tap rate:** Measures curiosity about paid tier during onboarding
- **Notification grant rate:** Critical for core loop; target 70%+
- **Deadline change rate:** If very low, consider removing Step 4 and using defaults with a settings nudge later

---

## Edge Cases

| Scenario                              | Behavior                                                  |
|:--------------------------------------|:----------------------------------------------------------|
| User force-quits during onboarding    | Resume from last completed step on next launch            |
| User enters commitment after deadline | Commitment is for tomorrow (today is already past deadline)|
| User is already subscribed (promo)    | Brutal mode is selectable in Step 2                       |
| User denies notifications, returns later | Settings screen has re-enable prompt with deep link to iOS settings |
| Very long commitment text             | Single line truncates with ellipsis in preview; full text visible on home screen |
