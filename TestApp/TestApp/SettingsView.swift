import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Binding var settings: Settings
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          VStack(alignment: .leading) {
            Text("Columns/Row spacing \(Int(settings.spacing))")
            Slider(
              value: $settings.spacing,
              in: 0 ... 32,
              label: {
                Text("Columns/Row spacing")
              },
              minimumValueLabel: {
                Text("0")
              },
              maximumValueLabel: {
                Text("32")
              }
            )
          }
          VStack(alignment: .leading) {
            Text("Items spacing \(Int(settings.itemsSpacing))")
            Slider(
              value: $settings.itemsSpacing,
              in: 0 ... 32,
              label: {
                Text("Items spacing")
              },
              minimumValueLabel: {
                Text("0")
              },
              maximumValueLabel: {
                Text("32")
              }
            )
          }
        } header: {
          Text("Grid")
        }
        Section {
          Picker(
            "Animation",
            selection: .init(
              get: { settings.selectedAnimation },
              set: { settings.selectedAnimation = $0 }
            )
          ) {
            Text("No animation")
              .tag(nil as Animation?)
            Text("Spring")
              .tag(Animation?.some(.spring))
            Text("Bouncy")
              .tag(Animation?.some(.bouncy))
            Text("Snappy")
              .tag(Animation?.some(.snappy))
          }
          if settings.selectedAnimation != nil {
            VStack(alignment: .leading) {
              Text("Animation speed ") + Text(settings.animationSpeed, format: .number.precision(.fractionLength(1)))
              Slider(
                value: $settings.animationSpeed,
                in: 0.1 ... 3.05,
                step: 0.1,
                label: {
                  Text("Animation speed")
                },
                minimumValueLabel: {
                  Text(0.1, format: .number.precision(.fractionLength(1)))
                },
                maximumValueLabel: {
                  Text(3.0, format: .number.precision(.fractionLength(1)))
                }
              )
            }
          }
        } header: {
          Text("Animations")
        }
      }
      #if !os(macOS)
      .navigationBarTitleDisplayMode(.inline)
      #endif
      .toolbar {
        ToolbarItem(placement: .navigation) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(.gray)
          }
        }
      }
      .navigationTitle("Settings")
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button("Reset") {
            withAnimation {
              settings = .init()
            }
          }
        }
      }
    }
    .presentationDetents([.fraction(0.7), .large])
  }
}

struct Settings {
  var spacing: CGFloat = 10
  var itemsSpacing: CGFloat = 10
  
  fileprivate var selectedAnimation: Animation? = .spring
  fileprivate var animationSpeed: Double = 1
  
  var animation: Animation? {
    selectedAnimation?.speed(animationSpeed)
  }
}
