//
//  componenets.swift
//  lecturetranscriber
//
//  Created by Shadow33 on 15/1/26.
//
import SwiftUI

struct CourseCard: View {
    let course: Course
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(
                colors: [course.themeColor, course.themeColor.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Image(systemName: course.icon)
                .font(.system(size: 100))
                .foregroundColor(.white.opacity(0.15))
                .offset(x: 20, y: 20)
                .rotationEffect(.degrees(-15))
            
            VStack(alignment: .leading, spacing: 12) {
                Text(course.code)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                
                Text(course.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                Spacer()
                
                HStack {
                    Label("\(course.lectures.count) Lectures", systemImage: "play.circle.fill")
                        .font(.caption.bold())
                        .foregroundColor(.white.opacity(0.9))
                    Spacer()
                }
            }
            .padding(24)
        }
        .frame(height: 180)
        .cornerRadius(24)
        .shadow(color: course.themeColor.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct ClassDetailView: View {
    let course: Course
    @Environment(\.dismiss) var dismiss
    @State private var showingAddLecture = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text(course.code)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Hero Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text(course.name)
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            
                            HStack {
                                Circle()
                                    .fill(course.themeColor == Color.gray ? Color.white : course.themeColor)
                                    .frame(width: 8, height: 8)
                                Text("\(course.lectures.count) Transcripts Saved")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .padding(.horizontal)
                        
                        // Transcripts List
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Lectures")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            if course.lectures.isEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "mic.badge.plus")
                                        .font(.system(size: 50))
                                        .foregroundColor(course.themeColor.opacity(0.5))
                                    Text("No lectures yet.\nStart by adding your first one.")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                ForEach(course.lectures) { lecture in
                                    LectureListRow(lecture: lecture, color: course.themeColor)
                                }
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                
                // Add Button
                Button(action: { showingAddLecture = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Lecture")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(course.themeColor == Color.gray ? Color.white : course.themeColor)
                    .cornerRadius(20)
                    .shadow(color: (course.themeColor == Color.gray ? Color.white : course.themeColor).opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(24)
            }
        }
        .navigationBarHidden(true)
        .tint(course.themeColor)
        .sheet(isPresented: $showingAddLecture) {
            AddLectureView(course: course)
        }
    }
}

struct LectureListRow: View {
    let lecture: Lecture
    let color: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: "play.fill")
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lecture.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                if !lecture.tags.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(lecture.tags) { tag in
                            Text(tag.name)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(tag.color)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(tag.color.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
            Spacer()
            
            Text(lecture.duration)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.white.opacity(0.05))
                .cornerRadius(6)
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(16)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
                .padding(.horizontal)
        )
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
