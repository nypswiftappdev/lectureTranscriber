import SwiftUI
import SwiftData
import Foundation

struct AddLectureView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [SortDescriptor(\Tag.name)]) private var allTags: [Tag]
    
    let course: Course
    
    @State private var title = ""
    @State private var summary = ""
    @State private var duration = "00:00"
    @State private var newTagName = ""
    @State private var selectedTagIDs: Set<UUID> = []
    
    // Break up to fix error
    private var headerFields: some View {
        VStack(spacing: 20) {
            customTextField(title: "Lecture Title", placeholder: "e.g. Introduction to Calculus", text: $title)
            summaryField
            customTextField(title: "Duration (mock)", placeholder: "e.g. 45:00", text: $duration)
        }
        .padding(.horizontal)
    }

    private var summaryField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Summary")
                .font(.caption.bold())
                .foregroundColor(.gray)
                .textCase(.uppercase)
            
            ZStack(alignment: .topLeading) {
                if summary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Write a brief summary…")
                        .foregroundColor(.white.opacity(0.2))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $summary)
                    .frame(minHeight: 110)
                    .padding(8)
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            }
        }
    }

    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tags")
                .font(.caption.bold())
                .foregroundColor(.gray)
                .textCase(.uppercase)

            Group {
                if allTags.isEmpty {
                    Text("No tags yet. Create one below.")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.6))
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(allTags) { tag in
                                let isSelected = selectedTagIDs.contains(tag.id)
                                Text(tag.name)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(isSelected ? .black : .white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(isSelected ? tag.color : Color.white.opacity(0.05))
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(isSelected ? Color.clear : Color.white.opacity(0.1), lineWidth: 1)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            toggleTag(tag)
                                        }
                                    }
                            }
                        }
                    }
                }
            }

            HStack(spacing: 10) {
                placeholderTextField(placeholder: "Create a tag…", text: $newTagName)
                #if os(iOS)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                #endif

                Button(action: createTag) {
                    Image(systemName: "plus")
                        .font(.title3.bold())
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(course.themeColor)
                        .cornerRadius(12)
                        .shadow(color: course.themeColor.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .disabled(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.4 : 1)
            }
        }
        .padding(.horizontal)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            headerFields
                            tagsSection
                        }
                        .padding(.vertical)
                    }
                    
                    Button(action: addLecture) {
                        Text("Save Lecture")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty ? Color.white.opacity(0.3) : course.themeColor)
                            .cornerRadius(16)
                            .shadow(color: course.themeColor.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(title.isEmpty)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle("New Lecture")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
    
    private func customTextField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(.gray)
                .textCase(.uppercase)
            
            placeholderTextField(placeholder: placeholder, text: text)
        }
    }
    
    private func placeholderTextField(placeholder: String, text: Binding<String>) -> some View {
        ZStack(alignment: .leading) {
            if text.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.2))
                    .padding(.horizontal, 16)
            }
            TextField("", text: text)
                .foregroundColor(.white)
                .padding()
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
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
        let tag = Tag(name: trimmed, colorHex: course.themeColorHex)
        modelContext.insert(tag)
        selectedTagIDs.insert(tag.id)
        newTagName = ""
    }
}

