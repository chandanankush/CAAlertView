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
    /// Tracks whether a result has already been delivered (single-selection tap),
    /// so `onDisappear` doesn't fire a second callback.
    @State private var completed = false

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

        // Pre-select default-selected items (matches ObjC `viewDidLoad` logic).
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
        // Multiple-selection: deliver the result when the popover is dismissed by
        // tapping outside — matches `popoverPresentationControllerDidDismissPopover:`.
        .onDisappear {
            guard isMultipleSelection, !completed else { return }
            let selected = items.filter { selectedIDs.contains($0.id) }
            onComplete(selected)
        }
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
            // Single selection — deliver result immediately, then close the popover.
            // Matches ObjC `popover:selectedData:` → immediate delegate call.
            completed = true
            let selected = items.filter { $0.id == item.id }
            onComplete(selected)
        }
    }
}
