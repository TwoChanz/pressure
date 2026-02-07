# Pressure — Launch & Growth Strategy

## Document Purpose

Actionable first-move playbook for achieving profitability through organic acquisition and high retention. Every section maps directly to work that starts before or immediately after App Store approval.

---

## Part 1: Financial Foundation (Profitability Path)

### 1.1 Unit Economics — Know Your Numbers Before Launch

Before writing a single App Store description, establish these baselines:

| Metric | Definition | Launch Target | 90-Day Target |
|--------|-----------|---------------|---------------|
| **ARPU** | Revenue / total users (including free) | $0.15/mo | $0.40/mo |
| **ARPPU** | Revenue / paying users only | $4.99/mo | $4.99/mo |
| **Conversion Rate** | Free → paid within 30 days | 3% | 5%+ |
| **Monthly Churn** | Paid subscribers lost per month | <10% | <8% |
| **LTV (Paid)** | ARPPU / monthly churn rate | $50+ | $62+ |
| **CAC** | $0 (organic only at launch) | $0 | $0 |
| **Breakeven Users** | Paying subscribers needed to cover Apple Developer fee + tools | ~20 | Maintain |

With $0 CAC and a $4.99/mo subscription, profitability math is simple: **every paying subscriber is immediately profitable**. The only costs are the $99/year developer account and any analytics tooling. This means the real question isn't "when do we break even" — it's "how fast can we convert free users to paid."

### 1.2 Pricing Architecture

**Immediate implementation (Phase 5 of roadmap):**

| Tier | Price | Features Gated |
|------|-------|----------------|
| **Free** | $0 | Professional mode, full escalation engine, unlimited commitments, streak tracking |
| **Pressure Pro (Monthly)** | $4.99/mo | Brutal mode, Restart Shield (1/month) |
| **Pressure Pro (Annual)** | $39.99/yr (~$3.33/mo) | Same as monthly — 33% savings |

**Why this works:**
- Free tier is genuinely useful — users experience the full accountability loop
- Brutal mode is the "want" lever — onboarding shows it, social screenshots feature it, but you can't select it without paying
- Annual plan exists from day one to improve LTV and reduce churn (annual subscribers churn 50-70% less than monthly)
- No lifetime deal. Ever. Recurring revenue is the entire business model.

**Trial strategy:**
- 7-day free trial of Pressure Pro, triggered at two moments:
  1. Onboarding Screen 2 (personality preview) — user taps Brutal, sees trial CTA
  2. Day 3 post-install — if user has checked in 2+ times and hasn't trialed, surface a non-blocking prompt: "You've shown up [N] days straight. Want to see what Brutal mode sounds like?" (Professional voice)
- Trial auto-converts to monthly unless cancelled
- No trial for annual plan — monthly trial converts, then offer annual discount at day 30

### 1.3 Revenue Milestones

