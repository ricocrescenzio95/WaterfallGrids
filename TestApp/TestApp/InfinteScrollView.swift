import SwiftUI
import WaterfallGrids

struct InfinteScrollView: View {
  @State private var gridItems: WaterfallItems = .columns(.init(repeating: .init(), count: 4))
  @State private var reversedItems = Item.from(start: 1, reverse: true)
  @State private var items = Item.from(start: 0)
  @State private var isLoadingMore = false
  var settings: Settings
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView {
        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
          Section {
            LazyWaterfallGrid(
              items: gridItems,
              spacing: settings.spacing,
              data: reversedItems
            ) { item in
              RectView(item: item, isVertical: gridItems.isVertical)
            }
            .padding()
          } header: {
            Text("Section with negative numbers")
              .frame(maxWidth: .infinity)
              .padding()
              .background(.bar)
          }
          Section {
            LazyWaterfallGrid(
              items: gridItems,
              spacing: settings.spacing,
              data: items
            ) { item in
              RectView(item: item, isVertical: gridItems.isVertical)
                .transition(.opacity.animation(settings.animation))
                .onAppear {
                  if item.id == items.last?.id {
                    loadMore()
                  }
                }
            }
            .padding()
          } header: {
            Text("Section with positive numbers")
              .frame(maxWidth: .infinity)
              .padding(.vertical)
              .background(.bar)
          }
          if isLoadingMore {
            ProgressView()
              .padding()
          }
        }
      }
      .safeAreaInset(edge: .bottom, spacing: 0) {
        VStack(alignment: .leading) {
          ColumnsRowsSelector(axis: $gridItems, items: $items, settings: settings)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.bar)
      }
    }
    .defaultToolbarContent(axis: nil, items: $items, settings: settings)
    .onChange(of: settings.itemsSpacing, initial: true) { _, spacing in
      gridItems.setAllSpacings(spacing)
    }
  }
  
  private func loadMore() {
    guard !isLoadingMore else { return }
    Task {
      isLoadingMore = true
      try await Task.sleep(for: .seconds(3))
      isLoadingMore = false
      items.append(contentsOf: Item.from(start: items.max()!.id + 1))
    }
  }
}

#Preview {
  NavigationStack {
    InfinteScrollView(settings: .init())
  }
}
