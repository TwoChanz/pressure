# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Pressure is an iOS accountability app. Users set one daily commitment, check in YES/NO, and receive escalating notifications based on follow-through. The core viral mechanic is the copy itself — notifications are designed to be screenshot-worthy, especially in Brutal mode.

The repo is currently in the **documentation/planning phase** with no source code yet. All `.md` files in the root are product specifications that serve as the implementation blueprint.

## Planned Tech Stack

| Layer | Technology |
|:------|:-----------|
| Platform | iOS (iPhone priority), Swift 5.9+ |
| UI | SwiftUI |
| Storage | UserDefaults (settings, escalation state) + Core Data (commitment records) |
| Notifications | UNUserNotificationCenter (local only, no server) |
| Subscriptions | StoreKit 2 |
| Architecture | MVVM + State Machine |
| Testing | XCTest + Swift Testing |
| Min Target | iOS 16+ |

## Architecture

### Escalation Engine (Core Logic)

The state machine is the heart of the app. It must be a **pure function**: `(EscalationState, CheckInResult) -> EscalationState`. No UI, no side effects.

- **4 tiers** (0-3): Baseline -> Nudge -> Push -> Alarm
- Advancement: each consecutive NO/MISSED increments tier (1 miss = T1, 2 = T2, 3+ = T3)
- De-escalation: goes straight to T0 after N consecutive YES days (T1: 1 YES, T2: 2 YES, T3: 3 YES)
- Restart Shield (paid only): prevents tier advancement on miss, but streak still resets

### Data Model

- **Commitment** (Core Data): one record per calendar day, status transitions are one-way (PENDING -> YES/NO/MISSED)
- **UserSettings** (UserDefaults): personality_mode, commitment_deadline, checkin_window_close, timezone, subscription_tier
- **EscalationState** (UserDefaults): current_tier, consecutive_misses/successes, current_streak, longest_streak, shields

All timestamps stored in UTC. Local timezone used only for display and notification scheduling.

### Personality System

All user-facing copy goes through a `CopyProvider` protocol with two implementations:
- `ProfessionalCopy` — direct, respectful, factual
- `BrutalCopy` — confrontational, short, challenges behavior not character (paid feature)

### Notification Scheduling

Times are relative to the user's check-in window, not absolute:
- T0: 1 notification (window midpoint)
- T1: 2 notifications (midpoint, close - 1hr)
- T2/T3: 3 notifications (midpoint, close - 2hr, close - 30min)
- T3 has persistent badge until check-in
- Max 3 notifications/day, min 30min spacing
- All cancelled on check-in

## Specification Documents

| File | Contents |
|:-----|:---------|
| `pressure-escalation-engine.md` | State machine transitions, tier definitions, edge cases |
| `pressure-data-model.md` | Core Data schema, UserDefaults keys, migration paths |
| `pressure-copy-guide.md` | All user-facing copy for both personality modes, writing rules |
| `pressure-onboarding-flow.md` | 5-screen onboarding spec, analytics events |
| `pressure-implementation-roadmap.md` | 5-phase build plan, tech stack, risk register |
| `pressure-growth-metrics.md` | Growth loops, funnel metrics, event tracking schema |
| `pressure-launch-growth-strategy.md` | Launch strategy, ASO, monetization |

## Copy Rules

These are non-negotiable for all user-facing text:
- No exclamation marks, no emojis, no motivational language
- Notifications must be under 120 characters
- Always use the user's actual commitment text, not placeholders
- Brutal mode challenges behavior, never identity
- Never reference other users or comparisons (solo accountability tool)
- App name is always capitalized as "Pressure"

## Development Phases (Planned)

1. Core Data layer + EscalationEngine (pure function, full test coverage)
2. Home screen + check-in flow (daily loop without notifications)
3. Notification system (tier-aware, personality-aware scheduling)
4. Onboarding (5 screens) + Settings
5. StoreKit 2 + feature gating + polish
