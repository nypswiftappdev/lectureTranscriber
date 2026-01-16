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
    @Query private var courses: [Course]
    @State private var showingAddCourse = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(currentDateString())
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .textCase(.uppercase)
                                
                                Text("Your Classes")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Button(action: { showingAddCourse = true }) {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .frame(width: 50, height: 50)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.top, 20)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search for a lecture...")
                        }
                        .padding()
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.2), lineWidth: 1))
                        
                        VStack(spacing: 20) {
                            ForEach(courses) { course in
                                NavigationLink(destination: ClassDetailView(course: course)) {
                                    CourseCard(course: course)
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
