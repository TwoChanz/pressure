# Data Model & Schema Reference

## Overview

Pressure uses a local-first storage architecture. All data lives on-device using Core Data (structured records) and UserDefaults (settings and lightweight state). Cloud sync is a post-MVP concern and is not addressed in this document.

All timestamps are stored in UTC. The device's local timezone is used for display and notification scheduling only.

---

## Entity Relationship Diagram

```
┌──────────────────────┐       ┌──────────────────────┐
│     UserSettings     │       │      Commitment      │
│──────────────────────│       │──────────────────────│
│ personality_mode     │       │ id (UUID, PK)        │
│ commitment_deadline  │       │ date (Date)          │
│ checkin_window_close │       │ text (String)        │
│ timezone_offset      │       │ locked_at (Date?)    │
│ notifications_enabled│       │ status (Enum)        │
│ onboarding_completed │       │ checked_in_at (Date?)│
│ subscription_tier    │       │ escalation_tier_snap │
│──────────────────────│       │ shield_used (Bool)   │
│ Stored: UserDefaults │       │──────────────────────│
└──────────────────────┘       │ Stored: Core Data    │
                               └──────────────────────┘

┌──────────────────────┐
│   EscalationState    │
│──────────────────────│
│ current_tier (0-3)   │
│ consecutive_misses   │
│ consecutive_successes│
│ current_streak       │
│ longest_streak       │
│ restart_shields_used │
│ shield_reset_date    │
│──────────────────────│
│ Stored: UserDefaults │
└──────────────────────┘
```

---

## Commitment Record

The primary data entity. One record per calendar day, max.

| Field                | Type          | Constraints                    | Notes                                        |
|:---------------------|:--------------|:-------------------------------|:---------------------------------------------|
| `id`                 | UUID          | Primary key, auto-generated    |                                              |
| `date`               | Date          | Unique, indexed                | Calendar date only (no time component)       |
| `text`               | String        | Max 280 characters, non-empty  | The commitment text                          |
| `locked_at`          | Date?         | Nullable                       | Set when commitment deadline passes          |
| `status`             | Enum          | PENDING, YES, NO, MISSED       | Default: PENDING                             |
| `checked_in_at`      | Date?         | Nullable                       | Timestamp of YES or NO submission            |
| `escalation_tier_snap`| Int (0-3)    |                                | Snapshot of tier at time of check-in         |
| `shield_used`        | Bool          | Default: false                 | Whether Restart Shield was applied this day  |

### Status Transitions

```
PENDING ──► YES        (user taps YES before window close)
PENDING ──► NO         (user taps NO before window close)
PENDING ──► MISSED     (window closes with no action)
```

All transitions are **one-way and irreversible**. Once a status is set, it cannot be changed.

### No-Commitment Days

If the commitment deadline passes with no commitment text entered:
- A record is created with `text = ""` and `status = MISSED`
- `locked_at` is set to the deadline time
- This counts identically to a missed check-in for escalation purposes

---

## User Settings

Lightweight key-value pairs stored in UserDefaults.

| Key                      | Type    | Default           | Range / Options                         |
|:-------------------------|:--------|:------------------|:----------------------------------------|
| `personality_mode`       | String  | `"PROFESSIONAL"`  | `PROFESSIONAL`, `BRUTAL`                |
| `commitment_deadline`    | String  | `"09:00"`         | `06:00` – `12:00` (30-min increments)   |
| `checkin_window_close`   | String  | `"22:00"`         | `18:00` – `23:59` (30-min increments)   |
| `timezone_identifier`    | String  | Device default    | IANA timezone string                    |
| `notifications_enabled`  | Bool    | `false`           | Set after OS permission granted         |
| `onboarding_completed`   | Bool    | `false`           |                                         |
| `subscription_tier`      | String  | `"FREE"`          | `FREE`, `PAID`                          |
| `subscription_expiry`    | Date?   | `nil`             | For local validation                    |

---

## Escalation State

Runtime state for the escalation engine. Stored in UserDefaults for fast access.

| Key                        | Type  | Default | Notes                                             |
|:---------------------------|:------|:--------|:--------------------------------------------------|
| `current_tier`             | Int   | `0`     | Range: 0–3                                        |
| `consecutive_misses`       | Int   | `0`     | Resets to 0 on any YES                            |
| `consecutive_successes`    | Int   | `0`     | Resets to 0 on any NO/MISS                        |
| `current_streak`           | Int   | `0`     | Consecutive YES days                              |
| `longest_streak`           | Int   | `0`     | All-time high                                     |
| `restart_shields_remaining`| Int   | `0`     | Max 1 for paid users; resets monthly              |
| `shield_reset_date`        | Date? | `nil`   | First of next month; triggers shield replenishment|

---

## Derived Values

These are computed at runtime, not stored:

| Value                  | Derivation                                                        |
|:-----------------------|:------------------------------------------------------------------|
| `is_commitment_locked` | `current_time >= commitment_deadline` for today                   |
| `is_window_open`       | `current_time >= commitment_deadline AND current_time < window_close` |
| `can_check_in`         | `is_window_open AND today_commitment.status == PENDING`           |
| `days_since_last_yes`  | Count of consecutive non-YES days looking backward from today     |
| `streak_display`       | `current_streak` (stored for performance, derivable from records) |

---

## Notification Records

Local notifications are scheduled, not stored as persistent data. However, for debugging and future analytics, a lightweight log is useful.

| Field            | Type   | Notes                                           |
|:-----------------|:-------|:------------------------------------------------|
| `id`             | UUID   | Matches `UNNotificationRequest` identifier      |
| `scheduled_for`  | Date   | When the notification is set to fire            |
| `tier`           | Int    | Escalation tier at time of scheduling           |
| `personality`    | String | Mode at time of scheduling                      |
| `delivered`      | Bool   | Updated via `UNUserNotificationCenter` delegate |
| `tapped`         | Bool   | Updated when user opens app from notification   |

---

## Migration Path

### MVP → Cloud Sync (Post-MVP)

The schema is designed for easy migration:

1. **Commitment records** map 1:1 to a server-side table with a `user_id` foreign key
2. **Escalation state** can be computed server-side from commitment history (the stored values are a cache, not source of truth)
3. **User settings** become a user profile object
4. **Conflict resolution:** Last-write-wins is sufficient since this is a single-user, single-device app in MVP. Multi-device sync will need timestamp-based merging on the commitment record level.

### MVP → Multiple Commitments (Post-MVP)

The current schema supports this with minimal changes:

- Remove the unique constraint on `Commitment.date`
- Add a `sort_order` field to Commitment
- Escalation state moves from global (UserDefaults) to per-commitment or uses the worst-case tier across all commitments

---

## Storage Size Estimates

| Data                    | Size per record | Records per year | Annual size |
|:------------------------|:----------------|:-----------------|:------------|
| Commitment record       | ~200 bytes      | 365              | ~73 KB      |
| Notification log entry  | ~100 bytes      | ~1,095 (3/day)   | ~110 KB     |
| Settings + state        | ~500 bytes      | 1 (static)       | ~500 bytes  |

Total annual storage: under 200 KB. No storage concerns for local-first architecture.
