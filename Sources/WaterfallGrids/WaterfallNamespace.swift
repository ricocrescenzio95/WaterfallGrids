import SwiftUI

extension EnvironmentValues {
  @Entry public internal(set) var waterfallNamespace: Namespace.ID?
}

extension View {
  /// Sets the waterfall namespace for the view.
  public func waterfallNamespace(_ id: Namespace.ID) -> some View {
    environment(\.waterfallNamespace, id)
  }
}
