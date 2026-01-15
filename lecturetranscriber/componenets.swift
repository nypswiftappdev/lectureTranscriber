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
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(course.schedule)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(.black.opacity(0.6))
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
                            
                            Text(course.schedule)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        Divider().background(Color.gray.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Transcripts")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(course.lectures) { lecture in
                                LectureListRow(lecture: lecture, color: course.themeColor)
                            }
                        }
                    }
                }
                
                Button(action: { print("Recording for \(course.name)") }) {
                    HStack {
                        Image(systemName: "mic.fill")
                        Text("Record Lecture")
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
                
                Text(lecture.date)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}


