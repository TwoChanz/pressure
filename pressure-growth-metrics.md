# Growth & Metrics Framework

## Overview

Pressure's growth model is built on a single insight: **the product's copy is the viral mechanic.** Users don't share habit trackers — they screenshot notifications that made them laugh, wince, or feel called out. Every design decision should be evaluated against this lens.

---

## Growth Loops

### Loop 1: The Screenshot Loop (Primary)

```
User receives Brutal notification
        │
        ▼
Notification is funny / sharp / relatable
        │
        ▼
User screenshots and shares (Twitter, group chat, Stories)
        │
        ▼
Friend sees it, searches "Pressure app"
        │
        ▼
Downloads → Onboarding → Sees Brutal preview → Subscribes or starts free
```

**Lever:** Copy quality. Every Tier 2–3 Brutal notification should be screenshot-worthy.

**Metric:** Track share events (if share button implemented) or proxy via App Store search term "pressure accountability."

### Loop 2: The Streak Flex (Secondary)

```
User builds a long streak (14+ days)
        │
        ▼
Streak becomes part of identity ("I'm on day 47")
        │
        ▼
Mentions in conversation / social media
        │
        ▼
Curiosity-driven download
```

**Lever:** Make the streak count visible and easy to reference. Widget on home screen. Clean number, no clutter.

**Metric:** Average streak length, widget adoption rate.

### Loop 3: The Failure Story (Tertiary)

```
User misses → Tier 3 notification hits hard
        │
        ▼
User resets and recommits
        │
        ▼
Talks about the experience ("this app called me out")
        │
        ▼
Word-of-mouth acquisition
```

**Lever:** Tier 3 copy must hit hard enough to be memorable, not so hard it causes deletion.

**Metric:** Tier 3 retention (% of users who check in the day after hitting Tier 3).

---

## Funnel Metrics

### Acquisition

| Metric                        | Definition                                          | Target      |
|:------------------------------|:----------------------------------------------------|:------------|
| App Store conversion rate     | Impressions → Downloads                             | 30%+        |
| Search term diversity         | Organic search terms leading to downloads           | Track trend |
| Attribution source            | Organic vs. paid (MVP is organic only)              | 90% organic |

### Activation

| Metric                        | Definition                                          | Target      |
|:------------------------------|:----------------------------------------------------|:------------|
| Onboarding completion rate    | Step 1 started → Home screen reached                | 80%+        |
| Notification grant rate       | Users who enable notifications during onboarding    | 70%+        |
| Day-1 commitment set rate     | Users with a commitment set within 24h of install   | 90%+        |
| First check-in rate           | Users who complete at least one YES or NO            | 75%+        |

### Engagement

| Metric                        | Definition                                          | Target      |
|:------------------------------|:----------------------------------------------------|:------------|
| Daily check-in rate           | % of active users who check in on any given day     | 65%+        |
| 7-day check-in consistency    | Users with 5+ check-ins in a rolling 7-day window   | 50%+        |
| Average streak length         | Mean consecutive YES days across all users           | 5+ days     |
| Median streak length          | Median (more resistant to outliers)                  | 3+ days     |
| Escalation tier distribution  | % of users at each tier on any given day            | Monitor     |

### Retention

| Metric                        | Definition                                          | Target      |
|:------------------------------|:----------------------------------------------------|:------------|
| Day-1 retention               | % returning day after install                       | 60%+        |
| Day-7 retention               | % active 7 days after install                       | 40%+        |
| Day-30 retention              | % active 30 days after install                      | 25%+        |
| Tier 3 next-day return        | % who open app day after hitting Tier 3             | 50%+        |
| Notification-off churn rate   | Churn rate for users without notifications enabled  | Track       |

### Monetization

| Metric                        | Definition                                          | Target      |
|:------------------------------|:----------------------------------------------------|:------------|
| Day-14 conversion rate        | % of Day-14 active users who subscribe              | 5%+         |
| Brutal mode tap rate          | % of onboarding users who tap the Brutal preview    | 60%+        |
| Trial start rate              | % who start a free trial (if offered)               | 15%+        |
| Trial → Paid conversion       | % of trial starters who convert                     | 40%+        |
| Monthly churn (subscribers)   | % of subscribers who cancel per month               | <8%         |
| Restart Shield usage rate     | % of paid users who use their monthly shield        | 30–50%      |
| LTV (12-month)                | Projected lifetime value per subscriber             | Track       |

