//
//  modals.swift
//  lecturetranscriber
//
//  Created by Shadow33 on 15/1/26.
//
import SwiftUI
import Foundation

struct Lecture: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let duration: String
    let summary: String
}

struct Course: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let schedule: String
    let themeColor: Color
    let icon: String
    let lectures: [Lecture]
}

