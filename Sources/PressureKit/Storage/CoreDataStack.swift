import CoreData
import Foundation

/// Programmatic Core Data stack — no .xcdatamodeld file needed.
public final class CoreDataStack {

    public let container: NSPersistentContainer

    /// - Parameter inMemory: Use an in-memory store for tests.
    public init(inMemory: Bool = false) {
        let model = Self.createModel()
        container = NSPersistentContainer(name: "Pressure", managedObjectModel: model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    /// Save the view context if it has changes.
    public func saveContext() throws {
        let context = viewContext
        guard context.hasChanges else { return }
        try context.save()
    }

    // MARK: - Model Definition

    private static func createModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // Commitment entity
        let commitmentEntity = NSEntityDescription()
        commitmentEntity.name = "CommitmentEntity"
        commitmentEntity.managedObjectClassName = NSStringFromClass(CommitmentEntity.self)

        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .UUIDAttributeType
        idAttr.isOptional = false

        let dateAttr = NSAttributeDescription()
        dateAttr.name = "date"
        dateAttr.attributeType = .dateAttributeType
        dateAttr.isOptional = false

        let textAttr = NSAttributeDescription()
        textAttr.name = "text"
        textAttr.attributeType = .stringAttributeType
        textAttr.isOptional = false

        let lockedAtAttr = NSAttributeDescription()
        lockedAtAttr.name = "lockedAt"
        lockedAtAttr.attributeType = .dateAttributeType
        lockedAtAttr.isOptional = true

        let statusRawAttr = NSAttributeDescription()
        statusRawAttr.name = "statusRaw"
        statusRawAttr.attributeType = .stringAttributeType
        statusRawAttr.isOptional = false
        statusRawAttr.defaultValue = CommitmentStatus.pending.rawValue

        let checkedInAtAttr = NSAttributeDescription()
        checkedInAtAttr.name = "checkedInAt"
        checkedInAtAttr.attributeType = .dateAttributeType
        checkedInAtAttr.isOptional = true

        let tierSnapAttr = NSAttributeDescription()
        tierSnapAttr.name = "escalationTierSnap"
        tierSnapAttr.attributeType = .integer16AttributeType
        tierSnapAttr.isOptional = false
        tierSnapAttr.defaultValue = Int16(0)

        let shieldUsedAttr = NSAttributeDescription()
        shieldUsedAttr.name = "shieldUsed"
        shieldUsedAttr.attributeType = .booleanAttributeType
        shieldUsedAttr.isOptional = false
        shieldUsedAttr.defaultValue = false

        commitmentEntity.properties = [
            idAttr, dateAttr, textAttr, lockedAtAttr,
            statusRawAttr, checkedInAtAttr, tierSnapAttr, shieldUsedAttr
        ]

        // Unique constraint on date
        commitmentEntity.uniquenessConstraints = [[dateAttr]]

        model.entities = [commitmentEntity]
        return model
    }
}
