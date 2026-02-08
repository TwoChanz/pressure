import Foundation

/// Hard constraints for the Pressure app.
public enum Constants {
    /// Maximum escalation tier (Alarm).
    public static let maxTier = 3

    /// Maximum notifications per day at any tier.
    public static let maxNotificationsPerDay = 3

    /// Minimum spacing between notifications in minutes.
    public static let minNotificationSpacingMinutes = 30

    /// Maximum character count for commitment text.
    public static let maxCommitmentCharacters = 280

    /// Maximum restart shields per month for paid users.
    public static let maxShieldsPerMonth = 1

    /// Default commitment deadline time (HH:mm).
    public static let defaultDeadline = "09:00"

    /// Default check-in window close time (HH:mm).
    public static let defaultWindowClose = "22:00"
}
