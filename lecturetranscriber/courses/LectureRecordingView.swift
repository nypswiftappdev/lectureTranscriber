import SwiftUI
import SwiftData
import AVFoundation
import Speech

struct LectureRecordingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Tag.name) private var allTags: [Tag]
    
    let course: Course
    
    @StateObject private var transcriptionManager = TranscriptionManager()
    @State private var isRecording = false
    @State private var isPaused = false
    @State private var recordingDuration: TimeInterval = 0
    @State private var startTime: Date?
    @State private var timer: Timer?
    @State private var committedTranscript: String = ""
    
    private var transcriptText: String {
        let current = transcriptionManager.transcript
        if current.isEmpty { return committedTranscript }
        if committedTranscript.isEmpty { return current }
        return committedTranscript + " " + current
    }
    
    @State private var hasStoppedRecording = false
    @State private var title = ""
    @State private var summary = ""
    @State private var newTagName = ""
    @State private var selectedTagIDs: Set<UUID> = []
    @State private var visualizerBars: [CGFloat] = Array(repeating: 10, count: 20)
    
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
            .alert(item: $transcriptionManager.error) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
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
            
            VStack(spacing: 10) {
                Text(timeString(from: recordingDuration))
                    .font(.system(size: 60, weight: .thin).monospacedDigit())
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
                    .animation(.default, value: recordingDuration)
                
                HStack(spacing: 4) {
                    ForEach(0..<20, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(course.themeColor.opacity(0.8))
                            .frame(width: 4, height: isRecording ? visualizerBars[index] : 4)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: visualizerBars[index])
                    }
                }
                .frame(height: 50)
                .opacity(recordingDuration > 0 ? 1 : 0)
            }
            
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
                
                LTFormLabeledTextField(
                    title: "Lecture Title",
                    placeholder: "e.g. Introduction to Calculus",
                    text: $title
                )
                
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
                        .frame(maxHeight: 200)
                }

                tagsSection
                
                Spacer()
                
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
            transcriptionManager.stopRecording()
            isRecording = false
            isPaused = true
            timer?.invalidate()
            timer = nil
        } else {
            if !transcriptionManager.transcript.isEmpty {
                 committedTranscript = transcriptText
            }
            transcriptionManager.startRecording()
            isRecording = true
            isPaused = false
            
            // Use 0.05s interval for smooth UI updates
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                recordingDuration += 0.05
                
                // Update fake visualizer bars
                for i in 0..<visualizerBars.count {
                    visualizerBars[i] = CGFloat.random(in: 10...40)
                }
            }
        }
    }
    
    private func stopRecording() {
        committedTranscript = transcriptText
        transcriptionManager.stopRecording()
        
        isRecording = false
        isPaused = false
        timer?.invalidate()
        timer = nil
        
        withAnimation {
            hasStoppedRecording = true
        }
    }
    
    private func resetRecording() {
        transcriptionManager.reset()
        committedTranscript = ""
        isRecording = false
        isPaused = false
        timer?.invalidate()
        timer = nil
        recordingDuration = 0
        hasStoppedRecording = false
        visualizerBars = Array(repeating: 10, count: 20)
    }
    
    private func saveLecture() {
        let newLecture = Lecture(title: title, duration: timeString(from: recordingDuration), summary: summary.isEmpty ? transcriptText : summary)
        newLecture.course = course
        newLecture.tags = allTags.filter { selectedTagIDs.contains($0.id) }
        modelContext.insert(newLecture)
        dismiss()
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
