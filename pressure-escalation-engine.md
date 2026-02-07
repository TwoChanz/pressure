# Escalation Engine — State Machine Specification

## Overview

The escalation engine is the core behavioral mechanic of Pressure. It operates as a deterministic state machine that advances or retreats based on daily check-in outcomes. All logic runs on-device with no server dependency.

---

## State Diagram

```
                    ┌─────────────────────────────────────────────┐
                    │                                             │
                    ▼                                             │
              ┌──────────┐   MISS/NO   ┌──────────┐   MISS/NO   │
  ────────►   │  TIER 0   │ ─────────► │  TIER 1   │ ─────────►  │
              │ Baseline  │            │  Nudge    │             │
              └──────────┘            └──────────┘             │
                    ▲                      │ ▲                   │
                    │ 1×YES                │ │ 1×YES             │
                    │                      ▼ │                   │
                    │                ┌──────────┐   MISS/NO    ┌──────────┐
                    │                │  TIER 2   │ ──────────► │  TIER 3   │
                    │                │   Push    │             │  Alarm    │
                    │                └──────────┘             └──────────┘
                    │                      ▲                     │
                    │                      │ 1×YES               │
                    │                      │                     │
                    └──────────────────────┴─────────────────────┘
                          (graduated de-escalation)
```

---

## Tier Definitions

### Tier 0 — Baseline

| Property              | Value                                    |
|:----------------------|:-----------------------------------------|
| **Trigger**           | Default state / full de-escalation       |
| **Notifications**     | 1 reminder at check-in window midpoint   |
| **Copy tone**         | Neutral, matter-of-fact                  |
| **Badge behavior**    | Standard app badge (clears on check-in)  |
| **Reset condition**   | N/A (this is the default)                |

### Tier 1 — Nudge

| Property              | Value                                                       |
|:----------------------|:------------------------------------------------------------|
| **Trigger**           | 1 consecutive MISS or NO                                    |
| **Notifications**     | 2 reminders (window midpoint + 1 hour before window close)  |
| **Copy tone**         | Firmer, directly references the miss                        |
| **Badge behavior**    | Standard app badge                                          |
| **Reset condition**   | 1 consecutive YES → drops to Tier 0                         |

### Tier 2 — Push

| Property              | Value                                                                      |
|:----------------------|:---------------------------------------------------------------------------|
| **Trigger**           | 2 consecutive MISS or NO                                                   |
| **Notifications**     | 3 reminders (window midpoint, 2 hours before close, 30 minutes before close)|
| **Copy tone**         | Direct pressure, references streak loss and pattern                        |
| **Badge behavior**    | Standard app badge                                                         |
| **Reset condition**   | 2 consecutive YES → drops to Tier 1; then 1 more YES → Tier 0             |

### Tier 3 — Alarm

| Property              | Value                                                                       |
|:----------------------|:----------------------------------------------------------------------------|
| **Trigger**           | 3+ consecutive MISS or NO                                                   |
| **Notifications**     | 3 reminders (same timing as Tier 2) + persistent badge until check-in       |
| **Copy tone**         | Maximum severity per personality mode                                       |
| **Badge behavior**    | Persistent — does not clear until YES or NO is submitted                    |
| **Reset condition**   | 3 consecutive YES → drops to Tier 2; then 2 more → Tier 1; then 1 → Tier 0 |

---

## Transition Rules

### Advancement (escalation)

```
IF check-in result = NO or MISSED:
    consecutive_misses += 1
    consecutive_successes = 0

    IF consecutive_misses >= 3:
        escalation_tier = 3
    ELSE IF consecutive_misses == 2:
        escalation_tier = 2
    ELSE IF consecutive_misses == 1:
        escalation_tier = 1
```

### De-escalation (recovery)

```
IF check-in result = YES:
    consecutive_successes += 1
    consecutive_misses = 0

    IF escalation_tier == 1 AND consecutive_successes >= 1:
        escalation_tier = 0
        consecutive_successes = 0
    ELSE IF escalation_tier == 2 AND consecutive_successes >= 2:
        escalation_tier = 0
        consecutive_successes = 0
    ELSE IF escalation_tier == 3 AND consecutive_successes >= 3:
        escalation_tier = 0
        consecutive_successes = 0
```

> **Design note:** De-escalation goes straight to Tier 0 once the required consecutive successes are met, rather than stepping down one tier at a time. This keeps the logic simple and rewards sustained effort with a clean reset.

### Restart Shield (Paid Only)

```
IF check-in result = NO or MISSED:
    IF restart_shields_remaining > 0 AND user activates shield:
        streak = 0                    // streak always resets
        escalation_tier = unchanged   // tier does NOT advance
        consecutive_misses = unchanged
        restart_shields_remaining -= 1
    ELSE:
        // normal escalation logic
```

---

## Hard Constraints

| Constraint                        | Value | Rationale                                        |
|:----------------------------------|:------|:-------------------------------------------------|
| Max notifications per day         | 3     | Prevents app deletion from notification fatigue  |
| Max escalation tier               | 3     | Ceiling prevents infinite escalation             |
| Min notification spacing          | 30 min| Prevents burst-feeling notifications             |
| Restart shields per month (paid)  | 1     | Scarcity maintains product integrity             |
| Restart shields (free)            | 0     | Paid-only feature                                |

---

## Notification Scheduling

All notification times are relative to the user's check-in window, not absolute clock times.

```
window_open  = commitment_deadline       (default 09:00)
window_close = checkin_window_close      (default 22:00)
window_mid   = window_open + (window_close - window_open) / 2

TIER 0:
    notify_at: [window_mid]

TIER 1:
    notify_at: [window_mid, window_close - 1hr]

TIER 2:
    notify_at: [window_mid, window_close - 2hr, window_close - 30min]

TIER 3:
    notify_at: [window_mid, window_close - 2hr, window_close - 30min]
    badge: persistent until check-in
```

**Suppression rule:** If the user checks in before a scheduled notification, all remaining notifications for that day are cancelled.

---

## Edge Cases

| Scenario                                    | Behavior                                                    |
|:--------------------------------------------|:------------------------------------------------------------|
| User changes timezone mid-day               | Current day's schedule is unchanged; next day uses new TZ   |
| User sets commitment at 8:55 AM (5min before deadline) | Commitment locks at 9:00 AM as normal                |
| No commitment set by deadline               | Day treated as MISSED; escalation advances                  |
| User checks in YES then wants to change to NO | Not allowed; check-in is final and irreversible          |
| App is uninstalled and reinstalled           | Local data persists if not cleared; tier and streak survive |
| Device is offline at notification time       | iOS handles local notification delivery when back online    |
| Restart Shield used on same day as NO        | Shield must be activated within 1 hour of NO check-in       |

---

## Implementation Notes

- All escalation logic should be implemented as a pure function: `(currentState, checkInResult) → newState`
- No server calls required — runs entirely on-device
- Notification scheduling uses `UNNotificationRequest` with calculated fire dates
- State is persisted in `UserDefaults` (simple key-value) since it's a small, flat structure
- The state machine should be unit-testable in isolation from UI
