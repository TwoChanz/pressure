import Foundation

/// Persists `EscalationState` as a single JSON blob in UserDefaults.
public final class EscalationStateStore {

    private let defaults: UserDefaults
    private static let key = "pressure.escalationState"

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// Load the current state, falling back to `.initial` if nothing is stored.
    public func load() -> EscalationState {
        guard let data = defaults.data(forKey: Self.key) else {
            return .initial
        }
        do {
            return try JSONDecoder().decode(EscalationState.self, from: data)
        } catch {
            return .initial
        }
    }

    /// Persist the given state.
    public func save(_ state: EscalationState) {
        if let data = try? JSONEncoder().encode(state) {
            defaults.set(data, forKey: Self.key)
        }
    }

    /// Reset to the initial state.
    public func reset() {
        defaults.removeObject(forKey: Self.key)
    }
}
