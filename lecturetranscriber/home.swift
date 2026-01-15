//
//  home.swift
//  lecturetranscriber
//
//  Created by Shadow33 on 15/1/26.
//

import SwiftUI

struct ClassDashboard: View {
    let courses = [
        Course(
            name: "Product Design",
            code: "DES 101",
            schedule: "Mon, Wed • 9:00 AM",
            themeColor: Color(red: 0.8, green: 0.95, blue: 0.85),
            icon: "pencil.tip.crop.circle",
            lectures: [
                Lecture(title: "Design Systems Intro", date: "Oct 24", duration: "1h 15m", summary: "Intro to atomic design principles."),
                Lecture(title: "Typography Rules", date: "Oct 22", duration: "55m", summary: "Serif vs Sans-serif usage.")
            ]
        ),
        Course(
            name: "Adv. Macroeconomics",
            code: "ECON 340",
            schedule: "Tue, Thu • 1:30 PM",
            themeColor: Color(red: 0.98, green: 0.92, blue: 0.8),
            icon: "chart.line.uptrend.xyaxis.circle",
            lectures: [
                Lecture(title: "Market Equilibrium", date: "Yesterday", duration: "1h 30m", summary: "Supply and demand curves analysis."),
                Lecture(title: "Inflation Metrics", date: "Oct 20", duration: "1h 05m", summary: "CPI and PPI differences.")
            ]
        ),
        Course(
            name: "Comp. Sci. Algorithms",
            code: "CS 202",
            schedule: "Fridays • 10:00 AM",
            themeColor: Color(red: 0.9, green: 0.85, blue: 0.95),
            icon: "chevron.left.forwardslash.chevron.right",
            lectures: [
                Lecture(title: "Binary Trees", date: "Friday", duration: "50m", summary: "Traversal methods and optimization.")
            ]
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Wednesday, Oct 26")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .textCase(.uppercase)
                                
                                Text("Your Classes")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Button(action: {}) {
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
}

#Preview {
    ClassDashboard()
}
