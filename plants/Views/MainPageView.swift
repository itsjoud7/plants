//
//  MainPageView.swift
//  plants
//
//  Created by jood on 30/05/1448 AH.
//

import SwiftUI

extension Color {
    static let mintGreen = Color(red: 0.36, green: 0.84, blue: 0.62)
}

struct MainPageView: View {

    @Environment(ReminderStore.self) private var store
    @State private var showAddSheet = false
    @State private var reminderToEdit: PlantReminder? = nil
    @State private var reminderToDelete: PlantReminder? = nil
    @State private var showDeleteAlert = false

    var headerText: String {
        if store.completedCount == 0 {
            // == asks "is it equal?" (a question) | = puts a value (like name = "Monstera")
            return "Your plants are waiting for a sip 💦"
        } else {
            return "\(store.completedCount) of your plants feel loved today✨"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Text("My Plants 🌱")
                .font(.system(size: 34, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.top, 45)
                .padding(.bottom, 12)

            Divider()
                .padding(.leading, 20)

            if store.reminders.isEmpty {
                emptyView
            } else if store.allDone {
                allDoneView
            } else {
                reminderList
            }
        }
        // Shows one of 3 screens: no plants → empty message, all watered → All Done, otherwise → the plant list
        
        
        .overlay(alignment: .bottomTrailing) {
            Button {
                showAddSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .glassEffect(.regular.tint(.plantGreen.opacity(0.6)).interactive(), in: .circle)
                    // glassEffect = green glass circle button
            }
            .padding(24)
        }
        // The green + button: floats on top of the page in the bottom-right corner and opens the add plant sheet + it also shows the sheet
        
        .sheet(isPresented: $showAddSheet) {
            SetReminderView()
        }
        .sheet(item: $reminderToEdit) { reminder in
            SetReminderView(reminderToEdit: reminder)
        }
        
        // Opens the edit page with the tapped plant, named "reminder" so we can send it to the page
        
        .alert("Delete Plant?", isPresented: $showDeleteAlert, presenting: reminderToDelete) { reminder in
            Button("Delete", role: .destructive) {
                withAnimation {
                    store.delete(reminder)
                }
            }
            // destructive = a dangerous action that can't be undone, so iOS shows it in red

            Button("Cancel", role: .cancel) { }
        } message: { reminder in
            Text("Are you sure you want to delete \(reminder.name)?")
        }
        // confirmationDialog = delete options show from the bottom
    }

    var emptyView: some View {
        VStack {
            Spacer()
            Text("No reminders set yet...")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    var allDoneView: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                Image("plant2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 220)
            }
            .padding(.bottom, 60)

            Text("All Done! 🎉")
                .font(.system(size: 25, weight: .bold))
                .padding(.bottom, 16)

            Text("All Reminders Completed")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .padding(.bottom, 16)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    var reminderList: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text(headerText)
                    .font(.system(size: 17))

                ProgressView(value: store.progress)
                    .tint(Color.mintGreen)
                    .scaleEffect(x: 1, y: 2)
                    .animation(.easeInOut, value: store.progress)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 28)

            List {                                          // a scrollable list
                ForEach(store.reminders) { reminder in      // one row for every plant
                    ReminderRow(reminder: reminder)         // the row design for this plant
                        .contentShape(Rectangle())          // makes the whole row tappable
                        .onTapGesture {                     // tap a row → open the edit page
                            reminderToEdit = reminder
                        }
                        .swipeActions(allowsFullSwipe: false) {   // swipe left → show a delete button (no instant delete)
                            Button {
                                reminderToDelete = reminder       // remember which plant
                                showDeleteAlert = true            // ask "Are you sure?"
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                }
            }
            .listStyle(.plain)                              // simple list style, no grey boxes
        }
    }
}

struct ReminderRow: View {
    // Instead of writing the row design for every plant,i write it once as ReminderRow,
    // and ForEach repeats it for each plant in the list
    @Environment(ReminderStore.self) private var store
    
    @Environment(\.colorScheme) private var colorScheme
    // takes the phone's mode (light or dark) that Apple provides, to pick the tag colors
    let reminder: PlantReminder

    var lightTagColor: Color {
        colorScheme == .dark
            ? Color(red: 0.80, green: 0.79, blue: 0.62)
            : Color(red: 0.55, green: 0.47, blue: 0.15)
    }

    var waterTagColor: Color {
        colorScheme == .dark
            ? Color(red: 0.79, green: 0.87, blue: 0.95)
            : Color(red: 0.18, green: 0.42, blue: 0.68)
    }

    var body: some View {
        HStack(spacing: 16) {

            Button {
                withAnimation {
                    store.toggleDone(reminder)
                }
            } label: {
                Image(systemName: reminder.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 26))
                    .foregroundStyle(reminder.isDone ? Color.mintGreen : Color.secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 6) {

                Label("in \(reminder.room.rawValue)", systemImage: "location")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)

                Text(reminder.name)
                    .font(.system(size: 28))
                    .foregroundStyle(reminder.isDone ? Color.secondary : Color.primary)

                HStack(spacing: 8) {
                    TagView(icon: reminder.light.icon,
                            text: reminder.light.rawValue,
                            color: lightTagColor)

                    TagView(icon: "drop",
                            text: reminder.water.rawValue,
                            color: waterTagColor)
                }
            }
        }
        .padding(.vertical, 10)
    }
}

struct TagView: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        Label(text, systemImage: icon)
            .font(.system(size: 14))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))
    }
}
// Previews (Xcode only): a test store with test plants to see each state of the main page
#Preview("Plants") {
    let store = ReminderStore()
    store.reminders = [
        PlantReminder(name: "Monstera", room: .kitchen),
        PlantReminder(name: "Pothos", room: .bedroom, isDone: true),
        PlantReminder(name: "Orchid", room: .livingRoom),
        PlantReminder(name: "Spider", room: .kitchen)
    ]
    return MainPageView()
        .environment(store)
}

#Preview("All Done") {
    let store = ReminderStore()
    store.reminders = [
        PlantReminder(name: "Monstera", isDone: true),
        PlantReminder(name: "Pothos", isDone: true)
    ]
    return MainPageView()
        .environment(store)
}

#Preview("Empty") {
    MainPageView()
        .environment(ReminderStore())
}
