import Foundation

/// Date helpers for commitment windows and scheduling.
/// All functions take explicit TimeZone and Date parameters — no globals.
public enum DateUtilities {

    /// Whether the commitment deadline has passed for the current day.
    /// - Parameters:
    ///   - deadline: Deadline time string in "HH:mm" format.
    ///   - currentTime: The reference date/time.
    ///   - timeZone: The user's timezone.
    /// - Returns: `true` if `currentTime` is at or past today's deadline.
    public static func isCommitmentLocked(
        deadline: String,
        currentTime: Date,
        timeZone: TimeZone
    ) -> Bool {
        guard let deadlineDate = dateFromTimeString(deadline, on: currentTime, in: timeZone) else {
            return false
        }
        return currentTime >= deadlineDate
    }

    /// Whether the check-in window is currently open.
    /// The window opens at the commitment deadline and closes at `windowClose`.
    /// - Parameters:
    ///   - deadline: Deadline time string in "HH:mm" format.
    ///   - windowClose: Window close time string in "HH:mm" format.
    ///   - currentTime: The reference date/time.
    ///   - timeZone: The user's timezone.
    /// - Returns: `true` if `currentTime` is within [deadline, windowClose).
    public static func isWindowOpen(
        deadline: String,
        windowClose: String,
        currentTime: Date,
        timeZone: TimeZone
    ) -> Bool {
        guard let deadlineDate = dateFromTimeString(deadline, on: currentTime, in: timeZone),
              let closeDate = dateFromTimeString(windowClose, on: currentTime, in: timeZone) else {
            return false
        }
        return currentTime >= deadlineDate && currentTime < closeDate
    }

    /// The midpoint of the check-in window on a given day.
    /// - Parameters:
    ///   - deadline: Deadline time string in "HH:mm" format.
    ///   - windowClose: Window close time string in "HH:mm" format.
    ///   - day: The reference date (any time on the desired day).
    ///   - timeZone: The user's timezone.
    /// - Returns: The `Date` at the midpoint, or `nil` if time strings are invalid.
    public static func windowMidpoint(
        deadline: String,
        windowClose: String,
        on day: Date,
        timeZone: TimeZone
    ) -> Date? {
        guard let deadlineDate = dateFromTimeString(deadline, on: day, in: timeZone),
              let closeDate = dateFromTimeString(windowClose, on: day, in: timeZone) else {
            return nil
        }
        let interval = closeDate.timeIntervalSince(deadlineDate)
        return deadlineDate.addingTimeInterval(interval / 2.0)
    }

    /// Strips the time component from a `Date`, returning midnight in the given timezone.
    /// - Parameters:
    ///   - date: The source date.
    ///   - timeZone: The timezone for calendar-day computation.
    /// - Returns: A `Date` representing the start of the calendar day.
    public static func calendarDate(from date: Date, in timeZone: TimeZone) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar.startOfDay(for: date)
    }

    // MARK: - Private

    /// Builds a `Date` from an "HH:mm" string on the same calendar day as `reference`.
    private static func dateFromTimeString(
        _ timeString: String,
        on reference: Date,
        in timeZone: TimeZone
    ) -> Date? {
        let parts = timeString.split(separator: ":")
        guard parts.count == 2,
              let hour = Int(parts[0]),
              let minute = Int(parts[1]) else {
            return nil
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone

        let dayComponents = calendar.dateComponents([.year, .month, .day], from: reference)
        var components = DateComponents()
        components.year = dayComponents.year
        components.month = dayComponents.month
        components.day = dayComponents.day
        components.hour = hour
        components.minute = minute
        components.second = 0

        return calendar.date(from: components)
    }
}
