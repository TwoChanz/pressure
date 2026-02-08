import Foundation

/// Escalation severity level.
/// Higher tiers mean more aggressive notification behavior.
public enum EscalationTier: Int, Codable, Comparable {
    case baseline = 0
    case nudge = 1
    case push = 2
    case alarm = 3

    /// Number of consecutive YES check-ins required to de-escalate to baseline.
    public var requiredSuccessesForReset: Int {
        switch self {
        case .baseline: return 0
        case .nudge: return 1
        case .push: return 2
        case .alarm: return 3
        }
    }

    /// Number of notifications scheduled at this tier.
    public var notificationCount: Int {
        switch self {
        case .baseline: return 1
        case .nudge: return 2
        case .push, .alarm: return 3
        }
    }

    public static func < (lhs: EscalationTier, rhs: EscalationTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
