import SwiftUI
import SwiftData
import AVFoundation

struct LectureRecordingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Tag.name) private var allTags: [Tag]
    
    let course: Course
    
    @State private var isRecording = false
    @State private var isPaused = false
    @State private var recordingDuration: TimeInterval = 0
    @State private var timer: Timer?
    @State private var transcriptText: String = ""
    
    // Post-Recording State
    @State private var hasStoppedRecording = false
    @State private var title = ""
    @State private var summary = ""
    @State private var newTagName = ""
    @State private var selectedTagIDs: Set<UUID> = []
    
    // Mock transcription update for UI demo
    @State private var mockTimer: Timer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    if !hasStoppedRecording {
                        recordingInterface
                    } else {
                        saveDetailsInterface
                    }
                }
                .padding()
            }
            .navigationTitle(hasStoppedRecording ? "Save Lecture" : "New Recording")
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
    
    // MARK: - Recording Interface
    private var recordingInterface: some View {
        VStack(spacing: 30) {
            
            // Timer Display
            Text(timeString(from: recordingDuration))
                .font(.system(size: 60, weight: .thin).monospacedDigit())
                .foregroundColor(.white)
                .contentTransition(.numericText())
                .animation(.default, value: recordingDuration)
            
            // Live Transcript View
            VStack(alignment: .leading) {
                Text("LIVE TRANSCRIPT")
                    .font(.caption.bold())
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
                
                ScrollView {
                    Text(transcriptText.isEmpty ? "Transcription will appear here..." : transcriptText)
                        .font(.body)
                        .foregroundColor(transcriptText.isEmpty ? .gray : .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            }
            .frame(maxHeight: .infinity)
            
            // Controls
            HStack(spacing: 40) {
                if recordingDuration > 0 {
                    Button(action: resetRecording) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.title2)
                            Text("Discard")
                                .font(.caption)
                        }
                        .foregroundColor(.red)
                    }
                }
                
                Button(action: toggleRecording) {
                    ZStack {
                        Circle()
                            .fill(isRecording ? Color.yellow : Color.red)
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: isRecording ? "pause.fill" : "mic.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                }
                .shadow(color: (isRecording ? Color.yellow : Color.red).opacity(0.4), radius: 10)
                
                if recordingDuration > 0 {
                    Button(action: stopRecording) {
                        VStack {
                            Image(systemName: "stop.circle")
                                .font(.system(size: 44))
                                .foregroundColor(.white)
                            Text("Finish")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Save Details Interface
    private var saveDetailsInterface: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("RECORDED")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(timeString(from: recordingDuration))
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Image(systemName: "waveform")
                        .font(.title)
                        .foregroundColor(course.themeColor)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                
                // Title Input
                LTFormLabeledTextField(
                    title: "Lecture Title",
                    placeholder: "e.g. Introduction to Calculus",
                    text: $title
                )
                
                // Transcript Preview (ReadOnly here)
                VStack(alignment: .leading, spacing: 8) {
                    Text("TRANSCRIPT")
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                    
                    Text(transcriptText)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        .frame(maxHeight: 200) // Limit height
                }

                // Tags Section
                tagsSection
                
                Spacer()
                
                // Save Button
                Button(action: saveLecture) {
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
                .padding(.vertical)
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
                LTFormPlaceholderTextField(placeholder: "Create a tag…", text: $newTagName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
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
    }
    
    // MARK: - Actions
    
    private func toggleRecording() {
        if isRecording {
            // Pause
            isRecording = false
            isPaused = true
            timer?.invalidate()
            timer = nil
        } else {
            // Start / Resume
            isRecording = true
            isPaused = false
            
            // Start timer
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                recordingDuration += 1
                // Mock transcript growth
                if transcriptText.isEmpty {
                    transcriptText = "Here is some simulated transcription text"
                } else {
                    transcriptText += " that keeps growing as you record more..."
                }
            }
        }
    }
    
    private func stopRecording() {
        isRecording = false
        isPaused = false
        timer?.invalidate()
        timer = nil
        
        withAnimation {
            hasStoppedRecording = true
        }
    }
    
    private func resetRecording() {
        isRecording = false
        isPaused = false
        timer?.invalidate()
        timer = nil
        recordingDuration = 0
        transcriptText = ""
        hasStoppedRecording = false
    }
    
    private func saveLecture() {
        let newLecture = Lecture(title: title, duration: timeString(from: recordingDuration), summary: summary.isEmpty ? transcriptText : summary)
        newLecture.course = course
        newLecture.tags = allTags.filter { selectedTagIDs.contains($0.id) }
        modelContext.insert(newLecture)
        dismiss()
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval)
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
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
