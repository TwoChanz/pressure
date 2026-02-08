import XCTest
@testable import PressureKit

final class EscalationEngineShieldTests: XCTestCase {

    // MARK: - Shield Usage

    func testShieldPreventsTierAdvancement() {
        let result = EscalationEngine.transition(
            from: TestFixtures.withShield, result: .no, useShield: true
        )
        XCTAssertEqual(result.currentTier, .baseline)
        XCTAssertEqual(result.restartShieldsRemaining, 0)
    }

    func testShieldStillResetsStreak() {
        let state = EscalationState(
            currentTier: .baseline,
            currentStreak: 5,
            longestStreak: 10,
            restartShieldsRemaining: 1
        )
        let result = EscalationEngine.transition(from: state, result: .no, useShield: true)
        XCTAssertEqual(result.currentStreak, 0)
        XCTAssertEqual(result.longestStreak, 10)
    }

    func testShieldPreservesConsecutiveMisses() {
        let state = EscalationState(
            currentTier: .nudge,
            consecutiveMisses: 1,
            restartShieldsRemaining: 1
        )
        let result = EscalationEngine.transition(from: state, result: .no, useShield: true)
        XCTAssertEqual(result.consecutiveMisses, 1) // unchanged
        XCTAssertEqual(result.currentTier, .nudge) // unchanged
    }

    func testShieldDecrementsCount() {
        let result = EscalationEngine.transition(
            from: TestFixtures.withShield, result: .no, useShield: true
        )
        XCTAssertEqual(result.restartShieldsRemaining, 0)
    }

    func testShieldNotUsedWhenNoneRemaining() {
        let state = EscalationState(
            currentTier: .baseline,
            restartShieldsRemaining: 0
        )
        let result = EscalationEngine.transition(from: state, result: .no, useShield: true)
        // Normal escalation should occur
        XCTAssertEqual(result.currentTier, .nudge)
        XCTAssertEqual(result.consecutiveMisses, 1)
    }

    func testShieldIgnoredOnYes() {
        let result = EscalationEngine.transition(
            from: TestFixtures.withShield, result: .yes, useShield: true
        )
        // Shield count unchanged on YES
        XCTAssertEqual(result.restartShieldsRemaining, 1)
        XCTAssertEqual(result.currentStreak, 1)
    }

    func testShieldAtHigherTier() {
        let result = EscalationEngine.transition(
            from: TestFixtures.tier1WithShield, result: .no, useShield: true
        )
        XCTAssertEqual(result.currentTier, .nudge) // stays at T1
        XCTAssertEqual(result.restartShieldsRemaining, 0)
        XCTAssertEqual(result.currentStreak, 0)
    }

    func testShieldFlagFalseDoesNormalEscalation() {
        let result = EscalationEngine.transition(
            from: TestFixtures.withShield, result: .no, useShield: false
        )
        XCTAssertEqual(result.currentTier, .nudge)
        XCTAssertEqual(result.restartShieldsRemaining, 1) // shield not consumed
    }
}
