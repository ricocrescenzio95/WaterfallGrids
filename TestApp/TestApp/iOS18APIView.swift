import SwiftUI
import WaterfallGrids

struct iOS18APIView: View {
  @State private var gridItems: WaterfallItems = .columns(.init(repeating: .init(), count: 4))
  @State private var items = Item.from(start: 0, count: 100)
  @State private var frames = [Item.ID: CGRect]()
  @State private var isScrollToPresented = false
  @State private var scrollPosition = ScrollPosition()
  @State private var scrollToID: Item.ID = 0
  var settings: Settings
  
  @Namespace private var namespace
  
  var body: some View {
    ScrollView(gridItems.isVertical ? .vertical : .horizontal) {
      LazyWaterfallGrid(
        items: gridItems,
        spacing: settings.spacing,
        data: items
      ) { item in
        RectView(item: item, isVertical: gridItems.isVertical)
      }
      .padding()
    }
    .scrollPosition($scrollPosition)
    .safeAreaInset(edge: .bottom, spacing: 0) {
      VStack(alignment: .leading) {
        Button("Scroll to") {
          isScrollToPresented = true
        }
        .popover(isPresented: $isScrollToPresented) {
          VStack {
            Picker("Scroll to", selection: $scrollToID) {
              ForEach(items) { item in
                Text(item.id.description)
                  .tag(item.id)
              }
            }
#if !os(macOS)
            .pickerStyle(.wheel)
#endif
            Button("Perform") {
              isScrollToPresented = false
              withAnimation(settings.animation) {
                scrollPosition = .init(id: scrollToID)
              }
            }
            .buttonStyle(.bordered)
          }
          .padding()
          .presentationCompactAdaptation(.popover)
        }
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
