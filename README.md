# CAAlertView

A lightweight SwiftUI popover control for **item selection** and **date picking**, anchored to any view with an arrow — the same UX as the original UIKit implementation.

![Demo](https://github.com/chandanankush/CAAlertView/blob/master/CAAlertView.gif)

---

## Requirements

| | Minimum |
|---|---|
| iOS | 16.0 |
| macCatalyst | 16.0 |
| macOS | 13.0 |
| Swift | 5.9 |

> **Popover arrow on iPhone** requires iOS 16.4+. On iOS 16.0–16.3 the picker falls back to a system sheet.

---

## Installation

### Swift Package Manager

In Xcode: **File → Add Package Dependencies…**, paste the repository URL, and add `CAAlertView` to your target.

Or add it manually in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/chandanankush/CAAlertView.git", from: "2.0.0")
],
targets: [
    .target(name: "MyApp", dependencies: ["CAAlertView"])
]
```

---

## Usage

### 1. Prepare your data

```swift
import CAAlertView

let items: [AlertItem] = [
    AlertItem(id: 0, name: "Option A"),
    AlertItem(id: 1, name: "Option B", isDefaultSelected: true),
    AlertItem(id: 2, name: "Disabled",  isSelectable: false),
]
```

`AlertItem` replaces `CACustomAlertObject` from the original Objective-C API.

| Property | Type | Default | Description |
|---|---|---|---|
| `id` | `Int` | — | Unique identifier |
| `name` | `String` | — | Display text |
| `isSelectable` | `Bool` | `true` | Grayed-out and non-tappable when `false` |
| `isDefaultSelected` | `Bool` | `false` | Pre-checked when the popover opens |

---

### 2. Single selection (table)

```swift
struct MyView: View {
    @State private var showPicker = false
    @State private var result = ""

    var body: some View {
        Button("Pick item") { showPicker = true }
            .caAlertView(
                isPresented: $showPicker,
                type: .table,
                items: items
            ) { selected in
                result = selected.first?.name ?? ""
            }
    }
}
```

Tapping a row delivers the result immediately and closes the popover.

---

### 3. Multiple selection (table)

```swift
Button("Pick items") { showPicker = true }
    .caAlertView(
        isPresented: $showPicker,
        type: .table,
        items: items,
        isMultipleSelection: true
    ) { selected in
        result = selected.map(\.name).joined(separator: ", ")
    }
```

Items are toggled with a checkmark. The result is delivered when the user **dismisses the popover** (taps outside), matching the original behaviour.

---

### 4. Date picker — date of birth (max = today)

```swift
Button("Pick DOB") { showDate = true }
    .caAlertView(
        isPresented: $showDate,
        type: .datePicker,
        datePickerMode: .dob
    ) { result in
        dob = result.first?.name ?? ""   // "MM-dd-yyyy"
    }
```

---

### 5. Date picker — future date (min = today)

```swift
Button("Pick future date") { showDate = true }
    .caAlertView(
        isPresented: $showDate,
        type: .datePicker,
        datePickerMode: .future
    ) { result in
        date = result.first?.name ?? ""
    }
```

---

### 6. Date + time

```swift
Button("Pick date & time") { showDate = true }
    .caAlertView(
        isPresented: $showDate,
        type: .datePicker,
        datePickerMode: .dob,
        datePickerComponents: .dateAndTime
    ) { result in
        dateTime = result.first?.name ?? ""   // "MM-dd-yyyy HH:mm"
    }
```

The date picker uses a **wheel** style and returns the selected value when the popover is **dismissed** (tap outside) — no Done button needed.

---

## API Reference

### `caAlertView` modifier

```swift
func caAlertView(
    isPresented: Binding<Bool>,
    type: CAAlertViewType,
    items: [AlertItem] = [],
    isMultipleSelection: Bool = false,
    datePickerMode: DatePickerMode = .dob,
    datePickerComponents: DatePickerComponents = .dateOnly,
    onComplete: @escaping ([AlertItem]) -> Void,
    onCancel: @escaping (String) -> Void = { _ in }
) -> some View
```

### `CAAlertViewType`

| Case | Description |
|---|---|
| `.table` | Scrollable list of `AlertItem`s |
| `.datePicker` | Wheel date (and optional time) picker |

### `DatePickerMode`

| Case | Description |
|---|---|
| `.dob` | Maximum selectable date is today |
| `.future` | Minimum selectable date is today |

### `DatePickerComponents`

| Case | Return format |
|---|---|
| `.dateOnly` | `"MM-dd-yyyy"` |
| `.dateAndTime` | `"MM-dd-yyyy HH:mm"` |

---

## Migrating from Objective-C

| Objective-C | Swift |
|---|---|
| `CACustomAlertObject` | `AlertItem` |
| `initWithObjectName:AndID:` | `AlertItem(id:name:)` |
| `CAAlertViewTypeTable` | `.table` |
| `CAAlertViewTypeDatePicker` | `.datePicker` |
| `isMultipleSelectionAllowed` | `isMultipleSelection:` parameter |
| `isDatePickerTypeDOB = YES` | `datePickerMode: .dob` |
| `isDatePickerTypeDOB = NO` | `datePickerMode: .future` |
| `isDateAndTimeBoth = YES` | `datePickerComponents: .dateAndTime` |
| `CAAlertViewDelegate` | `onComplete` / `onCancel` closures |
| `showAlertView:sender` | `.caAlertView(isPresented:...)` modifier |
