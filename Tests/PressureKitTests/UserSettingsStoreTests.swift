import XCTest
@testable import PressureKit

final class UserSettingsStoreTests: XCTestCase {

    private var store: UserSettingsStore!

    override func setUp() {
        super.setUp()
        store = UserSettingsStore(defaults: TestFixtures.freshDefaults())
    }

    // MARK: - Defaults

    func testDefaultPersonalityMode() {
        XCTAssertEqual(store.personalityMode, .professional)
    }

    func testDefaultCommitmentDeadline() {
        XCTAssertEqual(store.commitmentDeadline, "09:00")
    }

    func testDefaultCheckinWindowClose() {
        XCTAssertEqual(store.checkinWindowClose, "22:00")
    }

    func testDefaultNotificationsEnabled() {
        XCTAssertFalse(store.notificationsEnabled)
    }

    func testDefaultOnboardingCompleted() {
        XCTAssertFalse(store.onboardingCompleted)
    }

    func testDefaultSubscriptionTier() {
        XCTAssertEqual(store.subscriptionTier, .free)
    }

    func testDefaultSubscriptionExpiry() {
        XCTAssertNil(store.subscriptionExpiry)
    }

    // MARK: - Round-trip

    func testPersonalityModeRoundTrip() {
        store.personalityMode = .brutal
        XCTAssertEqual(store.personalityMode, .brutal)
    }

    func testCommitmentDeadlineRoundTrip() {
        store.commitmentDeadline = "07:30"
        XCTAssertEqual(store.commitmentDeadline, "07:30")
    }

    func testCheckinWindowCloseRoundTrip() {
        store.checkinWindowClose = "20:00"
        XCTAssertEqual(store.checkinWindowClose, "20:00")
    }

    func testTimezoneIdentifierRoundTrip() {
        store.timezoneIdentifier = "America/New_York"
        XCTAssertEqual(store.timezoneIdentifier, "America/New_York")
        XCTAssertEqual(store.timeZone, TimeZone(identifier: "America/New_York"))
    }

    func testNotificationsEnabledRoundTrip() {
        store.notificationsEnabled = true
        XCTAssertTrue(store.notificationsEnabled)
    }

    func testOnboardingCompletedRoundTrip() {
        store.onboardingCompleted = true
        XCTAssertTrue(store.onboardingCompleted)
    }

    func testSubscriptionTierRoundTrip() {
        store.subscriptionTier = .paid
        XCTAssertEqual(store.subscriptionTier, .paid)
    }

    func testSubscriptionExpiryRoundTrip() {
        let date = TestFixtures.date(year: 2025, month: 6, day: 1)
        store.subscriptionExpiry = date
        XCTAssertEqual(store.subscriptionExpiry, date)
    }

    func testSubscriptionExpiryClearable() {
        store.subscriptionExpiry = TestFixtures.date()
        store.subscriptionExpiry = nil
        XCTAssertNil(store.subscriptionExpiry)
    }

    // MARK: - Isolation

    func testSeparateDefaultsAreIsolated() {
        let store2 = UserSettingsStore(defaults: TestFixtures.freshDefaults())
        store.personalityMode = .brutal
        XCTAssertEqual(store2.personalityMode, .professional)
    }
}
