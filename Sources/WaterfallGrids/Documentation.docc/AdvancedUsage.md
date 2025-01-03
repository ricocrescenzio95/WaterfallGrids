# Advanced Usage

Shows how to use the library with more advanced features.

## Overview

In most cases you can use the library with the default configuration. But if you need more control over the layout or the lazy loading, you can use the advanced features.

The overall structure of both ``WaterfallGrid`` and ``LazyWaterfallGrid`` is compososed of 3 main components internally:

![schema](structure)

- The main `WaterfallGrid` is the view itself
- The `Waterfall Item View` is a single column (or row) and it's built using `VStack` or `HStack` for ``WaterfallGrid``, and `LazyVStack` or `LazyHStack` for ``LazyWaterfallGrid``.
- The `Content` is a view you provide.

Since the view is built on top of those components, it allows you to leverage SwiftUI modifiers.

> Tip:
> In general, **non**-lazy containers work better in SwiftUI; they're more reliable when performing animations, programmatic scroll and so on; for this reason you should use ``LazyWaterfallGrid`` only if you need lazy loading (i.e. showing a huge amount of data, or do stuff when items appear/disappear).

### Customize the Waterfall Item View

You can customize the `Waterfall Item View` by using ``WaterfallGrid/init(items:spacing:data:content:waterfallItem:)`` or ``LazyWaterfallGrid/init(items:spacing:data:content:waterfallItem:)`` and returning a modified view for `waterfallItem`

The following example apply a red background to an entire column if that column's index is even; you use `item` (``WaterfallItemViewInfo``) from the `waterfallItem` closure to get information of the column or row you're modifying.

```swift
WaterfallGrid(items: .columns([.init(), .init()]), spacing: 12, data: items) { item in
  MyView(item: item)
} waterfallItem: { item, itemView in
  itemView
    .background(item.index.isMultiple(of: 2) ? .red : .clear)
}
```

> Important:
> You must always return a modified `itemView`, otherwise no content will be shown.

The `itemView` is itself the underlying `XStack` or `LazyXStack` so you can apply modifiers like `scrollTargetLayout(isEnabled:)` to control scroll behavior. For example, you could set up a pagination scroll based on items in the first column:

```swift
ScrollView {
  WaterfallGrid(items: .columns([.init(), .init()]), spacing: 12, data: items) { item in
    MyView(item: item)
  } waterfallItem: { item, itemView in
    itemView
      .scrollTargetLayout(isEnabled: item.index == 0)
  }
}
.scrollTargetBehavior(.viewAligned)
```

### Section header and footer

You could show a section header (or footer) by nesting the view into another `LazyVStack` or `LazyHStack`; **the lazy loading will be preserved** when using ``LazyWaterfallGrid``:

```swift
LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
  Section {
    LazyWaterfallGrid(items: .columns([.init(), .init()]), data: data) { item in
      MyView(item: item)
    }
    .padding()
  } header: {
    Text("First section")
      .frame(maxWidth: .infinity)
      .padding()
      .background(.bar)
  }
  Section {
    LazyWaterfallGrid(items: .columns([.init(), .init(), .init()]), data: data2) { item in
      MyView(item: item)
    }
  } header: {
    Text("Second section")
      .frame(maxWidth: .infinity)
      .padding(.vertical)
      .background(.bar)
  }
  if isLoadingMore {
    ProgressView()
      .padding()
  }
}
.waterfallNamespace(namespace)
```

> Tip: 
> In the above example, there are 2 grids in the same vertical stack. If you need to animate items move, of different grids, you can apply ``SwiftUICore/View/waterfallNamespace(_:)`` the container.

### Scroll to item ID

You can use `ScrollViewReader` or iOS 18 APIs to perform programmatic scroll (even though with lazy view is not always reliable; this is a SwiftUI issue with the underlying `LazyVStack`)

```swift
ScrollViewReader { proxy in
  ScrollView {
    WaterfallGrid(items: .columns([.init(), .init()]), data: data) { item in
      MyView(item: item)
    }
    Button("Scroll to item 10") {
      proxy.scrollTo(10)
    }
  }
}
```