---

## Cohort Analysis Framework

### Primary Cohorts

Segment users by these dimensions to identify what drives retention and conversion:

1. **Personality mode:** Professional vs. Brutal — does Brutal retain better or worse?
2. **Notification status:** Enabled vs. denied — quantify the retention gap
3. **Onboarding commitment quality:** Short/vague ("be productive") vs. specific ("ship the landing page") — does specificity predict streak length?
4. **First-week pattern:** Users who hit NO or MISSED in week 1 vs. those who don't — does early failure predict churn or engagement?

### Key Questions to Answer Post-Launch

- Does Brutal mode improve retention or hurt it? (Hypothesis: improves, because it creates emotional investment)
- What's the notification-off retention penalty? (Hypothesis: 50%+ lower day-7 retention)
- Is there a "magic number" for streak length that predicts long-term retention? (Hypothesis: users who hit 7-day streak are 3x more likely to be active at Day 30)
- Do users who hit Tier 3 and recover become stronger users? (Hypothesis: yes — the recovery moment creates commitment)

---

## Anti-Metrics

Things that look good but don't actually indicate product health:

| Anti-Metric              | Why It's Misleading                                              |
|:-------------------------|:-----------------------------------------------------------------|
| Total downloads          | Vanity metric; says nothing about activation or retention        |
| Average session duration | Pressure is designed for <10 second interactions; longer is bad  |
| DAU/MAU ratio alone      | Without check-in completion, DAU could just be "opened and closed"|
| Streak length without YES rate | A user could game streaks with trivial commitments          |

---

## Event Tracking Schema

Minimal event set for MVP analytics. Structured for future integration with any analytics provider.

```
// Onboarding
onboarding_started
onboarding_commitment_entered      { text_length: Int }
onboarding_personality_previewed
onboarding_brutal_tapped
onboarding_personality_selected    { mode: String }
onboarding_notification_granted
onboarding_notification_denied
onboarding_notification_skipped
onboarding_deadline_changed        { deadline: String, window_close: String }
onboarding_completed               { duration_seconds: Int }

// Daily Loop
commitment_set                     { text_length: Int, minutes_before_deadline: Int }
commitment_missed                  // deadline passed with no commitment
checkin_yes                        { streak: Int, tier: Int, minutes_before_close: Int }
checkin_no                         { tier: Int }
checkin_missed                     { tier: Int }

// Escalation
tier_advanced                      { from: Int, to: Int }
tier_deescalated                   { from: Int, to: Int }
restart_shield_used                { tier: Int, streak_at_use: Int }

// Notifications
notification_scheduled             { tier: Int, personality: String }
notification_delivered             { tier: Int }
notification_tapped                { tier: Int }

// Subscription
paywall_shown                      { source: String }  // "onboarding", "settings", "brutal_tap"
trial_started
subscription_purchased             { plan: String }     // "monthly", "annual"
subscription_cancelled
subscription_restored

// Settings
personality_changed                { from: String, to: String }
deadline_changed                   { old: String, new: String }
window_changed                     { old: String, new: String }
notification_reenabled
```

---

## Launch Checklist (Growth-Specific)

- [ ] App Store listing copy emphasizes the personality mechanic, not features
- [ ] Screenshots show Brutal mode notifications (the hook)
- [ ] App Store subtitle: "Accountability that doesn't care about your feelings"
- [ ] Category: Productivity (not Health & Fitness — different competitive set)
- [ ] Keywords target: accountability, habit, streak, discipline, pressure
- [ ] No social media accounts needed at launch — let organic sharing happen first
- [ ] Monitor App Store reviews for copy feedback (Brutal too harsh? Not harsh enough?)
- [ ] Track search term "pressure app" / "pressure accountability" as organic signal
