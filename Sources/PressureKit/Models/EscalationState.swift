import Foundation

/// Immutable snapshot of the escalation engine's state.
/// Value semantics guarantee deterministic transitions.
public struct EscalationState: Codable, Equatable {
    public let currentTier: EscalationTier
    public let consecutiveMisses: Int
    public let consecutiveSuccesses: Int
    public let currentStreak: Int
    public let longestStreak: Int
    public let restartShieldsRemaining: Int
    public let shieldResetDate: Date?

    public init(
        currentTier: EscalationTier = .baseline,
        consecutiveMisses: Int = 0,
        consecutiveSuccesses: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        restartShieldsRemaining: Int = 0,
        shieldResetDate: Date? = nil
    ) {
        self.currentTier = currentTier
        self.consecutiveMisses = consecutiveMisses
        self.consecutiveSuccesses = consecutiveSuccesses
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.restartShieldsRemaining = restartShieldsRemaining
        self.shieldResetDate = shieldResetDate
    }

    /// A fresh state with all counters at zero.
    public static let initial = EscalationState()
}
