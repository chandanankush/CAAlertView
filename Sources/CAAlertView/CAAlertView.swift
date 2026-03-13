import SwiftUI

// MARK: - View Modifier

/// Attaches a `CAAlertView` popover to any SwiftUI view.
///
/// Use the `caAlertView(isPresented:...)` convenience extension on `View` rather than
/// instantiating this modifier directly.
public struct CAAlertViewModifier: ViewModifier {
    // MARK: - Bindings & configuration

    @Binding var isPresented: Bool
    let type: CAAlertViewType
    let items: [AlertItem]
    let isMultipleSelection: Bool
    let datePickerMode: DatePickerMode
    let datePickerComponents: DatePickerComponents
    let onComplete: ([AlertItem]) -> Void
    let onCancel: (String) -> Void

    // MARK: - Body

    public func body(content: Content) -> some View {
        content.popover(isPresented: $isPresented) {
            // Force a real popover with an arrow on compact (iPhone) screens,
            // matching the original UIModalPresentationPopover + adaptivePresentationStyle=.none.
            // Available from iOS 16.4 / macOS 14; older OSes fall back to the system sheet.
            if #available(iOS 16.4, macOS 14.0, *) {
                popoverContent
                    .presentationCompactAdaptation(.popover)
            } else {
                popoverContent
            }
        }
    }

    @ViewBuilder
    private var popoverContent: some View {
        switch type {
        case .table:
            AlertListView(
                items: items,
                isMultipleSelection: isMultipleSelection,
                onComplete: { result in
                    isPresented = false
                    onComplete(result)
                },
                onCancel: { info in
                    isPresented = false
                    onCancel(info)
                }
            )

        case .datePicker:
            AlertDatePickerView(
                datePickerMode: datePickerMode,
                datePickerComponents: datePickerComponents,
                onComplete: { result in
                    isPresented = false
                    onComplete(result)
                }
            )
        }
    }
}

// MARK: - View extension (public API)

public extension View {
    /// Presents a `CAAlertView` popover anchored to this view.
    ///
    /// ### Table example
    /// ```swift
    /// Button("Pick item") { showPicker = true }
    ///     .caAlertView(
    ///         isPresented: $showPicker,
    ///         type: .table,
    ///         items: myItems
    ///     ) { selected in
    ///         print(selected.map(\.name))
    ///     }
    /// ```
    ///
    /// ### Date picker example
    /// ```swift
    /// Button("Pick date") { showDate = true }
    ///     .caAlertView(
    ///         isPresented: $showDate,
    ///         type: .datePicker,
    ///         datePickerMode: .dob
    ///     ) { result in
    ///         print(result.first?.name ?? "")  // "MM-dd-yyyy"
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: Binding that controls popover visibility.
    ///   - type: `.table` for a list picker, `.datePicker` for a date wheel.
    ///   - items: Data source for `.table` mode (ignored in `.datePicker` mode).
    ///   - isMultipleSelection: Allow selecting more than one item. Default `false`.
    ///   - datePickerMode: `.dob` (max = today) or `.future` (min = today). Default `.dob`.
    ///   - datePickerComponents: `.dateOnly` or `.dateAndTime`. Default `.dateOnly`.
    ///   - onComplete: Called with the selected `AlertItem`s when the user confirms.
    ///   - onCancel: Called with a descriptive message when dismissed with no selection.
    func caAlertView(
        isPresented: Binding<Bool>,
        type: CAAlertViewType,
        items: [AlertItem] = [],
        isMultipleSelection: Bool = false,
        datePickerMode: DatePickerMode = .dob,
        datePickerComponents: DatePickerComponents = .dateOnly,
        onComplete: @escaping ([AlertItem]) -> Void,
        onCancel: @escaping (String) -> Void = { _ in }
    ) -> some View {
        modifier(
            CAAlertViewModifier(
                isPresented: isPresented,
                type: type,
                items: items,
                isMultipleSelection: isMultipleSelection,
                datePickerMode: datePickerMode,
                datePickerComponents: datePickerComponents,
                onComplete: onComplete,
                onCancel: onCancel
            )
        )
    }
}
