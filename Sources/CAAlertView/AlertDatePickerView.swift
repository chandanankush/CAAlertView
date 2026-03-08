import SwiftUI

/// A SwiftUI date picker shown inside a popover.
/// Replaces `CAPickerViewController` from the Objective-C implementation.
///
/// - Supports DOB mode (maximum date = today) and future-date mode (minimum date = today).
/// - Supports date-only and date+time display.
/// - Returns the selected date as an `AlertItem` whose `name` is the formatted date string.
struct AlertDatePickerView: View {
    // MARK: - Configuration

    let datePickerMode: DatePickerMode
    let datePickerComponents: DatePickerComponents
    let onComplete: ([AlertItem]) -> Void
    let onCancel: (String) -> Void

    // MARK: - State

    @State private var selectedDate: Date = .init()
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            picker
            Button("Done", action: confirm)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 300, height: 150)
    }

    // MARK: - Subviews

    /// Renders the correct `DatePicker` for the selected mode and component set.
    @ViewBuilder
    private var picker: some View {
        switch (datePickerMode, datePickerComponents) {
        case (.dob, .dateOnly):
            DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.compact).labelsHidden()

        case (.dob, .dateAndTime):
            DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.compact).labelsHidden()

        case (.future, .dateOnly):
            DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(.compact).labelsHidden()

        case (.future, .dateAndTime):
            DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.compact).labelsHidden()
        }
    }

    // MARK: - Actions

    private func confirm() {
        let formatter = DateFormatter()
        formatter.dateFormat = datePickerComponents == .dateAndTime ? "MM-dd-yyyy HH:mm" : "MM-dd-yyyy"
        // ID 0 is the conventional identifier for date results, matching the original ObjC behaviour.
        let result = AlertItem(id: 0, name: formatter.string(from: selectedDate))
        dismiss()
        onComplete([result])
    }
}
