import Foundation

/// Pure-function escalation engine. No stored state, no side effects.
/// Usage: `let newState = EscalationEngine.transition(from: state, result: .yes)`
public enum EscalationEngine {

    /// Compute the next escalation state from a check-in result.
    ///
    /// - Parameters:
    ///   - state: The current escalation state.
    ///   - result: The check-in outcome (YES, NO, or MISSED).
    ///   - useShield: Whether to consume a restart shield on a NO/MISSED result.
    /// - Returns: A new `EscalationState` reflecting the transition.
    public static func transition(
        from state: EscalationState,
        result: CheckInResult,
        useShield: Bool = false
    ) -> EscalationState {
        switch result {
        case .yes:
            return handleSuccess(state: state)
        case .no, .missed:
            return handleFailure(state: state, useShield: useShield)
        }
    }

    // MARK: - Private

    private static func handleSuccess(state: EscalationState) -> EscalationState {
        let newSuccesses = state.consecutiveSuccesses + 1
        let newStreak = state.currentStreak + 1
        let newLongest = max(state.longestStreak, newStreak)

        // Check if we've met the de-escalation threshold
        let tier = state.currentTier
        if newSuccesses >= tier.requiredSuccessesForReset && tier != .baseline {
            // Jump straight to baseline, reset success counter
            return EscalationState(
                currentTier: .baseline,
                consecutiveMisses: 0,
                consecutiveSuccesses: 0,
                currentStreak: newStreak,
                longestStreak: newLongest,
                restartShieldsRemaining: state.restartShieldsRemaining,
                shieldResetDate: state.shieldResetDate
            )
        }

        return EscalationState(
            currentTier: tier,
            consecutiveMisses: 0,
            consecutiveSuccesses: newSuccesses,
            currentStreak: newStreak,
            longestStreak: newLongest,
            restartShieldsRemaining: state.restartShieldsRemaining,
            shieldResetDate: state.shieldResetDate
        )
    }

    private static func handleFailure(state: EscalationState, useShield: Bool) -> EscalationState {
        // Shield: prevents tier advancement but streak still resets
        if useShield && state.restartShieldsRemaining > 0 {
            return EscalationState(
                currentTier: state.currentTier,
                consecutiveMisses: state.consecutiveMisses,
                consecutiveSuccesses: 0,
                currentStreak: 0,
                longestStreak: state.longestStreak,
                restartShieldsRemaining: state.restartShieldsRemaining - 1,
                shieldResetDate: state.shieldResetDate
            )
        }

        // Normal escalation
        let newMisses = state.consecutiveMisses + 1
        let newTier: EscalationTier
        if newMisses >= 3 {
            newTier = .alarm
        } else if newMisses == 2 {
            newTier = .push
        } else {
            newTier = .nudge
        }

        return EscalationState(
            currentTier: newTier,
            consecutiveMisses: newMisses,
            consecutiveSuccesses: 0,
            currentStreak: 0,
            longestStreak: state.longestStreak,
            restartShieldsRemaining: state.restartShieldsRemaining,
            shieldResetDate: state.shieldResetDate
        )
    }
}
