import XCTest
import CoreData
@testable import PressureKit

final class CommitmentStoreTests: XCTestCase {

    private var stack: CoreDataStack!
    private var store: CommitmentStore!

    override func setUp() {
        super.setUp()
        stack = CoreDataStack(inMemory: true)
        store = CommitmentStore(context: stack.viewContext)
    }

    // MARK: - Create

    func testCreateCommitment() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        let entity = try store.create(text: "Run 5k", date: date)

        XCTAssertEqual(entity.text, "Run 5k")
        XCTAssertEqual(entity.date, date)
        XCTAssertEqual(entity.status, .pending)
        XCTAssertFalse(entity.shieldUsed)
        XCTAssertNil(entity.checkedInAt)
    }

    func testCreateDuplicateDateThrows() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        try store.create(text: "Run 5k", date: date)

        XCTAssertThrowsError(try store.create(text: "Read book", date: date)) { error in
            XCTAssertEqual(error as? CommitmentStoreError, .duplicateDate)
        }
    }

    func testCreateTextTooLongThrows() {
        let longText = String(repeating: "a", count: 281)
        let date = TestFixtures.date(hour: 0, minute: 0)

        XCTAssertThrowsError(try store.create(text: longText, date: date)) { error in
            XCTAssertEqual(error as? CommitmentStoreError, .textTooLong)
        }
    }

    func testCreateTextAtMaxLengthSucceeds() throws {
        let maxText = String(repeating: "a", count: 280)
        let date = TestFixtures.date(hour: 0, minute: 0)
        let entity = try store.create(text: maxText, date: date)
        XCTAssertEqual(entity.text.count, 280)
    }

    // MARK: - Fetch

    func testFetchByDate() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        try store.create(text: "Run 5k", date: date)

        let fetched = try store.fetch(for: date)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.text, "Run 5k")
    }

    func testFetchNonexistentDateReturnsNil() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        XCTAssertNil(try store.fetch(for: date))
    }

    func testFetchAllReturnsMostRecentFirst() throws {
        let date1 = TestFixtures.date(year: 2024, month: 1, day: 1, hour: 0, minute: 0)
        let date2 = TestFixtures.date(year: 2024, month: 1, day: 2, hour: 0, minute: 0)
        let date3 = TestFixtures.date(year: 2024, month: 1, day: 3, hour: 0, minute: 0)

        try store.create(text: "Day 1", date: date1)
        try store.create(text: "Day 2", date: date2)
        try store.create(text: "Day 3", date: date3)

        let all = try store.fetchAll()
        XCTAssertEqual(all.count, 3)
        XCTAssertEqual(all[0].text, "Day 3")
        XCTAssertEqual(all[2].text, "Day 1")
    }

    // MARK: - Check-in

    func testCheckInYes() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        try store.create(text: "Run 5k", date: date)

        let now = TestFixtures.date(hour: 15, minute: 0)
        try store.checkIn(
            date: date, result: .yes,
            checkedInAt: now, tierSnapshot: .baseline
        )

        let entity = try store.fetch(for: date)!
        XCTAssertEqual(entity.status, .yes)
        XCTAssertEqual(entity.checkedInAt, now)
        XCTAssertEqual(entity.escalationTier, .baseline)
    }

    func testCheckInNo() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        try store.create(text: "Run 5k", date: date)

        let now = TestFixtures.date(hour: 15, minute: 0)
        try store.checkIn(
            date: date, result: .no,
            checkedInAt: now, tierSnapshot: .nudge
        )

        let entity = try store.fetch(for: date)!
        XCTAssertEqual(entity.status, .no)
        XCTAssertEqual(entity.escalationTier, .nudge)
    }

    func testCheckInMissed() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        try store.create(text: "Run 5k", date: date)

        let now = TestFixtures.date(hour: 22, minute: 0)
        try store.checkIn(
            date: date, result: .missed,
            checkedInAt: now, tierSnapshot: .push
        )

        let entity = try store.fetch(for: date)!
        XCTAssertEqual(entity.status, .missed)
    }

    func testDoubleCheckInThrows() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        try store.create(text: "Run 5k", date: date)

        let now = TestFixtures.date(hour: 15, minute: 0)
        try store.checkIn(
            date: date, result: .yes,
            checkedInAt: now, tierSnapshot: .baseline
        )

        XCTAssertThrowsError(
            try store.checkIn(
                date: date, result: .no,
                checkedInAt: now, tierSnapshot: .baseline
            )
        ) { error in
            XCTAssertEqual(error as? CommitmentStoreError, .alreadyCheckedIn)
        }
    }

    func testCheckInNonexistentDateThrows() {
        let date = TestFixtures.date(hour: 0, minute: 0)
        let now = TestFixtures.date(hour: 15, minute: 0)

        XCTAssertThrowsError(
            try store.checkIn(
                date: date, result: .yes,
                checkedInAt: now, tierSnapshot: .baseline
            )
        ) { error in
            XCTAssertEqual(error as? CommitmentStoreError, .notFound)
        }
    }

    func testCheckInWithShield() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        try store.create(text: "Run 5k", date: date)

        let now = TestFixtures.date(hour: 15, minute: 0)
        try store.checkIn(
            date: date, result: .no,
            checkedInAt: now, tierSnapshot: .nudge,
            shieldUsed: true
        )

        let entity = try store.fetch(for: date)!
        XCTAssertTrue(entity.shieldUsed)
    }

    // MARK: - Delete

    func testDelete() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        try store.create(text: "Run 5k", date: date)
        try store.delete(for: date)
        XCTAssertNil(try store.fetch(for: date))
    }

    func testDeleteNonexistentDateNoOp() throws {
        let date = TestFixtures.date(hour: 0, minute: 0)
        // Should not throw
        try store.delete(for: date)
    }
}
