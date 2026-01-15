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
final class Lecture{
    var id: UUID = UUID()
    var title: String
    var date: String
    var duration: String
    var summary: String
    var course: Course?
    
    init(title: String, date: String, duration: String, summary: String) {
        self.title = title
        self.date = date
        self.duration = duration
        self.summary = summary
    }
}

@Model
final class Course {
    var name: String
    var code: String
    var schedule: String
    var themeColorHex: String
    var icon: String
    
    @Relationship(deleteRule: .cascade)
    var lectures: [Lecture] = []

    init(name: String, code: String, schedule: String, themeColorHex: String, icon: String) {
        self.name = name
        self.code = code
        self.schedule = schedule
        self.themeColorHex = themeColorHex
        self.icon = icon
    }
}
