import SwiftUI
import SwiftData

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
