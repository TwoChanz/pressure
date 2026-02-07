# Technical Implementation Roadmap

## Overview

This roadmap breaks the Pressure MVP into five sequential phases. Each phase produces a shippable increment that can be tested independently. Total estimated timeline: 6–8 weeks for a solo developer.

---

## Tech Stack

| Layer              | Technology                    | Rationale                                     |
|:-------------------|:------------------------------|:----------------------------------------------|
| Platform           | iOS (iPhone priority)         | Target user demographic skews iOS             |
| Language           | Swift 5.9+                    | Native performance, SwiftUI integration       |
| UI Framework       | SwiftUI                       | Fast iteration, declarative, minimal UI needs |
| Local Storage      | UserDefaults + Core Data      | Settings in UD, commitment records in CD      |
| Notifications      | UNUserNotificationCenter      | Local notifications, no server dependency     |
| Subscriptions      | StoreKit 2                    | Native Apple subscription management          |
| Architecture       | MVVM + State Machine          | Clean separation; SM for escalation engine    |
| Testing            | XCTest + Swift Testing        | Unit tests for state machine, UI tests for flow|

---

## Phase 1: Core Data Layer & State Machine (Week 1)

**Goal:** Escalation engine works as a testable, standalone module with no UI.

### Deliverables
- [ ] Core Data model: `Commitment` entity with all fields from data model spec
- [ ] UserDefaults wrapper: type-safe keys for `UserSettings` and `EscalationState`
- [ ] State machine: `EscalationEngine` as a pure function
  - Input: `(EscalationState, CheckInResult) → EscalationState`
  - Handles all tier transitions, de-escalation, streak logic
  - Restart Shield logic (gated by subscription tier)
- [ ] Date utilities: timezone-aware helpers for deadline/window calculations
  - `isCommitmentLocked(deadline:currentTime:) → Bool`
  - `isWindowOpen(deadline:windowClose:currentTime:) → Bool`
  - `windowMidpoint(deadline:windowClose:) → Date`
- [ ] Unit tests: full coverage of state machine transitions
  - All advancement paths (Tier 0→1→2→3)
  - All de-escalation paths
  - Edge cases: same-day shield, no-commitment days
  - Streak calculation accuracy

### Test Criteria
- 100% of escalation state transitions covered by unit tests
- State machine produces identical output for identical input (deterministic)
- No UI code in this phase

---

## Phase 2: Home Screen & Check-In Flow (Week 2–3)

**Goal:** User can set a commitment, check in YES/NO, and see their streak. Functional daily loop without notifications.

### Deliverables
- [ ] Home screen view
  - Today's commitment (or prompt to set one)
  - Streak count (dominant visual)
  - Status indicator (green/red/neutral)
  - Escalation tier indicator (subtle)
- [ ] Commitment entry view
  - Text field, 280 char limit
  - Lock indicator showing time until deadline
  - Disabled state after deadline passes
- [ ] Check-in view
  - YES / NO buttons (large, binary, no ambiguity)
  - Confirmation: "This can't be undone" before submitting NO
  - Success/failure feedback (copy from tone guide, respects personality mode)
- [ ] Daily state manager
  - Creates new commitment record at midnight (or on first app open)
  - Transitions PENDING → MISSED at window close
  - Calls escalation engine on every state change
- [ ] Personality mode integration
  - All user-facing copy pulls from a `CopyProvider` protocol
  - Two implementations: `ProfessionalCopy`, `BrutalCopy`
  - Switchable at runtime via UserDefaults

### Test Criteria
- Full daily loop works: set commitment → lock at deadline → check in → see streak update
- NO check-in breaks streak immediately
- Missing the window marks as MISSED and advances escalation
- Copy changes when personality mode is toggled

---

## Phase 3: Notification System (Week 3–4)

**Goal:** Escalation-aware notifications that fire at the correct times and respect personality mode.

### Deliverables
- [ ] Notification scheduler
  - Calculates fire dates based on tier, deadline, and window close
  - Reschedules when tier changes or user modifies settings
  - Cancels remaining notifications on check-in
- [ ] Notification content builder
  - Pulls copy from `CopyProvider` based on current personality mode
  - Inserts commitment text into notification body
  - Handles all tiers (0–3) and all notification types
- [ ] Permission flow
  - Request on onboarding (Step 3)
  - Track grant/deny state
  - Persistent in-app banner if denied
  - Deep link to iOS Settings for re-enabling
- [ ] Badge management
  - Standard badge on Tiers 0–2 (clears on app open)
  - Persistent badge on Tier 3 (clears only on check-in)
