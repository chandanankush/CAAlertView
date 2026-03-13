import Foundation

/// Represents a selectable item in the alert list.
/// Replaces `CACustomAlertObject` from the Objective-C implementation.
public struct AlertItem: Identifiable, Equatable {
    /// Unique identifier for the item.
    public let id: Int
    /// Display name shown in the list.
    public let name: String
    /// Whether the user can select this item. Non-selectable items appear grayed out.
    public var isSelectable: Bool
    /// Whether this item should be pre-selected when the list appears.
    public var isDefaultSelected: Bool

    public init(
        id: Int,
        name: String,
        isSelectable: Bool = true,
        isDefaultSelected: Bool = false
    ) {
        self.id = id
        self.name = name
        self.isSelectable = isSelectable
        self.isDefaultSelected = isDefaultSelected
    }
}
