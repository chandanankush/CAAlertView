import SwiftUI

/// A SwiftUI list shown inside a popover for selecting one or multiple `AlertItem`s.
/// Replaces `CAPopoverViewController` from the Objective-C implementation.
struct AlertListView: View {
    // MARK: - Configuration

    let items: [AlertItem]
    let isMultipleSelection: Bool
    let onComplete: ([AlertItem]) -> Void
    let onCancel: (String) -> Void

    // MARK: - State

    @State private var selectedIDs: Set<Int>
    @Environment(\.dismiss) private var dismiss

    // MARK: - Init

    init(
        items: [AlertItem],
        isMultipleSelection: Bool,
        onComplete: @escaping ([AlertItem]) -> Void,
        onCancel: @escaping (String) -> Void
    ) {
        self.items = items
        self.isMultipleSelection = isMultipleSelection
        self.onComplete = onComplete
        self.onCancel = onCancel

        // Pre-select default-selected items
        let defaults = items
            .filter { $0.isSelectable && $0.isDefaultSelected }
            .map(\.id)
        _selectedIDs = State(initialValue: Set(defaults))
    }

    // MARK: - Body

    var body: some View {
        Group {
            if items.isEmpty {
                emptyView
            } else {
                listView
            }
        }
        .frame(width: 200, height: 300)
    }

    // MARK: - Subviews

    private var emptyView: some View {
        Text("No Data To Display")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var listView: some View {
        List(items) { item in
            row(for: item)
                .contentShape(Rectangle())
                .onTapGesture { handleTap(on: item) }
        }
        .listStyle(.plain)
        // For multiple selection, show a Done button to confirm
        .overlay(alignment: .top) {
            if isMultipleSelection {
                multiSelectionToolbar
            }
        }
    }

    private func row(for item: AlertItem) -> some View {
        HStack {
            Text(item.name)
                .foregroundColor(item.isSelectable ? .primary : .secondary)
            Spacer()
            if selectedIDs.contains(item.id) {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.vertical, 4)
    }

    /// Floating "Done" bar for multiple-selection mode.
    private var multiSelectionToolbar: some View {
        HStack {
            Spacer()
            Button("Done") { confirmMultipleSelection() }
                .padding(.horizontal)
                .padding(.vertical, 8)
        }
        .background(.thinMaterial)
    }

    // MARK: - Actions

    private func handleTap(on item: AlertItem) {
        guard item.isSelectable else { return }

        if isMultipleSelection {
            if selectedIDs.contains(item.id) {
                selectedIDs.remove(item.id)
            } else {
                selectedIDs.insert(item.id)
            }
        } else {
            // Single selection — return immediately
            let selected = items.filter { $0.id == item.id }
            dismiss()
            onComplete(selected)
        }
    }

    private func confirmMultipleSelection() {
        let selected = items.filter { selectedIDs.contains($0.id) }
        dismiss()
        if selected.isEmpty {
            onCancel("No items selected")
        } else {
            onComplete(selected)
        }
    }
}
