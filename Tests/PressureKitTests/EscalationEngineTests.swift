import XCTest
@testable import PressureKit

final class EscalationEngineTests: XCTestCase {

    // MARK: - Advancement (NO / MISSED)

    func testFirstMissAdvancesToTier1() {
        let result = EscalationEngine.transition(from: .initial, result: .no)
        XCTAssertEqual(result.currentTier, .nudge)
        XCTAssertEqual(result.consecutiveMisses, 1)
        XCTAssertEqual(result.consecutiveSuccesses, 0)
    }

    func testSecondConsecutiveMissAdvancesToTier2() {
        let result = EscalationEngine.transition(from: TestFixtures.tier1, result: .no)
        XCTAssertEqual(result.currentTier, .push)
        XCTAssertEqual(result.consecutiveMisses, 2)
    }

    func testThirdConsecutiveMissAdvancesToTier3() {
        let result = EscalationEngine.transition(from: TestFixtures.tier2, result: .no)
        XCTAssertEqual(result.currentTier, .alarm)
        XCTAssertEqual(result.consecutiveMisses, 3)
    }

    func testFourthConsecutiveMissStaysAtTier3() {
        let result = EscalationEngine.transition(from: TestFixtures.tier3, result: .no)
        XCTAssertEqual(result.currentTier, .alarm)
        XCTAssertEqual(result.consecutiveMisses, 4)
    }

    func testMissedTreatedSameAsNo() {
        let fromNo = EscalationEngine.transition(from: .initial, result: .no)
        let fromMissed = EscalationEngine.transition(from: .initial, result: .missed)
        XCTAssertEqual(fromNo.currentTier, fromMissed.currentTier)
        XCTAssertEqual(fromNo.consecutiveMisses, fromMissed.consecutiveMisses)
    }

    func testMissResetsSuccessCount() {
        let state = EscalationState(
            currentTier: .push,
            consecutiveMisses: 0,
            consecutiveSuccesses: 1,
            currentStreak: 1,
            longestStreak: 1
        )
        let result = EscalationEngine.transition(from: state, result: .no)
        XCTAssertEqual(result.consecutiveSuccesses, 0)
    }

    func testMissResetsCurrentStreak() {
        let result = EscalationEngine.transition(from: TestFixtures.withStreak, result: .no)
        XCTAssertEqual(result.currentStreak, 0)
    }

    func testMissPreservesLongestStreak() {
        let result = EscalationEngine.transition(from: TestFixtures.withStreak, result: .no)
        XCTAssertEqual(result.longestStreak, 10)
    }

    // MARK: - De-escalation (YES)

    func testYesAtBaseline_StaysBaseline() {
        let result = EscalationEngine.transition(from: .initial, result: .yes)
        XCTAssertEqual(result.currentTier, .baseline)
        XCTAssertEqual(result.consecutiveSuccesses, 1)
    }

    func testOneYesAtTier1_DropsToBaseline() {
        let result = EscalationEngine.transition(from: TestFixtures.tier1, result: .yes)
        XCTAssertEqual(result.currentTier, .baseline)
        XCTAssertEqual(result.consecutiveSuccesses, 0)
    }

    func testOneYesAtTier2_StaysTier2() {
        let result = EscalationEngine.transition(from: TestFixtures.tier2, result: .yes)
        XCTAssertEqual(result.currentTier, .push)
        XCTAssertEqual(result.consecutiveSuccesses, 1)
    }

    func testTwoYesAtTier2_DropsToBaseline() {
        let result = EscalationEngine.transition(from: TestFixtures.tier2With1Success, result: .yes)
        XCTAssertEqual(result.currentTier, .baseline)
        XCTAssertEqual(result.consecutiveSuccesses, 0)
    }

    func testOneYesAtTier3_StaysTier3() {
        let result = EscalationEngine.transition(from: TestFixtures.tier3, result: .yes)
        XCTAssertEqual(result.currentTier, .alarm)
        XCTAssertEqual(result.consecutiveSuccesses, 1)
    }

