import Foundation

/// Type-safe wrapper around UserDefaults for app settings.
public final class UserSettingsStore {

    private let defaults: UserDefaults

    private enum Keys {
        static let personalityMode = "pressure.personalityMode"
        static let commitmentDeadline = "pressure.commitmentDeadline"
        static let checkinWindowClose = "pressure.checkinWindowClose"
        static let timezoneIdentifier = "pressure.timezoneIdentifier"
        static let notificationsEnabled = "pressure.notificationsEnabled"
        static let onboardingCompleted = "pressure.onboardingCompleted"
        static let subscriptionTier = "pressure.subscriptionTier"
        static let subscriptionExpiry = "pressure.subscriptionExpiry"
    }

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Personality

    public var personalityMode: PersonalityMode {
        get {
            guard let raw = defaults.string(forKey: Keys.personalityMode),
                  let mode = PersonalityMode(rawValue: raw) else {
                return .professional
            }
            return mode
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.personalityMode) }
    }

    // MARK: - Schedule

    public var commitmentDeadline: String {
        get { defaults.string(forKey: Keys.commitmentDeadline) ?? Constants.defaultDeadline }
        set { defaults.set(newValue, forKey: Keys.commitmentDeadline) }
    }

    public var checkinWindowClose: String {
        get { defaults.string(forKey: Keys.checkinWindowClose) ?? Constants.defaultWindowClose }
        set { defaults.set(newValue, forKey: Keys.checkinWindowClose) }
    }

    public var timezoneIdentifier: String {
        get { defaults.string(forKey: Keys.timezoneIdentifier) ?? TimeZone.current.identifier }
        set { defaults.set(newValue, forKey: Keys.timezoneIdentifier) }
    }

    public var timeZone: TimeZone {
        TimeZone(identifier: timezoneIdentifier) ?? .current
    }

    // MARK: - Flags

    public var notificationsEnabled: Bool {
        get { defaults.bool(forKey: Keys.notificationsEnabled) }
        set { defaults.set(newValue, forKey: Keys.notificationsEnabled) }
    }

    public var onboardingCompleted: Bool {
        get { defaults.bool(forKey: Keys.onboardingCompleted) }
        set { defaults.set(newValue, forKey: Keys.onboardingCompleted) }
    }

    // MARK: - Subscription

    public var subscriptionTier: SubscriptionTier {
        get {
            guard let raw = defaults.string(forKey: Keys.subscriptionTier),
                  let tier = SubscriptionTier(rawValue: raw) else {
                return .free
            }
            return tier
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.subscriptionTier) }
    }

    public var subscriptionExpiry: Date? {
        get { defaults.object(forKey: Keys.subscriptionExpiry) as? Date }
        set { defaults.set(newValue, forKey: Keys.subscriptionExpiry) }
    }
}
