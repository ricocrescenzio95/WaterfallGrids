import SwiftUI
import WaterfallGrids
import Kingfisher

struct AsyncImage: Identifiable {
  var url: URL
  var size: CGSize
  
  var id: URL { url }
}

struct AsyncImagesView: View {
  @State private var gridItems: WaterfallItems = .columns(.init(repeating: .init(), count: 4))
  @State private var items: [AsyncImage] = (0...100).map {
    let size = CGSize(width: 400, height: Int.random(in: 200...600))
    return .init(
      url: URL(string: "https://picsum.photos/seed/\($0)/\(Int(size.width))/\(Int(size.height))")!,
      size: size
    )
  }
  
  var settings: Settings
  
  var body: some View {
    ScrollView(gridItems.isVertical ? .vertical : .horizontal) {
      LazyWaterfallGrid(
        items: gridItems,
        spacing: settings.spacing,
        data: items
      ) { asyncImage in
        KFImage.url(asyncImage.url)
          .resizable()
          .fade(duration: 0.5)
          .placeholder {
            Rectangle()
              .fill(.placeholder)
          }
          .contentConfigure { image in
            image
              .resizable()
              .aspectRatio(
                gridItems.isVertical ?
                asyncImage.size.width / asyncImage.size.height :
                  asyncImage.size.height / asyncImage.size.width,
                contentMode: .fill
              )
          }
          .clipped()
      }
    }
    .defaultToolbarContent(axis: $gridItems, items: nil, settings: settings)
    .onChange(of: settings.itemsSpacing, initial: true) { _, spacing in
      gridItems.setAllSpacings(spacing)
    }
  }
}

#Preview {
  NavigationStack {
    AsyncImagesView(settings: .init())
  }
}
