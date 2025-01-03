import SwiftUI
import WaterfallGrids

struct AdvancedCustomizationView: View {
  @Namespace private var namespace
  
  @State private var gridItems: WaterfallItems = .columns(.init(repeating: .init(), count: 4))
  @State private var allItems = Item.from(start: 0)
  @State private var isTransitionEffectEnabled = true
  @State private var isScrollToPresented = false
  @State private var scrollToID: Item.ID = 0
  
  var settings: Settings
  
  var items1: [Item].SubSequence {
    allItems.prefix(10)
  }
  var items2: [Item].SubSequence {
    allItems.dropFirst(10).prefix(10)
  }
  var items3: [Item].SubSequence {
    allItems.dropFirst(20)
  }
  
  var body: some View {
    ScrollViewReader { proxy in
      ScrollView(gridItems.isVertical ? .vertical : .horizontal) {
        let layout = gridItems.isVertical ? AnyLayout(VStackLayout(spacing: 0)) : AnyLayout(HStackLayout(spacing: 0))
        layout {
          WaterfallGrid(
            items: gridItems,
            spacing: settings.spacing,
            data: items1
          ) { item in
            Group {
              if let index = items1.firstIndex(of: item), index % 4 == 0 {
                RoundedRectangle(cornerRadius: 8)
                  .fill(item.color)
                  .containerRelativeFrame(.vertical, count: 2, spacing: 0)
              } else {
                RoundedRectangle(cornerRadius: 8)
                  .fill(item.color)
                  .frame(
                    width: !gridItems.isVertical ? item.size : nil,
                    height: gridItems.isVertical ? item.size : nil
                  )
              }
            }
            .overlay(Text(item.id.description))
            .scrollTransition { [isTransitionEffectEnabled] effect, phase in
              switch (phase, isTransitionEffectEnabled) {
              case (_, false), (.identity, _): effect.scaleEffect(1).opacity(1)
              case (.topLeading, _): effect.scaleEffect(0.8).opacity(0.8)
              case (.bottomTrailing, _): effect.scaleEffect(0.6).opacity(0.6)
              }
            }
              
          } waterfallItem: { item, itemView in
            itemView
              .scrollTargetLayout(isEnabled: item.index == 0)
          }
          .padding([.top, .horizontal])
          WaterfallGrid(
            items: gridItems.isVertical ? .columns(.init(repeating: .init(), count: 2)) : .rows(.init(repeating: .init(), count: 2)),
            spacing: settings.spacing,
            data: items2
          ) { item in
            RectView(item: item, isVertical: gridItems.isVertical)
              .scrollTransition { [isTransitionEffectEnabled] effect, phase in
                switch (phase, isTransitionEffectEnabled) {
                case (_, false), (.identity, _): effect.scaleEffect(1).opacity(1)
                case (.topLeading, _): effect.scaleEffect(0.8).opacity(0.8)
                case (.bottomTrailing, _): effect.scaleEffect(0.6).opacity(0.6)
                }
              }
          } waterfallItem: { item, itemView in
            itemView
              .scrollTargetLayout(isEnabled: item.index == 0)
          }
          .padding()
          WaterfallGrid(
            items: gridItems,
            spacing: settings.spacing,
            data: items3
          ) { item in
            RectView(item: item, isVertical: gridItems.isVertical)
              .padding(16)
              .scrollTransition { [isTransitionEffectEnabled] effect, phase in
                switch (phase, isTransitionEffectEnabled) {
                case (_, false), (.identity, _): effect.scaleEffect(1).opacity(1)
                case (.topLeading, _): effect.scaleEffect(0.8).opacity(0.8)
                case (.bottomTrailing, _): effect.scaleEffect(0.6).opacity(0.6)
                }
              }
          } waterfallItem: { item, itemView in
            itemView
              .scrollTargetLayout(isEnabled: item.index == 0)
              .background {
                RoundedRectangle(cornerRadius: 8)
                  .foregroundStyle(
                    item.index.isMultiple(of: 2) ?
                    AnyShapeStyle(.background.secondary.shadow(.drop(color: .black.opacity(0.2), radius: 4))) :
                      AnyShapeStyle(.background.shadow(.drop(color: .black.opacity(0.2), radius: 4)))
                  )
              }
          }
          .padding([.bottom, .horizontal])
        }
      }
      .waterfallNamespace(namespace)
      .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
      .safeAreaInset(edge: .bottom, spacing: 0) {
        VStack(alignment: .leading) {
          Button("Scroll to") {
            isScrollToPresented = true
          }
          .popover(isPresented: $isScrollToPresented) {
            VStack {
              Picker("Scroll to", selection: $scrollToID) {
                ForEach(allItems) { item in
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
                  proxy.scrollTo(scrollToID)
                }
              }
              .buttonStyle(.bordered)
            }
            .padding()
            .presentationCompactAdaptation(.popover)
          }
          Toggle("Enable transition effect", isOn: $isTransitionEffectEnabled)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.bar)
      }
    }
    .defaultToolbarContent(axis: $gridItems, items: $allItems, settings: settings)
    .onChange(of: settings.itemsSpacing, initial: true) { _, spacing in
      gridItems.setAllSpacings(spacing)
    }
  }
}

#Preview {
  NavigationStack {
    AdvancedCustomizationView(settings: .init())
  }
}
