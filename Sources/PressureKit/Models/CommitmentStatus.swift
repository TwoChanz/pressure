import Foundation

/// The lifecycle status of a daily commitment.
/// Transitions are one-way: PENDING -> YES | NO | MISSED.
public enum CommitmentStatus: String, Codable {
    case pending = "PENDING"
    case yes = "YES"
    case no = "NO"
    case missed = "MISSED"
}
