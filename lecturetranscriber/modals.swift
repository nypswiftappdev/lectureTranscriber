//
//  modals.swift
//  lecturetranscriber
//
//  Created by Shadow33 on 15/1/26.
//
import SwiftUI
import Foundation
import SwiftData


@Model
final class Lecture: Identifiable {
    var id: UUID = UUID()
    var title: String
    var duration: String
    var summary: String
    var course: Course?
    
    @Relationship
    var tags: [Tag] = []
    
    init(title: String, duration: String, summary: String) {
        self.title = title
        self.duration = duration
        self.summary = summary
    }
}

@Model
final class Course: Identifiable {
    var id: UUID = UUID()
    var name: String
    var code: String
    var themeColorHex: String
    var icon: String
    
    @Relationship(deleteRule: .cascade)
    var lectures: [Lecture] = []

    init(name: String, code: String, themeColorHex: String, icon: String) {
        self.name = name
        self.code = code
        self.themeColorHex = themeColorHex
        self.icon = icon
    }
    
    // Computed property to convert hex string to Color
    var themeColor: Color {
        Color(hex: themeColorHex) ?? Color.gray
    }
}

@Model
final class Tag: Identifiable {
    var id: UUID = UUID()
    var name: String
    var colorHex: String
    
    @Relationship(inverse: \Lecture.tags)
    var lectures: [Lecture] = []
    
    init(name: String, colorHex: String) {
        self.name = name
        self.colorHex = colorHex
    }
    
    var color: Color {
        Color(hex: colorHex) ?? .gray
    }
}

// Helper extension to create Color from hex string
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
    
    // Convert Color to hex string for storage
    var toHex: String {
        guard let components = self.cgColor?.components, components.count >= 3 else {
            return "#808080"
        }
        let r = Int(components[0] * 255.0)
        let g = Int(components[1] * 255.0)
        let b = Int(components[2] * 255.0)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}