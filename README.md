# ZeplinPreviewSwiftUI

A Zeplin component preview for your SwiftUI views.
You can use Zeplin components instead of real views within your app until you implement them.

## The Purpose

To speed up prototype development and test design choices before full-featured implementation.
This is basically a clone of [figma-preview-swiftui](https://github.com/eDeniska/figma-preview-swiftui), project is heavily inspired by [flutter_figma_preview](https://github.com/vvsevolodovich/flutter_figma_preview) and [jetpack-compose-figma-preview](https://github.com/vvsevolodovich/jetpack-compose-figma-preview).

## Requirements

ZeplinPreviewSwiftUI uses SwiftUI features of macOS 11, iOS 14, tvOS 14, watchOS 7.

## Setup

Add ZeplinPreviewSwiftUI to your project via Swift Package Manager.

Create personal access token in account settings. 
<img width="635" alt="zeplin-access-token" src="https://user-images.githubusercontent.com/950994/119126489-c07a2800-ba3b-11eb-93e9-5540681b10e8.png">

Then pass this Zeplin access token via `Environment`.
```swift
struct ZeplinPreviewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.zeplinAccessToken, "<zeplin-access-token>")
        }
    }
}
```

## Usage

If you're using single Zeplin project for all designs, you can also pass it via `Environment`, so you won't need to specify it for each individual component. Project id could be taken from Zeplin App link (not web link) – typically, it goes after `pid=`.
```swift
struct ZeplinPreviewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.zeplinAccessToken, "<zeplin-access-token>")
                .environment(\.zeplinProjectId, "<default-project-id>")
        }
    }
}
```
When you need to insert your Zeplin component, you can use two ways. Either you can specify component ID and optionally project ID directly.
```swift
struct ContentView: View {
    var body: some View {
        ZeplinView(projectId: "<project-id>", componentId: "<component-id>")
    }
}
```
Alternatively, you can simply pass Zeplin App link for the component.
```swift
struct ContentView: View {
    var body: some View {
        ZeplinView(link: "zpl://components?pid=NNNNNNN&coids=MMMMMMM")
    }
}
```
`ZeplinView` will maintain its `aspectRatio`, but you'll need to control its `frame` when needed.

## Project and component lists to get component IDs

When you need to get component IDs for the elements, you can use `ZeplinProjectsList` view (it comes with `NavigationView`, so you could put somewhere in developer menu of your app on early stages, or use separate app to browse components).
Also, there is `ZeplinComponentsList` which shows components for a specific project (you can use `Environment`, or pass project ID directly to the view).
Please note that only components published in Styleguide will be listed.
```swift
struct ContentView: View {
    var body: some View {
        ZeplinProjectsList()
    }
}
```

## Reuse and contribution

You could use ZeplinPreviewSwiftUI in any way you want. If you would like to contribute to the projects – contact me.
Any ideas, suggestions, pull requests are welcome.

Anyway, ping me at [@edeniska](https://twitter.com/edeniska). :)

## See also

If you use Figma for designs – check [figma-preview-swiftui](https://github.com/eDeniska/figma-preview-swiftui).

## Roadmap

At the moment, there are couple of ideas of features to be added:
- ability to overlay view with Zeplin representation to check the pixel-perfect differences
- add UIKit version

## License

ZeplinPreviewSwiftUI is available under the MIT license. See the LICENSE file for more info.
