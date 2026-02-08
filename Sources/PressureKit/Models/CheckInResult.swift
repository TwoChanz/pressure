import Foundation

/// The outcome of a daily check-in.
public enum CheckInResult: String, Codable {
    case yes = "YES"
    case no = "NO"
    case missed = "MISSED"
}
