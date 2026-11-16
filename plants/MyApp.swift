import SwiftUI

@main
struct MyApp: App {

    @State private var store = ReminderStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
                .onAppear {
                    NotificationManager.requestPermission()
                }
        }
    }
}
