import CoreData
import Foundation

/// Core Data managed object for a daily commitment record.
@objc(CommitmentEntity)
public class CommitmentEntity: NSManagedObject {

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var text: String
    @NSManaged public var lockedAt: Date?
    @NSManaged public var statusRaw: String
    @NSManaged public var checkedInAt: Date?
    @NSManaged public var escalationTierSnap: Int16
    @NSManaged public var shieldUsed: Bool

    // MARK: - Typed Accessors

    public var status: CommitmentStatus {
        get { CommitmentStatus(rawValue: statusRaw) ?? .pending }
        set { statusRaw = newValue.rawValue }
    }

    public var escalationTier: EscalationTier {
        get { EscalationTier(rawValue: Int(escalationTierSnap)) ?? .baseline }
        set { escalationTierSnap = Int16(newValue.rawValue) }
    }
}