| Milestone | Paying Subscribers | Monthly Revenue | Timeline Target |
|-----------|-------------------|-----------------|----------------|
| Ramen profitable | 50 | ~$200/mo (after Apple's cut) | Month 2–3 |
| Tool costs covered | 100 | ~$400/mo | Month 4 |
| Sustainable solo project | 500 | ~$1,750/mo | Month 6–9 |
| Real business | 2,000 | ~$7,000/mo | Month 12–18 |

These are conservative. At 5% conversion and <8% monthly churn, reaching 500 paying subscribers requires ~10,000 total installs — achievable organically in 6–9 months with the screenshot loop working.

---

## Part 2: Organic Traffic Acquisition

### 2.1 Pre-Launch (Weeks -4 to 0)

**App Store Optimization — this is the only "channel" that matters at launch.**

The App Store listing is the landing page. Every word counts.

**App Name:** Pressure — Daily Accountability

**Subtitle:** Accountability that doesn't care about your feelings

**Keywords (100-char limit):** `accountability,habit,streak,discipline,commitment,daily,routine,motivation,pressure,productive`

**Description structure (first 3 lines visible before "more"):**
```
Pressure asks you one question every day: did you do the thing you said you'd do?

No charts. No streaks dressed up as progress. No "great job!" for showing up.
You either did it or you didn't. Pressure remembers.
```

Remainder of description covers:
- How the daily loop works (3 sentences)
- What happens when you miss (escalation, briefly)
- Brutal mode teaser ("For subscribers: a voice that doesn't sugarcoat anything")
- No feature bullet lists. Write it like copy, not a spec sheet.

**Screenshots (6 required, prioritize first 3):**

| Position | Content | Purpose |
|----------|---------|---------|
| 1 | Lock screen showing Tier 2 Brutal notification | Stop the scroll. This is the ad. |
| 2 | Home screen with active commitment + streak counter | Show simplicity of the daily loop |
| 3 | Side-by-side Professional vs. Brutal personality preview | Tease the paid feature |
| 4 | Tier 3 notification sequence (3 messages) | Show escalation intensity |
| 5 | Clean settings screen | Signal quality/polish |
| 6 | Onboarding cold open screen | Show the "what's your commitment" entry point |

**Category:** Productivity (not Health & Fitness — less competition, better intent match)

**App Preview Video:** Do not create one for launch. Screenshots of notifications are more compelling than a walkthrough video. Revisit at 1,000+ reviews.

### 2.2 Launch Week (Days 0–7)

**Zero paid marketing. Zero influencer outreach. Zero social media accounts.**

The entire launch strategy is:

1. **Submit to App Store** with optimized listing above
2. **Post on exactly 3 communities** where accountability-seeking users already gather:
   - r/getdisciplined (Reddit, 1M+ members) — frame as "I built this for myself, sharing in case it's useful"
   - r/productivity (Reddit, 2M+ members) — same framing
   - Hacker News (Show HN) — lean into the technical simplicity ("local-first, no server, no social features, just pressure")
3. **Do not post to Product Hunt yet.** Save it for the Week 4 push when you have real user data and testimonials.

**Why only 3 posts:**
- Cold launches with zero social proof need authentic framing
- "I built this" posts on Reddit/HN have a specific shelf life — you get one shot per community
- The goal isn't downloads, it's **seeding the screenshot loop** — you need 50–100 users who actually use the app before organic growth kicks in

### 2.3 Weeks 2–8: Feeding the Screenshot Loop

The growth-metrics doc correctly identifies the screenshot loop as the primary viral mechanic. Here's how to operationalize it:

**Make screenshots effortless:**
- Notifications already render beautifully on lock screen (under 120 chars per copy guide)
- Add a subtle "Share" button to the check-in confirmation screen that generates a pre-formatted image of today's commitment + streak count + personality mode badge
- Share image format: dark background, white text, "Pressure" wordmark at bottom — designed to look good on Instagram Stories, Twitter, and iMessage

**Fuel the loop with copy quality:**
- The Tier 2 and Tier 3 Brutal copy is the product's advertising. Treat copy updates as growth engineering, not content writing.
- Track: `notification_screenshot_taken` (iOS provides screenshot detection) correlated with tier and personality mode
- If specific notification copies get screenshotted more, create more in that style

**Identify and nurture power users:**
- Users who hit 14+ day streaks are your evangelists
- At Day 14: surface a one-time, dismissable card: "14 days. You're in the top [X]% of Pressure users. If this is working for you, a review helps others find it." (Link to App Store review)
- At Day 30: same pattern, but the ask is a share — "30 days. Screenshot your streak if you want. Or don't. It's your thing."
- Never nag. Each prompt appears once, ever.

### 2.4 Weeks 8+: Sustained Organic Channels

Once the screenshot loop has evidence of working (measurable via App Store search term diversity and install source data):

**Product Hunt Launch:**
- Time it for a Tuesday (highest traffic)
- Lead with real user quotes from App Store reviews
- Tagline: "The accountability app that roasts you when you skip"
- Maker comment includes real Tier 3 notification screenshot

**App Store Review Velocity:**
- Reviews drive ranking. Ranking drives organic installs.
- Prompt for review at two high-sentiment moments:
  1. After a streak milestone (Day 14, Day 30) — emotion is positive
  2. After a successful Restart Shield use — user just avoided consequences, gratitude is high
- Never prompt after a miss or failure. Never prompt more than once per 60 days (iOS limits this anyway).

**SEO-Adjacent Content (Month 3+, only if growth stalls):**
- Single-page site: `pressure.app` (or similar)
- One page, not a blog. Content: "What is Pressure?" + App Store link + 3 notification screenshots
- Target long-tail: "accountability app that yells at you," "harsh habit tracker," "brutal accountability"
- No blog. No content marketing. The app's screenshots ARE the content.

---

## Part 3: User Retention Strategy

### 3.1 The Retention Problem for Accountability Apps

Most accountability apps follow this curve:
- Day 1: 100% (novelty)
- Day 7: 25–35% (habit hasn't formed)
- Day 30: 10–15% (guilt/avoidance → uninstall)

Pressure's escalation engine is designed to fight this, but escalation alone can become a reason to leave. The strategy below addresses each drop-off point.

### 3.2 Day 1–3: Activation Lock-In

**Goal:** User completes at least 2 check-ins in the first 3 days.

**Tactics:**
- Onboarding ends with commitment already set and first notification already scheduled — zero gap between "install" and "first value moment"
- Day 1 notification fires at the exact midpoint of user's check-in window (they chose this time, so they're likely available)
- If user checks in YES on Day 1, Day 2 notification copy acknowledges it: "Day 2. Yesterday happened. Do it again." (Professional) / "Day 2. One day means nothing. Do it again." (Brutal)
- If user does NOT open the app on Day 1 after notification, escalation engine moves to Tier 1 — second notification next day hits harder

**Critical metric:** `first_checkin_completed` within 24 hours of `onboarding_completed`. Target: 75%+. If below 60%, the onboarding-to-first-notification gap is too long — tighten the default check-in window.

### 3.3 Day 4–14: Habit Formation Window

**Goal:** User builds a streak of 5+ days and experiences at least one failure-recovery cycle.

**Tactics:**
- Streak counter becomes visible and meaningful around Day 5 — copy acknowledges: "Five days. This is where most people stop. Don't." (Brutal)
- If user misses for the first time after a streak, the recovery copy is calibrated to pull them back, not shame them away:
  - Professional: "Streak reset. The commitment field is open when you're ready."
  - Brutal: "Streak's gone. You know that. Question is whether tomorrow's different."
- **Restart Shield trial prompt (paid conversion opportunity):** If a user with 5+ day streak hits their first miss AND is not a subscriber, show: "Your streak just reset. Pressure Pro includes a Restart Shield — one save per month. Want to try it?" This is the highest-intent conversion moment in the entire funnel.

**Critical metric:** `day_7_retention` by cohort (personality mode, notification-granted vs. denied). Target: 40%+. The personality-mode cohort split will reveal whether Brutal retains better or worse — this is the single most important product question for Month 1.

### 3.4 Day 14–30: Subscription Conversion Window

**Goal:** Convert engaged free users to paid. Retain paid users past first renewal.

**Tactics:**
- Day 14 is the natural conversion trigger (per growth-metrics doc). Users who've checked in 10+ times in 14 days are highly engaged.
- Conversion prompt at Day 14 (non-blocking, dismissable):
  - "You've been showing up. Brutal mode and Restart Shields are available with Pressure Pro."
  - Single "Start Free Trial" button. "Not now" dismisses permanently.
- For users already on trial: trial expiry notification at 24 hours before conversion:
  - "Your Pressure Pro trial ends tomorrow. Your personality stays set to [mode]. If you cancel, you'll switch back to Professional."
  - This leverages loss aversion — they've been using Brutal for 7 days and don't want to lose it.

**Critical metric:** `trial_start_to_paid_conversion`. Target: 40%+. If below 30%, the trial is too long (shorten to 5 days) or the gated features aren't compelling enough (consider gating streak milestones or advanced notification scheduling).

### 3.5 Day 30+: Long-Term Retention

**Goal:** Reduce monthly churn below 8% for paid subscribers.

**Tactics:**
- **Streak milestones as re-engagement hooks:** At 30, 60, 90, 180, 365 days — surface a milestone acknowledgment. Keep it brief and in-character.
  - Professional (Day 90): "90 days of showing up. That's a quarter of a year."
  - Brutal (Day 90): "90 days. You're not special — you're consistent. That's better."
- **Notification fatigue prevention:** If a user checks in YES within 5 minutes of the first notification for 14+ consecutive days, they don't need reminders — they've built the habit. Offer (once): "You've been checking in before we even remind you. Want to switch to a single daily notification?" Reducing notification load for habituated users prevents the "this app is annoying" uninstall.
- **Win-back for churned users:** If a paid subscriber cancels:
  - At cancellation: "Subscription cancelled. You'll have Pro access until [date]. After that, Professional mode." No guilt. No "are you sure?"
  - 7 days after Pro access expires: one push notification (if still installed): "Still here? Your commitment field is still open. Professional mode is free forever." The goal is to retain them as free users who might re-subscribe, not to guilt them back immediately.

### 3.6 Notification-Denied Users: The Fallback Loop

Per the risk register, >40% notification denial is medium-likelihood, high-impact. Pressure's core loop degrades without notifications. Here's the fallback:

- **Persistent in-app banner** (already in onboarding spec): "Notifications are off. Pressure can't reach you."
- **Daily reminder via app badge:** Set the app badge to "1" at the start of each check-in window, clear on check-in. This is less effective than notifications but provides a visual cue.
- **Weekly engagement email (requires email capture — see Part 4):** For notification-denied users who've provided an email, send a single weekly summary: "You checked in [N] of 7 days this week. Your streak is [X]." Plain text. No images. No branding. Just data. Include an unsubscribe link and a deep link to re-enable notifications.
- **Track separately:** Notification-denied users are a distinct retention cohort. If their Day-30 retention is below 10%, the app fundamentally doesn't work without notifications and that's an acceptable constraint — don't over-invest in workarounds.

---

## Part 4: Data Acquisition Strategy

### 4.1 Principles

1. **Local-first by default.** The data model is on-device. No user data leaves the phone unless the user takes an explicit action.
2. **Earn the data.** Every data request is tied to a clear user benefit — never collect data speculatively.
3. **Privacy as brand.** "Pressure doesn't sell your data. Pressure doesn't even collect your data. Your commitments stay on your phone." This becomes part of the App Store description and a trust differentiator.
4. **Minimal viable analytics.** Track events, not users. Aggregate, don't individuate.

### 4.2 Email Acquisition

**Why emails matter:**
- Win-back campaigns for churned users
- Weekly summaries for notification-denied users
- Product update announcements (rare — 2–3 per year max)
- Direct communication channel independent of Apple's ecosystem

**When and how to ask:**

| Trigger | Prompt | Expected Capture Rate |
|---------|--------|----------------------|
| Onboarding (optional field on Screen 4) | "Email (optional) — for account recovery and weekly reports" | 20–30% |
| Day 7 (if not yet captured) | "Want a weekly check-in summary? Enter your email." | 15–25% |
| Trial start | Required for trial — "Email for receipt and trial reminders" | 90%+ |
| Subscription purchase | Required by Apple — captured via StoreKit receipt | 100% of paid |

**Implementation notes:**
- Store email in UserDefaults (encrypted at rest via iOS Data Protection)
- Never display email back to user in the app (minimize exposure)
- Server-side: when email is captured, send to a lightweight email service (Resend, Postmark, or Buttondown for simplicity) via a single API endpoint
- Comply with CAN-SPAM/GDPR: every email includes unsubscribe, email is deletable on request
- Privacy policy explicitly states: email used only for account communications, never shared, never sold

**Email content strategy:**
- Weekly summary (opted-in users only): plain text, 3 lines — days checked in, current streak, current tier
- Win-back (churned paid, 7 days post-expiry): single email, plain text, link to resubscribe
- Product updates: only for major features (widget launch, Apple Watch, etc.), max 3 per year
- No drip campaigns. No nurture sequences. No marketing automation. The app's notifications are the engagement layer — email is a safety net.

### 4.3 Feature Performance Analytics

**What to track (mapped to the 33 events in growth-metrics doc):**

The events are already defined. The missing piece is how to process them into actionable insight. Here's the analytics stack:

**MVP Analytics (Phase 4–5, pre-launch):**
- All 33 events log to Apple's built-in Analytics framework (App Analytics in App Store Connect)
- Supplement with a lightweight, privacy-respecting provider: **TelemetryDeck** (EU-based, no PII, GDPR-compliant by design) or **PostHog** (self-hostable, open source)
- No Mixpanel, no Amplitude, no Firebase Analytics — these are overkill for MVP and carry privacy baggage

**Event-to-Insight Mapping:**

| Question | Events Used | Decision It Drives |
|----------|------------|-------------------|
| Is Brutal mode worth paying for? | `brutal_tapped`, `personality_selected`, `trial_started` | If brutal tap rate >60% but trial start <20%, the paywall is too aggressive or the value isn't clear |
| Which escalation tier causes uninstalls? | `tier_advanced` correlated with `app_deleted` (via retention metrics) | If Tier 3 → uninstall rate >30%, copy is too harsh or persistent badge is counterproductive |
| Is the onboarding too long? | `onboarding_started` vs. `onboarding_completed`, per-screen drop-off | If Screen 3 (notifications) drops >25%, rewrite the permission framing |
| Do streaks drive retention? | `streak_milestone` events correlated with day-30 retention | If 7+ day streak users retain at 50%+ vs. 15% for <3 day, streaks are working — invest in streak UX |
| Is the Restart Shield compelling? | `shield_prompted`, `shield_used`, `shield_declined` | If <20% usage among paid users, shield isn't perceived as valuable — consider alternative paid features |
| Are notifications being screenshotted? | `notification_displayed` correlated with iOS screenshot detection | If Tier 2–3 Brutal copies get 3x+ screenshot rate, prioritize that copy style |
| What commitment types correlate with retention? | `commitment_entered` text length + specificity (basic NLP: word count, verb presence) correlated with check-in rate | If vague commitments ("be better") churn 2x faster, add a nudge for specificity |

**Reporting cadence:**
- Daily: check-in rate, new installs, trial starts (App Store Connect dashboard)
- Weekly: retention cohorts, tier distribution, notification grant rate, conversion funnel (TelemetryDeck/PostHog dashboard)
- Monthly: full cohort analysis by personality mode, streak performance, churn analysis, revenue review

### 4.4 Community Feedback Loop (What's Working, What's Not)

Analytics tells you *what* users do. Feedback tells you *why.* Here's how to capture qualitative data without building a feedback system:

**App Store Reviews as Structured Feedback:**
- Monitor reviews daily during Month 1 (App Store Connect notifications)
- Tag each review with: feature mentioned, sentiment, personality mode (if stated), tier referenced
- Respond to every 1–3 star review within 24 hours — not defensively, but to learn: "Thanks for the feedback. Can you tell us more about [specific issue]?" This sometimes converts a negative reviewer into a beta tester.

**In-App Micro-Feedback (Month 2+, not MVP):**
- After a user hits Day 30, surface once: "One question: what would make Pressure better?" Free-text field, 280-char limit (matches commitment length), submit button, dismiss button.
- Store responses locally, batch-send to a simple endpoint weekly
- No NPS scores. No star ratings. One open question, one time.

**Support Email as Research Channel:**
- App Store listing and Settings screen include: `pressure@[domain].com`
- Every support email is a data point. Track common themes in a simple spreadsheet.
- If 5+ users report the same issue in a month, it's a priority fix regardless of analytics data.

---

## Part 5: First 90 Days — Week-by-Week Execution Plan

### Pre-Launch (Weeks -4 to -1)

| Week | Actions |
|------|---------|
| -4 | Finalize Phase 5 (StoreKit, paywall, polish). Implement TelemetryDeck/PostHog SDK. Set up email capture endpoint. |
| -3 | Create App Store assets (screenshots, description, metadata). Write privacy policy. Set up support email. |
| -2 | Submit to App Store review. Prepare Reddit/HN posts (write drafts, don't post). Set up App Store Connect analytics dashboard. |
| -1 | Address any App Store review feedback. Final QA on notification scheduling across timezone edge cases. Pre-schedule Day 1 community posts. |

### Launch (Weeks 1–4)

| Week | Actions | Key Metrics to Watch |
|------|---------|---------------------|
| 1 | Publish to App Store. Post on r/getdisciplined, r/productivity, HN. Monitor crash reports and reviews hourly. | Installs, onboarding completion rate, notification grant rate |
| 2 | Respond to all reviews. First retention cohort data (Day 7). Fix any critical bugs surfaced by real usage. | Day-1 retention, Day-7 retention, first check-in rate |
| 3 | Analyze personality mode cohort split. Measure brutal_tapped rate. First trial conversions start expiring — watch trial→paid rate. | Trial start rate, brutal tap rate, Tier 2–3 copy screenshot correlation |
| 4 | Product Hunt launch (if Week 1–3 data is positive). First monthly cohort report. Decide if pricing/trial length needs adjustment. | Day-14 conversion, monthly churn (first data point), App Store keyword rankings |

### Growth (Weeks 5–12)

| Week | Actions | Key Metrics to Watch |
|------|---------|---------------------|
| 5–6 | Implement share image feature (screenshot-friendly commitment card). Deploy commitment specificity nudge if data shows vague commitments churn faster. | Screenshot share rate, commitment text quality metrics |
| 7–8 | First win-back email campaign for churned trial users. Implement notification fatigue reduction for habituated users. Review and refresh Tier 2–3 copy based on screenshot data. | Win-back conversion rate, notification-off cohort retention, streak distribution |
| 9–10 | Begin WidgetKit development (post-MVP priority #1 from roadmap). Evaluate annual plan uptake. Implement Day-30 micro-feedback prompt. | Widget adoption rate, annual vs. monthly split, qualitative feedback themes |
| 11–12 | Full 90-day retrospective. Unit economics validation (actual ARPU, churn, LTV). Decide on next investment: Apple Watch, multiple commitments, or copy expansion. | 90-day retention, revenue run rate, feature request frequency |

---

## Part 6: Risk Mitigation & Decision Framework

### Kill Criteria (When to Pivot)

| Signal | Threshold | Action |
|--------|-----------|--------|
| Day-7 retention below 20% across all cohorts | 2 consecutive weekly cohorts | Onboarding or core loop is broken — halt growth, fix product |
| Trial→paid conversion below 15% | After 500+ trial starts | Value proposition of paid tier is weak — test different gated features |
| Notification denial rate above 50% | After 1,000+ installs | Permission framing needs rework or fallback loop needs investment |
| Monthly paid churn above 15% | After 3 months of data | Paid features aren't retaining — investigate via feedback and churn surveys |
| Zero organic growth after Week 4 | Screenshot loop not firing | Copy isn't shareable — the fundamental growth thesis needs rethinking |

### Decisions to Defer (Not Now)

| Decision | Why Defer | Revisit When |
|----------|-----------|-------------|
| Android version | iOS validates the model first; Android doubles engineering surface | 5,000+ iOS paying subscribers |
| Social/community features | Contradicts solo accountability positioning | User feedback explicitly requests it (5+ per month) |
| Content marketing / blog | Time-intensive, low-leverage at small scale | Organic growth plateaus for 60+ days |
| Paid acquisition | Masks product-market fit signal | Organic CAC is understood and LTV is validated |
| Influencer partnerships | Expensive, unpredictable, misaligned with brand | Organic installs exceed 500/month consistently |

---

## Appendix: Metrics Dashboard — What to Look at Every Morning

For the solo developer/founder, this is the daily check-in (yes, meta):

```
DAILY (30 seconds)
├── New installs (App Store Connect)
├── Crash rate (Xcode Organizer)
├── New reviews (App Store Connect alerts)
└── Revenue (App Store Connect)

WEEKLY (15 minutes)
├── Retention curve (Day 1 / 7 / 14 / 30)
├── Funnel: install → onboard → first check-in → Day 7 active
├── Conversion funnel: brutal_tapped → trial_started → trial_converted
├── Tier distribution (what % of active users at each tier)
├── Notification grant rate (trailing 7-day)
└── Streak distribution (median, mean, 90th percentile)

MONTHLY (1 hour)
├── Full cohort analysis (personality × notification × commitment type)
├── Unit economics (ARPU, ARPPU, churn, LTV)
├── Revenue vs. milestone targets
├── Feature performance review (shield usage, streak milestones, share rate)
├── App Store keyword ranking changes
└── Qualitative review of all feedback (reviews, emails, in-app)
```

---

## Summary: The Three Bets

This entire strategy rests on three bets. If any one fails, the business model degrades:

1. **Copy is the product.** Pressure's notifications are funny, sharp, and screenshot-worthy enough that users share them voluntarily. This is the organic growth engine. If the copy isn't shareworthy, growth stalls.

2. **Brutal mode is worth paying for.** The free tier must be useful enough to retain users, but Brutal mode must be compelling enough that 5%+ will pay monthly. If users don't care about Brutal, the monetization thesis fails.

3. **Escalation drives retention, not churn.** The escalation engine must create productive tension — "I don't want to let my streak die" — not punitive fatigue — "this app is annoying, delete." If Tier 3 causes uninstalls more than recoveries, the core mechanic needs recalibration.

Every tactic in this document either feeds one of these bets or measures whether it's working. Nothing else matters until these three are validated.