- [ ] Background handling
  - Schedule next day's notifications after check-in
  - Handle app-not-opened scenario (pre-schedule up to 3 days ahead)

### Test Criteria
- Correct number of notifications per tier (1, 2, 3, 3)
- Notifications fire at correct times relative to window
- All notifications cancelled when user checks in
- Copy matches personality mode and tier
- Badge persists on Tier 3 until check-in

### Known Limitations
- iOS limits pending local notifications to 64; with max 3/day and 3-day lookahead, we use 9 slots max — well within limit
- Notification delivery is not guaranteed by iOS if device is in Do Not Disturb or Focus mode — this is acceptable and not a product defect

---

## Phase 4: Onboarding & Settings (Week 4–5)

**Goal:** First-run experience works end-to-end. Users can modify all configurable settings.

### Deliverables
- [ ] Onboarding flow (5 screens per onboarding spec)
  - Cold open with commitment prompt
  - Personality preview (split screen comparison)
  - Notification permission request
  - Deadline/window configuration
  - Home screen landing with commitment pre-set
- [ ] Onboarding state persistence
  - Resume from last completed step on force-quit
  - `onboarding_completed` flag prevents re-showing
- [ ] Settings screen
  - Personality mode toggle
  - Commitment deadline picker (6 AM – 12 PM)
  - Check-in window close picker (6 PM – 11:59 PM)
  - Notification re-enable prompt (if denied)
  - Restart Shield status (paid only)
  - Subscription management link
- [ ] Analytics event hooks (log to console in MVP, structured for future integration)

### Test Criteria
- Full onboarding flow completes in under 60 seconds
- Commitment from Step 1 appears on home screen
- Personality selection persists and affects all copy
- Changing deadline/window reschedules notifications
- Force-quit during onboarding resumes correctly

---

## Phase 5: Subscription & Polish (Week 5–6)

**Goal:** Paywall works, Brutal mode is gated, Restart Shield is functional. App is App Store–ready.

### Deliverables
- [ ] StoreKit 2 integration
  - Monthly and annual subscription products
  - Paywall screen (accessible from onboarding personality preview and settings)
  - Receipt validation (on-device with StoreKit 2)
  - Restore purchases flow
- [ ] Feature gating
  - Brutal personality: requires active subscription
  - Restart Shield: requires active subscription, max 1/month
  - Escalation tuning: requires active subscription (post-MVP, stub the setting)
- [ ] Restart Shield UX
  - Prompt appears after NO check-in or MISSED: "Use your Restart Shield?"
  - Shows consequence: "Your streak resets but escalation won't advance"
  - Available for 1 hour after the triggering event
  - Shield count visible in settings
- [ ] Visual polish
  - App icon
  - Launch screen (minimal — solid color, no animation)
  - Status bar and safe area handling
  - Dynamic Type support (accessibility)
  - Dark mode (primary theme) and light mode support
- [ ] App Store assets
  - Screenshots (5.5" and 6.7")
  - App description copy
  - Privacy policy (no data collection in MVP)
  - App Review notes

### Test Criteria
- Subscription purchase flow works end-to-end
- Brutal mode locked without subscription
- Restart Shield activates correctly, decrements count, resets monthly
- App passes App Store review guidelines

---

## Post-Launch Priorities

Ordered by expected impact on growth metrics:

1. **Widget (WidgetKit)** — Streak count on home screen, commitment text on lock screen. High visibility, drives daily engagement without opening the app.
2. **Apple Watch complication** — Streak count and quick check-in from wrist. Reduces friction for the daily loop.
3. **Share-a-notification** — Screenshot-friendly formatting for Brutal mode notifications. Explicit share button on the post-check-in screen.
4. **Multiple commitments** — Expand from 1 to 3 daily commitments for paid users. Requires schema changes (see data model migration notes).
5. **Cloud sync** — Cross-device support via CloudKit. Low priority since MVP is single-device.

---

## Risk Register

| Risk                                    | Likelihood | Impact | Mitigation                                           |
|:----------------------------------------|:-----------|:-------|:-----------------------------------------------------|
| Notification permission denial rate >40%| Medium     | High   | Pre-prompt explanation screen; in-app nudge banner   |
| App Store rejection (aggressive copy)   | Low        | High   | Professional mode is default; Brutal is opt-in paid  |
| StoreKit 2 edge cases on older iOS      | Low        | Medium | Minimum deployment target iOS 16+                    |
| Core Data migration issues post-launch  | Medium     | Medium | Lightweight schema; version Core Data model from day 1|
| Scope creep during development          | High       | Medium | This roadmap is the scope boundary; defer all else   |
