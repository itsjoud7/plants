 //
//  SetReminderView.swift
//  plants
//
//  Created by jood on 30/05/1448 AH.
//

import SwiftUI

struct SetReminderView: View {

    var reminderToEdit: PlantReminder? = nil
    @Environment(ReminderStore.self) private var store
    // @Environment = any page that needs the plants takes the plant storage (ReminderStore) with this line
    
    @Environment(\.dismiss) private var dismiss
    // A ready-made Apple tool that closes this page (used by ✕ and after saving)
    
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    // Saved on the phone
    
    @State private var name = ""
    @State private var room: Room = .bedroom
    @State private var light: Light = .fullSun
    @State private var watering: WateringFrequency = .everyDay
    @State private var water: WaterAmount = .small
    
    // عشان اسأل المستخدم "متأكد؟" قبل ما نحذف، وما تنحذف النبتة بالغلط
    var body: some View {
        // عشان الشريط العلوي (العنوان و ✕ و ✓)
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Plant Name")
                        TextField("Pothos", text: $name)
                            .tint(Color.plantGreen)
                    }
                }

                Section {
                    Picker(selection: $room) {
                        ForEach(Room.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                        // ForEach = repeats
                        //.allCases = all () from the enum (plantreminderview)
                        // option = the current () in each loop (Bedroom, Living Room, Kitchen...)

                    } label: {
                        HStack {
                            Image(systemName: "location")
                            Text("Room")
                        }
                    }

                    Picker(selection: $light) {
                        ForEach(Light.allCases) { option in
                            Label(option.rawValue, systemImage: option.icon).tag(option)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "sun.max")
                            Text("Light")
                        }
                    }
                }

                Section {
                    Picker(selection: $watering) {
                        ForEach(WateringFrequency.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "drop")
                            Text("Watering Days")
                        }
                    }

                    Picker(selection: $water) {
                        ForEach(WaterAmount.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "drop")
                            Text("Water")
                        }
                    }
                }

                Section {
                    Button(role: .destructive) {
                        if let reminder = reminderToEdit {
                            store.delete(reminder)
                        }
                        dismiss()
                    } label: {
                        Text("Delete Reminder")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                    }
                }                // Delete button: always shows at the bottom of the form
            }
            .pickerStyle(.menu)
            .tint(.secondary)
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
              // small title in the middle, on the same line as ✕ and ✓ (like the design)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                } //toolbar : buttons in the top bar (✕ and ✓ like the design)

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save()
                        // when tapped, run the save function
                    } label: {
                        Image(systemName: "checkmark")
                        // the ✓ icon (without Button it's just a picture, not tappable)
                    }
                    .tint(Color.plantGreen)
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let reminder = reminderToEdit {
                    name = reminder.name
                    room = reminder.room
                    light = reminder.light
                    watering = reminder.watering
                    water = reminder.water
                }
            }
        }
    }

    // func = a function: a group of steps with one name
    // Why: instead of writing all the saving steps inside the ✓ button (long and messy),
    // I put them here and call save() in one line. It keeps the code clean,
    // easy to understand from the name, and I can reuse it without repeating the steps
    private func save() {  // a function named save, private = only this page can use it
        if var reminder = reminderToEdit {
            reminder.name = name
            reminder.room = room
            reminder.light = light
            reminder.watering = watering
            reminder.water = water
            store.update(reminder)
          //  the shared plant storage (ReminderStore); update saves the edited plant there
        } else {
            let reminder = PlantReminder(
                name: name,
                room: room,
                light: light,
                watering: watering,
                water: water
            )
            store.add(reminder)   // calls the add function in the store to save a new item there
        }
        hasOnboarded = true
        // marks onboarding as finished (saved on the phone) so it never shows again
        dismiss()
    }
}

#Preview("New") {
    SetReminderView()
        .environment(ReminderStore())
}

#Preview("Edit") {
    SetReminderView(reminderToEdit: PlantReminder(name: "Pothos"))
        .environment(ReminderStore())
}
