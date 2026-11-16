//
//  PlantReminder.swift
//  plants
//
//  Created by jood on 30/05/1448 AH.
//

import Foundation

enum Room: String, CaseIterable, Codable, Identifiable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"

    var id: String { rawValue }
}

enum Light: String, CaseIterable, Codable, Identifiable {
    case fullSun = "Full sun"
    case partialSun = "Partial sun"
    case lowLight = "Low light"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .fullSun:    return "sun.max"
        case .partialSun: return "sun.horizon"
        case .lowLight:   return "moon"
        }
    }
}

enum WateringFrequency: String, CaseIterable, Codable, Identifiable {
    case everyDay = "Every day"
    case everyTwoDays = "Every 2 days"
    case everyThreeDays = "Every 3 days"
    case onceAWeek = "Once a week"
    case everyTenDays = "Every 10 days"
    case everyTwoWeeks = "Every 2 weeks"

    var id: String { rawValue }

    var days: Int {
        switch self {
        case .everyDay:       return 1
        case .everyTwoDays:   return 2
        case .everyThreeDays: return 3
        case .onceAWeek:      return 7
        case .everyTenDays:   return 10
        case .everyTwoWeeks:  return 14
        }
    }
}

enum WaterAmount: String, CaseIterable, Codable, Identifiable {
    case small = "20-50 ml"
    case medium = "50-100 ml"
    case large = "100-200 ml"
    case extraLarge = "200-300 ml"

    var id: String { rawValue }
}

struct PlantReminder: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var room: Room = .bedroom
    var light: Light = .fullSun
    var watering: WateringFrequency = .everyDay
    var water: WaterAmount = .small
    var isDone = false
}
