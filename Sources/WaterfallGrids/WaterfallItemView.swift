import SwiftUI

/// A view that will contain all the items in a waterfall grid for a specific column or row.
///
/// You can't create this view, you obtain it from the `waterfallItem` closure in the ``WaterfallGrid`` or ``LazyWaterfallGrid``
/// when using custom init like ``WaterfallGrid/init(items:spacing:data:content:waterfallItem:)`` to customize the appearance of the whole column or row.
///
/// Read  <doc:AdvancedUsage> article for examples.
public enum WaterfallItemView<
  Content: View,
  ItemData: RandomAccessCollection,
  ID: Hashable
>: View where ItemData.Index == Int {
  case vertical(WaterfallColumnView<Content, ItemData, ID>)
  case horizontal(WaterfallRowView<Content, ItemData, ID>)
  
  public var body: some View {
    switch self {
    case .vertical(let v): v
    case .horizontal(let v): v
    }
  }
}

/// Provides information about a full column or row being rendered in a waterfall grid.
public struct WaterfallItemViewInfo<Data: RandomAccessCollection> where Data.Index == Int {
  public enum GridItem: Sendable, Equatable {
    case column(WaterfallItems.Column)
    case row(WaterfallItems.Row)
  }
  /// The type of the grid item being rendered.
  public let gridItem: GridItem
  
  /// The index of the column or row being rendered.
  public let index: Int
  
  /// The total number of columns or rows in the whole grid.
  public let itemsCount: Int
  
  /// The data being rendered in the column or row.
  public let data: ArrayGridSlice<Data>
  
  /// The column being rendered if the grid item is a column otherwise `nil`.
  public var column: WaterfallItems.Column? {
    switch gridItem {
    case .column(let column): column
    case .row: nil
    }
  }
  
  /// The row being rendered if the grid item is a row otherwise `nil`.
  public var row: WaterfallItems.Row? {
    switch gridItem {
    case .row(let row): row
    case .column: nil
    }
  }
}

extension WaterfallItemViewInfo: Equatable where Data.Element: Equatable {}
extension WaterfallItemViewInfo: Sendable where Data: Sendable {}

/// A view that represents a column in a waterfall grid.
public struct WaterfallColumnView<Content: View, Data: RandomAccessCollection, ID: Hashable>: View where Data.Index == Int {
  let isLazy: Bool
  let namespace: Namespace.ID
  let column: WaterfallItems.Column
  let data: ArrayGridSlice<Data>
  let id: KeyPath<Data.Element, ID>
  let content: (Data.Element) -> Content
  
  public var body: some View {
    let view = ForEach(data, id: id) { element in
      content(element)
        .matchedGeometryEffect(id: element[keyPath: id], in: namespace)
        .transition(.scale(scale: 1))
    }
    if isLazy {
      LazyVStack(alignment: column.alignment, spacing: column.spacing) {
        view
      }
    } else {
      VStack(alignment: column.alignment, spacing: column.spacing) {
        view
      }
    }
  }
}

/// A view that represents a row in a waterfall grid.
public struct WaterfallRowView<Content: View, Data: RandomAccessCollection, ID: Hashable>: View where Data.Index == Int {
  let isLazy: Bool
  let namespace: Namespace.ID
  let row: WaterfallItems.Row
  let data: ArrayGridSlice<Data>
  let id: KeyPath<Data.Element, ID>
  let content: (Data.Element) -> Content
  
  public var body: some View {
    let view = ForEach(data, id: id) { element in
      content(element)
        .matchedGeometryEffect(id: element[keyPath: id], in: namespace)
        .transition(.scale(scale: 1))
    }
    if isLazy {
      LazyHStack(alignment: row.alignment, spacing: row.spacing) {
        view
      }
    } else {
      HStack(alignment: row.alignment, spacing: row.spacing) {
        view
      }
    }
  }
}
