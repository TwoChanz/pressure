import CoreData
import Foundation

/// Error types for commitment operations.
public enum CommitmentStoreError: Error, Equatable {
    /// A commitment already exists for this calendar date.
    case duplicateDate
    /// The commitment has already been checked in (status is not PENDING).
    case alreadyCheckedIn
    /// No commitment found for the given criteria.
    case notFound
    /// Commitment text exceeds the maximum character limit.
    case textTooLong
}

/// CRUD operations for daily commitment records.
public final class CommitmentStore {

    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    /// Create a new commitment for the given calendar date.
    /// - Parameters:
    ///   - text: The commitment text (max 280 characters).
    ///   - date: The calendar date (time component should be midnight).
    /// - Returns: The created `CommitmentEntity`.
    @discardableResult
    public func create(text: String, date: Date) throws -> CommitmentEntity {
        guard text.count <= Constants.maxCommitmentCharacters else {
            throw CommitmentStoreError.textTooLong
        }

        if try fetch(for: date) != nil {
            throw CommitmentStoreError.duplicateDate
        }

        let entity = CommitmentEntity(context: context)
        entity.id = UUID()
        entity.date = date
        entity.text = text
        entity.statusRaw = CommitmentStatus.pending.rawValue
        entity.shieldUsed = false
        entity.escalationTierSnap = 0

        try context.save()
        return entity
    }

    /// Fetch the commitment for a specific calendar date.
    public func fetch(for date: Date) throws -> CommitmentEntity? {
        let request = NSFetchRequest<CommitmentEntity>(entityName: "CommitmentEntity")
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    /// Fetch all commitments, most recent first.
    public func fetchAll() throws -> [CommitmentEntity] {
        let request = NSFetchRequest<CommitmentEntity>(entityName: "CommitmentEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return try context.fetch(request)
    }

    /// Check in with a result. Enforces one-way status transitions.
    /// - Parameters:
    ///   - date: The calendar date of the commitment.
    ///   - result: The check-in result (.yes, .no, or .missed).
    ///   - checkedInAt: The timestamp of the check-in.
    ///   - tierSnapshot: The current escalation tier at check-in time.
    ///   - shieldUsed: Whether a restart shield was used.
    public func checkIn(
        date: Date,
        result: CheckInResult,
        checkedInAt: Date,
        tierSnapshot: EscalationTier,
        shieldUsed: Bool = false
    ) throws {
        guard let entity = try fetch(for: date) else {
            throw CommitmentStoreError.notFound
        }

        guard entity.status == .pending else {
            throw CommitmentStoreError.alreadyCheckedIn
        }

        switch result {
        case .yes: entity.status = .yes
        case .no: entity.status = .no
        case .missed: entity.status = .missed
        }

        entity.checkedInAt = checkedInAt
        entity.escalationTier = tierSnapshot
        entity.shieldUsed = shieldUsed

        try context.save()
    }

    /// Delete a commitment by date. Used primarily for testing.
    public func delete(for date: Date) throws {
        guard let entity = try fetch(for: date) else { return }
        context.delete(entity)
        try context.save()
    }
}
