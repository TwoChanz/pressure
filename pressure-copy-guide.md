# Copy & Tone Guide

## Overview

Pressure's copy is the product. Every notification, label, and status message is a touchpoint that reinforces the brand. This guide defines the voice for both personality modes across every user-facing surface.

---

## Voice Principles

### Professional Mode

- **Tone:** Direct, clear, no-nonsense
- **Personality:** A good manager who doesn't sugarcoat but isn't cruel
- **Sentence length:** Short to medium, declarative
- **Never:** Sarcastic, condescending, or passive-aggressive
- **Always:** Respectful, factual, forward-looking

### Brutal Mode

- **Tone:** Confrontational, sharp, zero patience
- **Personality:** A drill sergeant who respects you enough to be honest
- **Sentence length:** Short, punchy, fragmented
- **Never:** Mean-spirited, personal attacks on identity, cruel about circumstances
- **Always:** Challenging behavior (not character), direct, slightly darkly humorous
- **Key boundary:** Brutal challenges what you *did* (or didn't do), never who you *are*

---

## Notification Copy

### First Reminder — Tier 0

| Mode         | Copy                                                        |
|:-------------|:------------------------------------------------------------|
| Professional | "You committed to [task]. Check in when it's done."         |
| Brutal       | "[Task]. Did you do it or not?"                             |

### Escalation Reminder — Tier 1

| Mode         | Copy                                                                  |
|:-------------|:----------------------------------------------------------------------|
| Professional | "You haven't checked in yet. Your window closes at [time]."          |
| Brutal       | "Still nothing. Clock's running. [Time] and it's a miss."            |

### Escalation Reminder — Tier 2

| Mode         | Copy                                                                                    |
|:-------------|:----------------------------------------------------------------------------------------|
| Professional | "Two days missed. Your streak is broken. Today is a reset — don't waste it."           |
| Brutal       | "Two days. Zero streak. You're building a habit of quitting. Prove me wrong."          |

### Escalation Reminder — Tier 3

| Mode         | Copy                                                                                                              |
|:-------------|:------------------------------------------------------------------------------------------------------------------|
| Professional | "This is day [N] without follow-through. The app only works if you use it honestly."                             |
| Brutal       | "Day [N] of nothing. At this point you're just keeping the app installed to feel productive. Open it or delete it."|

### Success — After YES Check-In

| Mode         | Copy                                    |
|:-------------|:----------------------------------------|
| Professional | "Done. Streak: [N] days."              |
| Brutal       | "Finally. [N] days. Don't stop."       |

### Failure — After NO Check-In

| Mode         | Copy                                                        |
|:-------------|:------------------------------------------------------------|
| Professional | "Streak reset. Tomorrow is a new commitment."               |
| Brutal       | "Streak's dead. You killed it. Tomorrow you start at zero." |

### Missed — Window Closed Without Check-In

| Mode         | Copy                                                                        |
|:-------------|:----------------------------------------------------------------------------|
| Professional | "Your check-in window closed. Today is marked as missed."                  |
| Brutal       | "Window's closed. You didn't even bother to say no. That's worse."         |

---

## In-App Copy

### Home Screen States

| State                        | Professional                              | Brutal                                       |
|:-----------------------------|:------------------------------------------|:---------------------------------------------|
| Commitment set, not due yet  | "Your commitment is locked."              | "It's locked. No take-backs."                |
| No commitment set (pre-deadline) | "Set your commitment for today."     | "What are you doing today? Decide."          |
| Deadline passed, no commitment | "No commitment set. Today is a miss."   | "You didn't even try today."                 |
| Checked in YES               | "Done for today."                         | "Done. Come back tomorrow."                  |
| Checked in NO                | "Acknowledged. Tomorrow is a new day."    | "At least you were honest. Do better."       |
| Missed                       | "Yesterday was missed."                   | "Yesterday was a waste."                     |

### Streak Display

| Scenario         | Professional                    | Brutal                               |
|:-----------------|:--------------------------------|:-------------------------------------|
| Streak = 0       | "Start your streak today."      | "Zero. Fix it."                      |
| Streak 1–3       | "[N] day streak"                | "[N] days. Barely started."          |
| Streak 4–7       | "[N] day streak"                | "[N] days. Don't get comfortable."   |
| Streak 8–14      | "[N] day streak"                | "[N] days. Now it counts."           |
| Streak 15–30     | "[N] day streak"                | "[N] days. Took you long enough."    |
| Streak 30+       | "[N] day streak"                | "[N] days. Respect."                 |

### Restart Shield Activation

| Mode         | Copy                                                                             |
|:-------------|:---------------------------------------------------------------------------------|
| Professional | "Restart Shield activated. Your streak resets but escalation holds steady."      |
| Brutal       | "Shield used. Streak's still dead — but the pressure won't get worse. This time."|

---

## Onboarding Copy

### Step 1: Cold Open

> **"What's the one thing you need to do tomorrow?"**

- Subtext: none. The question stands alone.
- Input: single text field, no placeholder text, blinking cursor

### Step 2: Personality Preview

> **"Which voice do you want in your head?"**

Left column shows the user's commitment in Professional reminder format.
Right column shows the same commitment in Brutal reminder format.

- Professional label: "Professional"
- Brutal label: "Brutal" with a small "PRO" badge
- Toggle between them, default: Professional

### Step 3: Notification Permission

> **"Pressure only works if it can reach you."**
>
> "Without notifications, the app can't hold you accountable."

- Button: "Enable Notifications"
- Skip link: small, de-emphasized "Not now" text below

### Step 4: Set Deadline

> **"Your commitment locks at this time. No edits after."**

- Two time pickers: commitment deadline (default 9:00 AM) and check-in window close (default 10:00 PM)
- Subtext: "You can change these later in settings."

---

## Writing Rules

1. **No exclamation marks.** Pressure doesn't cheer. Even success copy is understated.
2. **No emojis.** The brand is text-only, typographic, minimal.
3. **No questions in Brutal mode** (except rhetorical). Brutal tells, it doesn't ask.
4. **Professional can ask one question** per interaction, max.
5. **Always use the user's actual commitment text** in notifications, not a generic placeholder.
6. **Keep notifications under 120 characters** for full visibility on lock screens.
7. **Never reference other users, stats, or comparisons.** This is a solo accountability tool.
8. **Never use motivational language** ("You've got this!", "Keep going!"). The closest Pressure gets to encouragement is acknowledging the streak count.
9. **Brutal mode should occasionally be darkly funny**, not just mean. The humor comes from honesty, not cruelty.
10. **Capitalize the app name** as "Pressure" in all user-facing copy.

---

## Copy Expansion Template

When adding new notification types or UI states, use this template:

```
Scenario:    [describe the trigger]
Context:     [what the user just did or didn't do]
Professional: [draft — direct, respectful, factual]
Brutal:       [draft — confrontational, short, challenges behavior not character]
Char count:  [must be under 120 for notifications]
```
