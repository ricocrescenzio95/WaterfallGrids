import WaterfallGrids
import SwiftUI

struct Item: Identifiable, Comparable {
  static func < (lhs: Item, rhs: Item) -> Bool {
    lhs.id < rhs.id
  }
  
  var id: Int
  var color: Color
  var size: Double
  
  static func from(start: Int, count: Int = 30, reverse: Bool = false) -> [Item] {
    let items: [Item] = (start..<start + count).map {
      .init(
        id: reverse ? -$0 : $0,
        color: [
          Color.red, .yellow, .pink, .blue, .green, .orange, .purple, .gray,
        ].randomElement()!,
        size: .random(in: 100...300)
      )
    }
    return reverse ? items.reversed() : items
  }
}

struct RectView: View {
  var item: Item
  var isVertical: Bool
  var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(item.color)
      .frame(
        width: !isVertical ? item.size : nil,
        height: isVertical ? item.size : nil
      )
      .overlay(Text(item.id.description))
  }
}

struct ColumnsRowsSelector: View {
  @Binding var axis: WaterfallItems
  @Binding var items: [Item]
  var settings: Settings
  
  var body: some View {
    HStack {
      Text(axis.isVertical ? "Columns" : "Rows")
      Picker(
        axis.isVertical ? "Columns" : "Rows",
        selection: .init(
          get: { axis.itemsCount },
          set: { newValue in
            withAnimation(settings.animation) {
              axis = axis.isVertical ?
                .columns((0..<Int(newValue)).map { _ in .init(spacing: settings.spacing) }) :
                .rows((0..<Int(newValue)).map { _ in .init(spacing: settings.spacing) })
            }
          }
        )
      ) {
        ForEach(1..<11) { index in
          Text(index.description)
            .tag(index)
        }
      }
      .pickerStyle(.segmented)
    }
  }
}

extension View {
  func defaultToolbarContent(
    axis: Binding<WaterfallItems>?,
    items: Binding<[Item]>?,
    settings: Settings
  ) -> some View {
    toolbar {
      if let axis {
        ToolbarItem(placement: .navigation) {
          Button {
            withAnimation(settings.animation) {
              if axis.wrappedValue.isHorizontal {
                axis.wrappedValue = .columns((0..<axis.wrappedValue.itemsCount).map { _ in .init() })
              } else {
                axis.wrappedValue = .rows((0..<axis.wrappedValue.itemsCount).map { _ in .init() })
              }
            }
          } label: {
            Image(systemName: axis.wrappedValue.isHorizontal ? "align.horizontal.left" : "align.vertical.top")
          }
        }
      }
      if let items {
        ToolbarItem(placement: .primaryAction) {
          Button {
            withAnimation(settings.animation) {
              items.wrappedValue = Item.from(start: 0)
            }
          } label: {
            Image(systemName: "arrow.clockwise.circle")
          }
        }
        ToolbarItem(placement: .primaryAction) {
          Button {
            withAnimation(settings.animation) {
              items.wrappedValue.shuffle()
            }
          } label: {
            Image(systemName: "shuffle.circle")
          }
        }
      }
    }
  }
}
