//
//  ReminderStore.swift
//  plants
//
//  Created by jood on 30/05/1448 AH.
//

import Foundation
import Observation

@Observable
class ReminderStore {

    var reminders: [PlantReminder] = [] {
        didSet { save() }
    }

    private let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

    init(startFresh: Bool = false) {
        if startFresh {
            UserDefaults.standard.removeObject(forKey: "plantReminders")
            UserDefaults.standard.removeObject(forKey: "hasOnboarded")
        }
        load()
    }

    func add(_ reminder: PlantReminder) {
        reminders.append(reminder)
        NotificationManager.schedule(for: reminder)
    }

    func update(_ reminder: PlantReminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
            NotificationManager.schedule(for: reminder)
        }
    }

    func delete(_ reminder: PlantReminder) {
        reminders.removeAll { $0.id == reminder.id }
        NotificationManager.cancel(for: reminder)
    }

    func toggleDone(_ reminder: PlantReminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isDone.toggle()
        }
    }

    var completedCount: Int {
        reminders.filter { $0.isDone }.count
    }

    var progress: Double {
        if reminders.isEmpty { return 0 }
        return Double(completedCount) / Double(reminders.count)
    }

    var allDone: Bool {
        !reminders.isEmpty && completedCount == reminders.count
    }

    private let saveKey = "plantReminders"

    private func save() {
        if isPreview { return }
        if let data = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        if isPreview { return }
        guard
            let data = UserDefaults.standard.data(forKey: saveKey),
            let saved = try? JSONDecoder().decode([PlantReminder].self, from: data)
        else { return }
        reminders = saved
    }
}
