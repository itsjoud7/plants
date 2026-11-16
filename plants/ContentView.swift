import SwiftUI

struct ContentView: View {

    @Environment(ReminderStore.self) private var store
    @AppStorage("hasOnboarded") private var hasOnboarded = false

    var body: some View {
        if store.reminders.isEmpty && !hasOnboarded {
            Onboarding_1_View()
        } else {
            MainPageView()
        }
    }
}

#Preview {
    UserDefaults.standard.set(false, forKey: "hasOnboarded")
    return ContentView()
        .environment(ReminderStore())
}
