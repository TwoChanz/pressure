import XCTest
@testable import PressureKit

final class EscalationStateStoreTests: XCTestCase {

    private var store: EscalationStateStore!

    override func setUp() {
        super.setUp()
        store = EscalationStateStore(defaults: TestFixtures.freshDefaults())
    }

    func testLoadReturnsInitialWhenEmpty() {
        let state = store.load()
        XCTAssertEqual(state, EscalationState.initial)
    }

    func testSaveAndLoadRoundTrip() {
        let state = EscalationState(
            currentTier: .push,
            consecutiveMisses: 2,
            consecutiveSuccesses: 0,
            currentStreak: 0,
            longestStreak: 7,
            restartShieldsRemaining: 1,
            shieldResetDate: TestFixtures.date(year: 2024, month: 2, day: 1)
        )
        store.save(state)
        let loaded = store.load()
        XCTAssertEqual(loaded, state)
    }

    func testResetClearsState() {
        store.save(TestFixtures.tier3)
        store.reset()
        XCTAssertEqual(store.load(), EscalationState.initial)
    }

    func testMultipleSavesOverwrite() {
        store.save(TestFixtures.tier1)
        store.save(TestFixtures.tier3)
        XCTAssertEqual(store.load().currentTier, .alarm)
    }

    func testIsolatedStoresDoNotInterfere() {
        let store2 = EscalationStateStore(defaults: TestFixtures.freshDefaults())
        store.save(TestFixtures.tier2)
        XCTAssertEqual(store2.load(), EscalationState.initial)
    }
}
