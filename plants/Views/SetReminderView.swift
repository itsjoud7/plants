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
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasOnboarded") private var hasOnboarded = false

    @State private var name = ""
    @State private var room: Room = .bedroom
    @State private var light: Light = .fullSun
    @State private var watering: WateringFrequency = .everyDay
    @State private var water: WaterAmount = .small
    
    @State private var showDeleteAlert = false
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

                if reminderToEdit != nil {
                    Section {
                        Button(role: .destructive) {
                            showDeleteAlert = true
                        }                     }
                }
            }
            .pickerStyle(.menu)
            .tint(.secondary)
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save()
                    } label: {
                        Image(systemName: "checkmark")
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

    private func save() {
        if var reminder = reminderToEdit {
            reminder.name = name
            reminder.room = room
            reminder.light = light
            reminder.watering = watering
            reminder.water = water
            store.update(reminder)
        } else {
            let reminder = PlantReminder(
                name: name,
                room: room,
                light: light,
                watering: watering,
                water: water
            )
            store.add(reminder)
        }
        hasOnboarded = true
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

