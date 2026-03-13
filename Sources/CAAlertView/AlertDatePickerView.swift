import SwiftUI

/// A SwiftUI date picker shown inside a popover.
/// Replaces `CAPickerViewController` from the Objective-C implementation.
///
/// - Uses wheel style (iOS) to match the original UIDatePicker presentation.
/// - Returns the selected date when the popover is dismissed (tap outside),
///   exactly matching the original `popoverPresentationControllerDidDismissPopover:` behaviour.
struct AlertDatePickerView: View {
    // MARK: - Configuration

    let datePickerMode: DatePickerMode
    let datePickerComponents: DatePickerComponents
    let onComplete: ([AlertItem]) -> Void

    // MARK: - State

    @State private var selectedDate: Date = .init()

    // MARK: - Body

    var body: some View {
        picker
            .frame(width: 300, height: 230)
            .onDisappear { complete() }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var picker: some View {
        switch (datePickerMode, datePickerComponents) {
        case (.dob, .dateOnly):
            styledPicker(DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: .date))

        case (.dob, .dateAndTime):
            styledPicker(DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: [.date, .hourAndMinute]))

        case (.future, .dateOnly):
            styledPicker(DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: .date))

        case (.future, .dateAndTime):
            styledPicker(DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]))
        }
    }

    /// Applies `.wheel` on iOS (matching the original UIDatePicker).
    /// Falls back to the platform default on macOS.
    @ViewBuilder
    private func styledPicker(_ dp: DatePicker<Text>) -> some View {
        #if os(iOS)
        dp.datePickerStyle(.wheel).labelsHidden()
        #else
        dp.labelsHidden()
        #endif
    }

    // MARK: - Actions

    private func complete() {
        let formatter = DateFormatter()
        formatter.dateFormat = datePickerComponents == .dateAndTime ? "MM-dd-yyyy HH:mm" : "MM-dd-yyyy"
        // ID 1 matches the original ObjC `initWithObjectName:AndID:1` call.
        let result = AlertItem(id: 1, name: formatter.string(from: selectedDate))
        onComplete([result])
    }
}
