import SwiftUI
import SwiftData

struct AddLectureView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Tag.name) private var allTags: [Tag]
    
    let course: Course
    
    @State private var title = ""
    @State private var summary = ""
    @State private var duration = "00:00"
    @State private var newTagName = ""
    @State private var selectedTagIDs: Set<UUID> = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Lecture Title")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .textCase(.uppercase)
                            TextField("e.g. Introduction to Calculus", text: $title)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Summary")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .textCase(.uppercase)
                            TextField("What was this lecture about?", text: $summary, axis: .vertical)
                                .lineLimit(3...5)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Duration (mock)")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .textCase(.uppercase)
                            TextField("e.g. 45:00", text: $duration)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tags")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .textCase(.uppercase)
                            
                            if allTags.isEmpty {
                                Text("No tags yet. Create one below.")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(allTags) { tag in
                                            let isSelected = selectedTagIDs.contains(tag.id)
                                            Text(tag.name)
                                                .font(.caption.weight(.semibold))
                                                .foregroundColor(isSelected ? .black : .white)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(isSelected ? tag.color : Color.white.opacity(0.1))
                                                .clipShape(Capsule())
                                                .overlay(
                                                    Capsule()
                                                        .stroke(tag.color.opacity(isSelected ? 0 : 0.9), lineWidth: 1)
                                                )
                                                .onTapGesture {
                                                    toggleTag(tag)
                                                }
                                        }
                                    }
                                }
                            }
                            
                            HStack(spacing: 10) {
                                TextField("Create a tag…", text: $newTagName)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                #if os(iOS)
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled()
                                #endif
                                
                                Button(action: createTag) {
                                    Image(systemName: "plus")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .frame(width: 44, height: 44)
                                        .background(course.themeColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .disabled(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                .opacity(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.4 : 1)
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: addLecture) {
                        Text("Add Lecture")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty ? Color.gray : course.themeColor)
                            .cornerRadius(16)
                    }
                    .disabled(title.isEmpty)
                    .padding()
                }
            }
            .navigationTitle("New Lecture")
            .tint(course.themeColor)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
    
    private func addLecture() {
        let newLecture = Lecture(title: title, duration: duration, summary: summary)
        newLecture.course = course
        newLecture.tags = allTags.filter { selectedTagIDs.contains($0.id) }
        modelContext.insert(newLecture)
        dismiss()
    }
    
    private func toggleTag(_ tag: Tag) {
        if selectedTagIDs.contains(tag.id) {
            selectedTagIDs.remove(tag.id)
        } else {
            selectedTagIDs.insert(tag.id)
        }
    }
    
    private func createTag() {
        let trimmed = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // Use the course theme color by default so tags feel consistent per class.
        let tag = Tag(name: trimmed, colorHex: course.themeColorHex)
        modelContext.insert(tag)
        selectedTagIDs.insert(tag.id)
        newTagName = ""
    }
}
