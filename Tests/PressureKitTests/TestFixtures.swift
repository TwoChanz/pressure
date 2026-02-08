import Foundation
@testable import PressureKit

enum TestFixtures {

    // MARK: - Escalation States

    static let initial = EscalationState.initial

    static let tier1 = EscalationState(
        currentTier: .nudge,
        consecutiveMisses: 1,
        consecutiveSuccesses: 0
    )

    static let tier2 = EscalationState(
        currentTier: .push,
        consecutiveMisses: 2,
        consecutiveSuccesses: 0
    )

    static let tier3 = EscalationState(
        currentTier: .alarm,
        consecutiveMisses: 3,
        consecutiveSuccesses: 0
    )

    static let tier2With1Success = EscalationState(
        currentTier: .push,
        consecutiveMisses: 0,
        consecutiveSuccesses: 1,
        currentStreak: 1,
        longestStreak: 1
    )

    static let tier3With1Success = EscalationState(
        currentTier: .alarm,
        consecutiveMisses: 0,
        consecutiveSuccesses: 1,
        currentStreak: 1,
        longestStreak: 1
    )

    static let tier3With2Successes = EscalationState(
        currentTier: .alarm,
        consecutiveMisses: 0,
        consecutiveSuccesses: 2,
        currentStreak: 2,
        longestStreak: 2
    )

    static let withShield = EscalationState(
        currentTier: .baseline,
        restartShieldsRemaining: 1
    )

    static let tier1WithShield = EscalationState(
        currentTier: .nudge,
        consecutiveMisses: 1,
        restartShieldsRemaining: 1
    )

    static let withStreak = EscalationState(
        currentTier: .baseline,
        currentStreak: 5,
        longestStreak: 10
    )

    // MARK: - Dates

    static let utc = TimeZone(identifier: "UTC")!
    static let eastern = TimeZone(identifier: "America/New_York")!
    static let tokyo = TimeZone(identifier: "Asia/Tokyo")!

    static func date(
        year: Int = 2024, month: Int = 1, day: Int = 15,
        hour: Int = 12, minute: Int = 0,
        timeZone: TimeZone = TimeZone(identifier: "UTC")!
    ) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let components = DateComponents(
            year: year, month: month, day: day,
            hour: hour, minute: minute
        )
        return calendar.date(from: components)!
    }

    // MARK: - UserDefaults

    static func freshDefaults() -> UserDefaults {
        let name = "com.pressure.test.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: name)!
        defaults.removePersistentDomain(forName: name)
        return defaults
    }
}
