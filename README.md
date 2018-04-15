## Irish Rail Realtime

Project that illustrates how to access the Irish Rail Realtime API, declared at https://api.irishrail.ie/realtime/. This is a very simple iOS project, composed of two screens, one for displaying the stations list and one for displaying a selected station data.

Using Swift 4.1 as the programming language, it is implemented following the MVVM pattern, with the addition of a App Coordinator to manage the transitions between each view controller. Each view controller subclasses a generic ListViewController:
```
class ListViewController<ViewModel: ListViewModelRepresentable,
    CellType: ConfigurableCell>: UIViewController, UITableViewDataSource, UITableViewDelegate, FlowController where CellType: UITableViewCell
```

#### Dependencies

- SwiftLint - swift linter, to help enforce style and conventions
- SWXMLHash - swift XML parser, to parse the responses from the API
- Nimble - a matcher framework, for easier to write and read unit tests

The dependencies are managed with Cocoapods (v1.5.0), so before compiling the project, please run `pod install`

#### Todo
- Favorite stations
- Station search
- Find station by location
- Improve user interface: better fonts and colors, support landscape, add loading indicators and states, improve empty states
- Add sections and section index titles to station list, for better finding the desired station
