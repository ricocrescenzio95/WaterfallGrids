import SwiftUI

/// A view that arranges its children in a grid that grows in the specified axis.
///
/// Use a lazy waterfall grid when you want to display a large scrollable collection of views arranged in a two dimensional layout.
/// The number of rows can grow unbounded, but you specify the number of columns or rows by providing a ``WaterfallItems`` instances to the grid’s initializer.
///
/// > If you don't need lazy loading, you should use ``WaterfallGrid`` instead, as it's more reliable when dealing with programmatic scrolls or items animations (such as insertions, removals or moves).
public struct LazyWaterfallGrid<
  Content: View,
  ModifiedWaterfallItemView: View,
  Data: RandomAccessCollection,
  ID: Hashable
>: View where Data.Index == Int {
  @Environment(\.waterfallNamespace) private var waterfallNamespace
  @Namespace private var namespace

  let items: WaterfallItems
  let spacing: CGFloat?
  let data: Data
  let id: KeyPath<Data.Element, ID>
  let content: (Data.Element) -> Content
  let waterfallItem: (_ item: WaterfallItemViewInfo<Data>, _ itemView: WaterfallItemView<Content, Data, ID>) -> ModifiedWaterfallItemView
  
  /// Creates a new grid view with the given items and data.
  /// - Parameters:
  ///   - items: The layout of the grid. You can use either ``WaterfallItems/columns(_:)`` or ``WaterfallItems/rows(_:)`` passing the number of items you need to tell the view how many rows or column are needed.
  ///   - spacing: The spacing between items in the grid. If `nil`, the grid will use the default spacing.
  ///   - data: The data to display in the grid.
  ///   - id: A key path to the `ID` property of `Data.Element`.
  ///   - content: A view builder that creates the content of each item in the grid.
  ///   - waterfallItem: A view builder that you can use to customize each column or row in the grid.
  public init(
    items: WaterfallItems,
    spacing: CGFloat? = nil,
    data: Data,
    id: KeyPath<Data.Element, ID>,
    @ViewBuilder content: @escaping (Data.Element) -> Content,
    @ViewBuilder waterfallItem: @escaping (_ item: WaterfallItemViewInfo<Data>, _ itemView: WaterfallItemView<Content, Data, ID>) -> ModifiedWaterfallItemView
  ) {
    self.items = items
    self.spacing = spacing
    self.data = data
    self.id = id
    self.content = content
    self.waterfallItem = waterfallItem
  }
  
  /// Creates a new grid view with the given items and data.
  /// - Parameters:
  ///   - items: The layout of the grid. You can use either ``WaterfallItems/columns(_:)`` or ``WaterfallItems/rows(_:)`` passing the number of items you need to tell the view how many rows or column are needed.
  ///   - spacing: The spacing between items in the grid. If `nil`, the grid will use the default spacing.
  ///   - data: The data to display in the grid.
  ///   - id: A key path to the `ID` property of `Data.Element`.
  ///   - content: A view builder that creates the content of each item in the grid.
  public init(
    items: WaterfallItems,
    spacing: CGFloat? = nil,
    data: Data,
    id: KeyPath<Data.Element, ID>,
    @ViewBuilder content: @escaping (Data.Element) -> Content
  ) where ModifiedWaterfallItemView == WaterfallItemView<Content, Data, ID> {
    self.init(items: items, spacing: spacing, data: data, id: id, content: content) { $1 }
  }
  
  /// Creates a new grid view with the given items and data.
  /// - Parameters:
  ///   - items: The layout of the grid. You can use either ``WaterfallItems/columns(_:)`` or ``WaterfallItems/rows(_:)`` passing the number of items you need to tell the view how many rows or column are needed.
  ///   - spacing: The spacing between items in the grid. If `nil`, the grid will use the default spacing.
  ///   - data: The data to display in the grid.
  ///   - content: A view builder that creates the content of each item in the grid.
  ///   - waterfallItem: A view builder that you can use to customize each column or row in the grid.
  public init(
    items: WaterfallItems,
    spacing: CGFloat? = nil,
    data: Data,
    @ViewBuilder content: @escaping (Data.Element) -> Content,
    @ViewBuilder waterfallItem: @escaping (_ item: WaterfallItemViewInfo<Data>, _ itemView: WaterfallItemView<Content, Data, ID>) -> ModifiedWaterfallItemView
  ) where Data.Element: Identifiable, ID == Data.Element.ID {
    self.init(items: items, spacing: spacing, data: data, id: \.id, content: content, waterfallItem: waterfallItem)
  }
  
  /// Creates a new grid view with the given items and data.
  /// - Parameters:
  ///   - items: The layout of the grid. You can use either ``WaterfallItems/columns(_:)`` or ``WaterfallItems/rows(_:)`` passing the number of items you need to tell the view how many rows or column are needed.  ///   - spacing: The spacing between items in the grid. If `nil`, the grid will use the default spacing.
  ///   - spacing: The spacing between items in the grid. If `nil`, the grid will use the default spacing.
  ///   - data: The data to display in the grid.
  ///   - content: A view builder that creates the content of each item in the grid.
  public init(
    items: WaterfallItems,
    spacing: CGFloat? = nil,
    data: Data,
    @ViewBuilder content: @escaping (Data.Element) -> Content
  ) where Data.Element: Identifiable, ID == Data.Element.ID, ModifiedWaterfallItemView == WaterfallItemView<Content, Data, ID> {
    self.init(items: items, spacing: spacing, data: data, id: \.id, content: content) { $1 }
  }
    
  public var body: some View {
    switch items {
      case .columns(let columns):
      HStack(alignment: .top, spacing: spacing) {
        ForEach(columns.indexeds()) { column in
          let index = column.index
          let data = ArrayGridSlice(source: data, column: index, totalColumns: columns.count)
          waterfallItem(
            .init(
              gridItem: .column(columns[index]),
              index: index,
              itemsCount: columns.count,
              data: data
            ),
            .vertical(
              WaterfallColumnView(
                isLazy: true,
                namespace: waterfallNamespace ?? namespace,
                column: columns[index],
                data: data,
                id: id,
                content: content
              )
            )
          )
        }
      }
      case .rows(let rows):
      VStack(alignment: .leading, spacing: spacing) {
        ForEach(rows.indexeds()) { row in
          let index = row.index
          let data = ArrayGridSlice(source: data, column: index, totalColumns: rows.count)
          waterfallItem(
            .init(
              gridItem: .row(rows[index]),
              index: index,
              itemsCount: rows.count,
              data: data
            ),
            .horizontal(
              WaterfallRowView(
                isLazy: true,
                namespace: waterfallNamespace ?? namespace,
                row: rows[index],
                data: data,
                id: id,
                content: content
              )
            )
          )
        }
      }
    }
  }
}
