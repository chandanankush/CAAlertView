import SwiftUI
import CAAlertView

/// Demo app that exercises every feature of `CAAlertView`.
/// Replaces `ViewController.m` from the Objective-C implementation.
struct ContentView: View {
    // MARK: - State

    @State private var showTableSingle = false
    @State private var showTableMultiple = false
    @State private var showDateDOB = false
    @State private var showDateFuture = false
    @State private var showDateAndTime = false

    @State private var resultText = "Tap a button to see results here"

    // MARK: - Sample data (mirrors the ObjC demo: "chandan 0" … "chandan 10")

    private let sampleItems: [AlertItem] = (0...10).map { i in
        AlertItem(
            id: i,
            name: "chandan \(i)",
            isSelectable: i != 3,           // item 3 is intentionally non-selectable
            isDefaultSelected: i == 1       // item 1 is pre-selected
        )
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List {
                tableSection
                datePickerSection
                resultSection
            }
            .navigationTitle("CAAlertView Demo")
        }
    }

    // MARK: - Sections

    private var tableSection: some View {
        Section("Table Picker") {
            Button("Single Selection") { showTableSingle = true }
                .caAlertView(
                    isPresented: $showTableSingle,
                    type: .table,
                    items: sampleItems
                ) { selected in
                    resultText = "Selected: \(selected.map(\.name).joined(separator: ", "))"
                } onCancel: { info in
                    resultText = "Cancelled: \(info)"
                }

            Button("Multiple Selection") { showTableMultiple = true }
                .caAlertView(
                    isPresented: $showTableMultiple,
                    type: .table,
                    items: sampleItems,
                    isMultipleSelection: true
                ) { selected in
                    resultText = "Selected: \(selected.map(\.name).joined(separator: ", "))"
                } onCancel: { info in
                    resultText = "Cancelled: \(info)"
                }
        }
    }

    private var datePickerSection: some View {
        Section("Date Picker") {
            Button("DOB (date only, max = today)") { showDateDOB = true }
                .caAlertView(
                    isPresented: $showDateDOB,
                    type: .datePicker,
                    datePickerMode: .dob,
                    datePickerComponents: .dateOnly
                ) { result in
                    resultText = "DOB: \(result.first?.name ?? "")"
                }

            Button("Future Date (date only, min = today)") { showDateFuture = true }
                .caAlertView(
                    isPresented: $showDateFuture,
                    type: .datePicker,
                    datePickerMode: .future,
                    datePickerComponents: .dateOnly
                ) { result in
                    resultText = "Future date: \(result.first?.name ?? "")"
                }

            Button("Date & Time (DOB mode)") { showDateAndTime = true }
                .caAlertView(
                    isPresented: $showDateAndTime,
                    type: .datePicker,
                    datePickerMode: .dob,
                    datePickerComponents: .dateAndTime
                ) { result in
                    resultText = "Date & time: \(result.first?.name ?? "")"
                }
        }
    }

    private var resultSection: some View {
        Section("Result") {
            Text(resultText)
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
