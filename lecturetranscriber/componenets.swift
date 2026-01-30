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
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 12) {
                Text(course.code)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.black.opacity(0.7))
                
                Text(course.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
    
            Spacer()
            
            Image(systemName: course.icon)
                .font(.title)
                .foregroundColor(.black.opacity(0.5))
        }
        .padding(24)
        .frame(height: 180)
        .background(course.themeColor)
        .cornerRadius(24)
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
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(course.code)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(8)
                                .background(course.themeColor)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                            
                            Text(course.name)
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        Divider().background(Color.gray.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Transcripts")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            if course.lectures.isEmpty {
                                Text("No lectures yet. Tap below to add one.")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                            } else {
                                ForEach(course.lectures) { lecture in
                                    LectureListRow(lecture: lecture, color: course.themeColor)
                                }
                            }
                        }
                    }
                }
                
                Button(action: { showingAddLecture = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Lecture")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(course.themeColor)
                    .cornerRadius(30)
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
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 48, height: 48)
                Image(systemName: "play.fill")
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lecture.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(lecture.summary)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                if !lecture.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(lecture.tags) { tag in
                                Text(tag.name)
                                    .font(.caption2.weight(.semibold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(tag.color)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.top, 4)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(lecture.duration)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(6)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(6)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .cornerRadius(16)
        .padding(.horizontal)
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


