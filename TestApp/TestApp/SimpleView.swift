import SwiftUI
import WaterfallGrids

struct SimpleView: View {
  @State private var gridItems: WaterfallItems = .columns(.init(repeating: .init(), count: 4))
  @State private var items = Item.from(start: 0)
  @State private var frames = [Item.ID: CGRect]()
  var settings: Settings
  
  @Namespace private var namespace
  
  var body: some View {
    ScrollView(gridItems.isVertical ? .vertical : .horizontal) {
      WaterfallGrid(
        items: gridItems,
        spacing: settings.spacing,
        data: items
      ) { item in
        RectView(item: item, isVertical: gridItems.isVertical)
      }
      .padding()
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      VStack(alignment: .leading) {
        ColumnsRowsSelector(axis: $gridItems, items: $items, settings: settings)
      }
      .frame(maxWidth: .infinity)
      .padding()
      .background(.bar)
    }
    .defaultToolbarContent(axis: $gridItems, items: $items, settings: settings)
    .onChange(of: settings.itemsSpacing, initial: true) { _, spacing in
      gridItems.setAllSpacings(spacing)
    }
  }
}

#Preview {
  NavigationStack {
    SimpleView(settings: .init())
  }
}
