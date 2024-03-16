# PopupUI
Easy to pop up any view written with SwiftUI！ 

SwiftUI 实现的弹窗控件，简单易用！[《中文文档》](README_CN.md)

SwiftUI で作られた PopupView は、簡単で使いやすいです！[『日本語のドキュメント』](README_JP.md)


 

## Screenshot

## Installation

#### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/pikacode/PopupUI.git")
]
```


#### Cocoapods

```ruby
pod 'PopupUI'
```

  

## Usage
```swift
import PopupUI
```

#### Basic Usage

##### 1.Adding
Add `.popupUI()` after a view to pop up within it's scope:
```swift
var body: some View {
    VStack {
        ...
    }
    .popupUI()  // <-- Add to the view
}
```
Or add to the root view, only once to pop up throughout the entire application:
```swift
@main
struct PopupUI_demoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .popupUI()  // <-- Add to the root view
        }
    }
}
```

##### 2.Showing
```swift
PopupUI
    .show(Text("Hello, PopupUI!"))
```


##### 3.Hiding
```swift
PopupUI
    .hide()     // <-- Hide the last popup 
```


​    
#### Customization
Customize various parameters:
```swift
PopupUI
    .show(YourCustomView())                 // <-- The view to be shown
    .from(.bottom)                          // <-- The direction from which the view is shown
    .stay(2)                                // <-- The duration of the view staying
    .to(.center, .easeOut(duration: 0.3))   // <-- The direction to which the view is hidden
    .background(Color.black.opacity(0.3))   // <-- The background view
    .padding(24)                            // <-- The padding of the view
    .isSafeArea(true)                       // <-- Whether to avoid the safe area
    .id("Unique Popup ID")                  // <-- The unique identifier, when not passed, the same id is used by default, so only one popup can be displayed at a time, you can display multiple popups at the same time by setting different ids
    .isAvoidKeyboard(true)                  // <-- Whether to avoid the keyboard
    .isOpaque(true)                         // <-- Whether to prevent the user from interacting with the background view
    .dismissWhenTapBackground(true)         // <-- Whether to hide when the background view is tapped
    .dismissCallback { id in                // <-- The callback when the view is hidden
        print("Popup dismissed: \(id)")
    }
```

Display a view and parameters in a callback way:
```swift
PopupUI
    .show {
        VStack {
            ...
        }
    } config: { config in
        config.from = ...
    }
```

#### Hide a specified popup
```swift
PopupUI
    .hide("Unique Popup ID")    // <-- Hide the specified popup
```

  

#### Global Configuration
Customize the default parameters through `PopupConfiguration.default` to simplify the popup code:
```swift
let configuration = PopupConfiguration()
configuration.stay = 2
configuration.to = .center
...
PopupConfiguration.default = configuration
```
