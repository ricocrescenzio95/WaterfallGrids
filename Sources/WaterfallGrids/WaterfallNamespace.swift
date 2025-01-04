import SwiftUI

extension EnvironmentValues {
  @Entry public internal(set) var waterfallNamespace: Namespace.ID?
}

extension View {
  /// Sets the waterfall namespace for the view.
  ///
  /// When you have multiple ``WaterfallGrid`` or ``LazyWaterfallGrid`` views in the same view hierarchy, you can use this modifier to set the waterfall namespace for the view;
  /// this ensures that when items are moved or removed from one grid to another, the system can match the item views correctly and apply a correct animation.
  ///
  /// ```swift
  /// @Namespace private var namespace
  ///
  /// var body: some View {
  ///   ScrollView {
  ///     LazyWaterfallGrid(items: .columns([.init(), .init()]), data: data) { item in
  ///       MyView(item: item)
  ///     }
  ///     Divider()
  ///     LazyWaterfallGrid(items: .columns([.init(), .init(), .init()]), data: data2) { item in
  ///       MyView(item: item)
  ///     }
  ///   }
  ///   .waterfallNamespace(namespace)
  /// }
  /// ```
  public func waterfallNamespace(_ id: Namespace.ID) -> some View {
    environment(\.waterfallNamespace, id)
  }
}
