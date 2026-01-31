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
