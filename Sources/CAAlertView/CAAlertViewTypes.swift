import Foundation

/// The presentation mode for `CAAlertView`.
public enum CAAlertViewType {
    /// Shows a scrollable list of `AlertItem`s for selection.
    case table
    /// Shows a `DatePicker` for date (and optionally time) selection.
    case datePicker
}

/// Controls the valid date range when using `.datePicker` mode.
public enum DatePickerMode {
    /// Date of Birth mode — the maximum selectable date is today.
    case dob
    /// Future date mode — the minimum selectable date is today.
    case future
}

/// Controls what components the date picker displays.
public enum DatePickerComponents {
    /// Shows date only; returns a string formatted as `"MM-dd-yyyy"`.
    case dateOnly
    /// Shows date and time; returns a string formatted as `"MM-dd-yyyy HH:mm"`.
    case dateAndTime
}
