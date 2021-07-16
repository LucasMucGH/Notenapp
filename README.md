# Notenapp

## Description
A simple app for teachers to create students and adding their grades.

## Features
- Adding and removing a `Student`
  - A student has the following properties: `first name`, `last name` and `class`
- Adding and removing a `Grade` from a Student
  - A grade has the following properties: `value` and `grade type`
- Adding and removing a `Grade Type`
  - A grade type has the following properties: `name` and `weight`
  - The presets are: *Mündlich 1.0* and *Schriflich 2.0*
- Persistence storage to `CoreData` and `iCloud`
- Sorting Students by `name`, `class` and their `final grade`
- `Vibration` for success and errors
- `DarkMode` support

### Planned but not finished Features
- Editing a `Student`, `Grade` and `Grade Type`
- Using MVVM Pattern
  - Not possible as far as I know, due to `CoreData` *FetchRequest* not working with `ObservableObject`
- Adding Unity Testing

## Frameworks, Librarys and SDKs
- `SwiftUI`
- `CoreData`

## Supported Devices
- `iOS` 14+
- `iPadOS` 14+
- `MacOS` 11+ (**experimental**)
  - **Known Bugs:**
    - The "swipe to delete gesture is not working on macOS. So there is no way of removing students
    - In the navigation bar the picker `SortBy` can only be opend by right-clicking.
