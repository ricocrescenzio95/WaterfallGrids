import SwiftUI

@main
struct TestApp: App {
  var body: some Scene {
    WindowGroup {
      MainView()
    }
  }
}

struct MainView: View {
  @State private var isSettingsPresented = false
  @State private var settings = Settings()
  
  var body: some View {
    TabView {
      NavigationStack {
        SimpleView(settings: settings)
          .settingsToolbar(isSettingsPresented: $isSettingsPresented, settings: $settings)
      }
      .tabItem {
        Label("Simple", systemImage: "rectangle.3.offgrid.fill")
      }
      
      NavigationStack {
        InfinteScrollView(settings: settings)
          .settingsToolbar(isSettingsPresented: $isSettingsPresented, settings: $settings)
      }
      .tabItem {
        Label("Lazy Infinite scroll", systemImage: "scroll.fill")
      }
      
      NavigationStack {
        AsyncImagesView(settings: settings)
          .settingsToolbar(isSettingsPresented: $isSettingsPresented, settings: $settings)
      }
      .tabItem {
        Label("Lazy Async Images", systemImage: "photo.fill.on.rectangle.fill")
      }
      
      NavigationStack {
        AdvancedCustomizationView(settings: settings)
          .settingsToolbar(isSettingsPresented: $isSettingsPresented, settings: $settings)
      }
      .tabItem {
        Label("Advanced UI", systemImage: "paintpalette.fill")
      }
      
      NavigationStack {
        iOS18APIView(settings: settings)
          .settingsToolbar(isSettingsPresented: $isSettingsPresented, settings: $settings)
      }
      .tabItem {
        Label("iOS 18", systemImage: "wand.and.stars")
      }
    }
    .sheet(isPresented: $isSettingsPresented) {
      SettingsView(settings: $settings)
    }
  }
}

extension View {
  func settingsToolbar(
    isSettingsPresented: Binding<Bool>,
    settings: Binding<Settings>
  ) -> some View {
    toolbar {
      ToolbarItem(placement: .navigation) {
        Button {
          isSettingsPresented.wrappedValue = true
        } label: {
          Image(systemName: "gear")
        }
      }
    }
  }
}

#Preview {
  ZStack {
    HStack(spacing: 24) {
      VStack(spacing: 24) {
        RoundedRectangle(cornerRadius: 8)
          .fill(.mint)
          .frame(height: 110)
        RoundedRectangle(cornerRadius: 8)
          .fill(.mint)
      }
      VStack(spacing: 24) {
        RoundedRectangle(cornerRadius: 8)
          .fill(.mint)
        RoundedRectangle(cornerRadius: 8)
          .fill(.mint)
          .frame(height: 80)
      }
    }
    
  }
  .aspectRatio(1, contentMode: .fit)
  .frame(width: 1024 / 3)
  .background(.mint.tertiary)
}

#Preview {
  let rect = RoundedRectangle(cornerRadius: 180 / 3)
    .fill(.mint.quinary)
    .aspectRatio(1, contentMode: .fit)
    .frame(width: 1024 / 3)
    .rotationEffect(.degrees(45))
    .scaleEffect(x: 0.9)
    .scaleEffect(y: 0.5)
    .rotation3DEffect(.degrees(45 / 2), axis: (x: 1, y: 0, z: 0))
  ZStack {
    rect
    rect.offset(y: 40)
    rect.offset(y: 80)
    ZStack {
      HStack {
        VStack {
          RoundedRectangle(cornerRadius: 8)
            .fill(.mint)
            .frame(height: 110)
          RoundedRectangle(cornerRadius: 8)
            .fill(.mint)
        }
        VStack {
          RoundedRectangle(cornerRadius: 8)
            .fill(.mint)
          RoundedRectangle(cornerRadius: 8)
            .fill(.mint)
            .frame(height: 80)
        }
      }
      .padding(42)
    }
    .aspectRatio(1, contentMode: .fit)
    .frame(width: 1024 / 3)
    .geometryGroup()
    .shadow(color: .mint.opacity(0.5), radius: 10, x: 10, y: 10)
    .rotationEffect(.degrees(45))
    .scaleEffect(x: 0.9)
    .scaleEffect(y: 0.5)
    .rotation3DEffect(.degrees(45 / 2), axis: (x: 1, y: 0, z: 0))
  }
}
