import XCTest
@testable import PressureKit

final class DateUtilitiesTests: XCTestCase {

    // MARK: - isCommitmentLocked

    func testBeforeDeadline_NotLocked() {
        let current = TestFixtures.date(hour: 8, minute: 59)
        XCTAssertFalse(
            DateUtilities.isCommitmentLocked(
                deadline: "09:00", currentTime: current, timeZone: TestFixtures.utc
            )
        )
    }

    func testAtDeadline_IsLocked() {
        let current = TestFixtures.date(hour: 9, minute: 0)
        XCTAssertTrue(
            DateUtilities.isCommitmentLocked(
                deadline: "09:00", currentTime: current, timeZone: TestFixtures.utc
            )
        )
    }

    func testAfterDeadline_IsLocked() {
        let current = TestFixtures.date(hour: 12, minute: 0)
        XCTAssertTrue(
            DateUtilities.isCommitmentLocked(
                deadline: "09:00", currentTime: current, timeZone: TestFixtures.utc
            )
        )
    }

    // MARK: - isWindowOpen

    func testBeforeDeadline_WindowClosed() {
        let current = TestFixtures.date(hour: 8, minute: 0)
        XCTAssertFalse(
            DateUtilities.isWindowOpen(
                deadline: "09:00", windowClose: "22:00",
                currentTime: current, timeZone: TestFixtures.utc
            )
        )
    }

    func testAtDeadline_WindowOpen() {
        let current = TestFixtures.date(hour: 9, minute: 0)
        XCTAssertTrue(
            DateUtilities.isWindowOpen(
                deadline: "09:00", windowClose: "22:00",
                currentTime: current, timeZone: TestFixtures.utc
            )
        )
    }

    func testMidWindow_WindowOpen() {
        let current = TestFixtures.date(hour: 15, minute: 30)
        XCTAssertTrue(
            DateUtilities.isWindowOpen(
                deadline: "09:00", windowClose: "22:00",
                currentTime: current, timeZone: TestFixtures.utc
            )
        )
    }

    func testAtWindowClose_WindowClosed() {
        let current = TestFixtures.date(hour: 22, minute: 0)
        XCTAssertFalse(
            DateUtilities.isWindowOpen(
                deadline: "09:00", windowClose: "22:00",
                currentTime: current, timeZone: TestFixtures.utc
            )
        )
    }

    func testAfterWindowClose_WindowClosed() {
        let current = TestFixtures.date(hour: 23, minute: 0)
        XCTAssertFalse(
            DateUtilities.isWindowOpen(
                deadline: "09:00", windowClose: "22:00",
                currentTime: current, timeZone: TestFixtures.utc
            )
        )
    }

    // MARK: - windowMidpoint

    func testMidpointDefaultWindow() {
        let day = TestFixtures.date(hour: 0, minute: 0)
        let midpoint = DateUtilities.windowMidpoint(
            deadline: "09:00", windowClose: "22:00",
            on: day, timeZone: TestFixtures.utc
        )
        // 09:00 to 22:00 = 13 hours, midpoint = 15:30
        let expected = TestFixtures.date(hour: 15, minute: 30)
        XCTAssertEqual(midpoint, expected)
    }

    func testMidpointNarrowWindow() {
        let day = TestFixtures.date(hour: 0, minute: 0)
        let midpoint = DateUtilities.windowMidpoint(
            deadline: "12:00", windowClose: "14:00",
            on: day, timeZone: TestFixtures.utc
        )
        let expected = TestFixtures.date(hour: 13, minute: 0)
        XCTAssertEqual(midpoint, expected)
    }

    // MARK: - calendarDate

    func testCalendarDateStripsTime() {
        let date = TestFixtures.date(hour: 15, minute: 45)
        let calDate = DateUtilities.calendarDate(from: date, in: TestFixtures.utc)
        let expected = TestFixtures.date(hour: 0, minute: 0)
        XCTAssertEqual(calDate, expected)
    }

    func testCalendarDateRespectsTimezone() {
        // 2024-01-15 03:00 UTC = 2024-01-14 22:00 EST
        let date = TestFixtures.date(hour: 3, minute: 0, timeZone: TestFixtures.utc)
        let calDateEST = DateUtilities.calendarDate(from: date, in: TestFixtures.eastern)
        let calDateUTC = DateUtilities.calendarDate(from: date, in: TestFixtures.utc)
        // EST calendar date should be Jan 14, UTC should be Jan 15
        XCTAssertNotEqual(calDateEST, calDateUTC)
    }

    func testWindowOpenInDifferentTimezone() {
        // 14:00 UTC on Jan 15 = 23:00 JST on Jan 15
        let current = TestFixtures.date(hour: 14, minute: 0, timeZone: TestFixtures.utc)
        // Check with Tokyo timezone: 23:00 JST, window closes at 22:00
        XCTAssertFalse(
            DateUtilities.isWindowOpen(
                deadline: "09:00", windowClose: "22:00",
                currentTime: current, timeZone: TestFixtures.tokyo
            )
        )
    }

    // MARK: - Invalid Input

    func testInvalidTimeStringReturnsFalse() {
        let current = TestFixtures.date(hour: 12, minute: 0)
        XCTAssertFalse(
            DateUtilities.isCommitmentLocked(
                deadline: "invalid", currentTime: current, timeZone: TestFixtures.utc
            )
        )
    }

    func testInvalidTimeStringMidpointReturnsNil() {
        let day = TestFixtures.date()
        XCTAssertNil(
            DateUtilities.windowMidpoint(
                deadline: "bad", windowClose: "22:00",
                on: day, timeZone: TestFixtures.utc
            )
        )
    }
}