    func testTwoYesAtTier3_StaysTier3() {
        let result = EscalationEngine.transition(from: TestFixtures.tier3With1Success, result: .yes)
        XCTAssertEqual(result.currentTier, .alarm)
        XCTAssertEqual(result.consecutiveSuccesses, 2)
    }

    func testThreeYesAtTier3_DropsToBaseline() {
        let result = EscalationEngine.transition(from: TestFixtures.tier3With2Successes, result: .yes)
        XCTAssertEqual(result.currentTier, .baseline)
        XCTAssertEqual(result.consecutiveSuccesses, 0)
    }

    func testYesResetsMissCount() {
        let result = EscalationEngine.transition(from: TestFixtures.tier1, result: .yes)
        XCTAssertEqual(result.consecutiveMisses, 0)
    }

    // MARK: - Streak Tracking

    func testYesIncrementsStreak() {
        let result = EscalationEngine.transition(from: .initial, result: .yes)
        XCTAssertEqual(result.currentStreak, 1)
    }

    func testConsecutiveYesBuildsStreak() {
        var state = EscalationState.initial
        for _ in 1...5 {
            state = EscalationEngine.transition(from: state, result: .yes)
        }
        XCTAssertEqual(state.currentStreak, 5)
        XCTAssertEqual(state.longestStreak, 5)
    }

    func testStreakResetsOnMissThenRebuilds() {
        var state = EscalationState.initial
        // Build a 3-day streak
        for _ in 1...3 {
            state = EscalationEngine.transition(from: state, result: .yes)
        }
        XCTAssertEqual(state.currentStreak, 3)
        XCTAssertEqual(state.longestStreak, 3)

        // Miss resets current but not longest
        state = EscalationEngine.transition(from: state, result: .no)
        XCTAssertEqual(state.currentStreak, 0)
        XCTAssertEqual(state.longestStreak, 3)

        // Start new streak — doesn't beat longest
        state = EscalationEngine.transition(from: state, result: .yes)
        XCTAssertEqual(state.currentStreak, 1)
        XCTAssertEqual(state.longestStreak, 3)
    }

    func testLongestStreakUpdatesWhenBeaten() {
        var state = EscalationState(
            currentTier: .baseline,
            currentStreak: 0,
            longestStreak: 2
        )
        for _ in 1...3 {
            state = EscalationEngine.transition(from: state, result: .yes)
        }
        XCTAssertEqual(state.longestStreak, 3)
    }

    // MARK: - Determinism

    func testSameInputProducesSameOutput() {
        let state = TestFixtures.tier2
        let result1 = EscalationEngine.transition(from: state, result: .yes)
        let result2 = EscalationEngine.transition(from: state, result: .yes)
        XCTAssertEqual(result1, result2)
    }

    // MARK: - Full Scenario

    func testFullEscalationAndRecoveryCycle() {
        var state = EscalationState.initial

        // Escalate to T3: 3 misses
        state = EscalationEngine.transition(from: state, result: .no)
        XCTAssertEqual(state.currentTier, .nudge)
        state = EscalationEngine.transition(from: state, result: .missed)
        XCTAssertEqual(state.currentTier, .push)
        state = EscalationEngine.transition(from: state, result: .no)
        XCTAssertEqual(state.currentTier, .alarm)

        // Recover from T3: need 3 YES
        state = EscalationEngine.transition(from: state, result: .yes)
        XCTAssertEqual(state.currentTier, .alarm)
        state = EscalationEngine.transition(from: state, result: .yes)
        XCTAssertEqual(state.currentTier, .alarm)
        state = EscalationEngine.transition(from: state, result: .yes)
        XCTAssertEqual(state.currentTier, .baseline)
        XCTAssertEqual(state.currentStreak, 3)
    }

    func testMissInterruptsDeescalation() {
        // At T3 with 2 successes, a miss resets the recovery
        let result = EscalationEngine.transition(from: TestFixtures.tier3With2Successes, result: .no)
        XCTAssertEqual(result.currentTier, .nudge)
        XCTAssertEqual(result.consecutiveSuccesses, 0)
        XCTAssertEqual(result.consecutiveMisses, 1)
    }
}
