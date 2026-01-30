//
//  home.swift
//  lecturetranscriber
//
//  Created by Shadow33 on 15/1/26.
//

import SwiftUI
import SwiftData

struct ClassDashboard: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Course.name) private var courses: [Course]
    @State private var showingAddCourse = false
    @AppStorage("username") private var userName: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(currentDateString())
                                    .font(.caption.bold())
                                    .foregroundColor(.gray)
                                    .textCase(.uppercase)
                                
                                Text(userName.isEmpty ? "Hey!" : "Hey, \(userName)")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            Button(action: { showingAddCourse = true }) {
                                Image(systemName: "plus")
                                    .font(.title3.bold())
                                    .foregroundColor(.black)
                                    .frame(width: 44, height: 44)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(.top, 20)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            Text("Search lectures...")
                                .foregroundColor(.gray.opacity(0.6))
                            Spacer()
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        
                        HStack(spacing: 15) {
                            statCard(title: "Courses", count: "\(courses.count)", icon: "book.closed.fill", color: .blue)
                            statCard(title: "Transcripts", count: "\(courses.reduce(0) { $0 + $1.lectures.count })", icon: "mic.fill", color: .orange)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Active Classes")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            if courses.isEmpty {
                                emptyState
                            } else {
                                VStack(spacing: 20) {
                                    ForEach(courses) { course in
                                        NavigationLink(destination: ClassDetailView(course: course)) {
                                            CourseCard(course: course)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        
                        Color.clear.frame(height: 50)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .accentColor(.white)
        .sheet(isPresented: $showingAddCourse) {
            AddCourseView()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.1))
            Text("No classes added yet.\nTap the + button to get started.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func statCard(title: String, count: String, icon: String, color: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(count)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.05), lineWidth: 1))
    }
    
    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

#Preview {
    ClassDashboard()
}
