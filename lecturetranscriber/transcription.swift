//
//  lectureTranscription.swift
//  lecturetranscriber
//
//  Created by Shadow33 on 31/1/26.
//

import Foundation
import Speech
import AVFoundation

enum RecognizerError: Error, Identifiable {
    case nilRecognizer
    case notAuthorizedToRecognize
    case notPermittedToRecord
    case recognizerIsUnavailable
    
    var id: Self { self }
    
    var message: String {
        switch self {
        case .nilRecognizer: return "Can't initialize speech recognizer"
        case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
        case .notPermittedToRecord: return "Not permitted to record audio"
        case .recognizerIsUnavailable: return "Recognizer is unavailable"
        }
    }
}

class TranscriptionManager: ObservableObject {
    @Published var transcript: String = ""
    @Published var isRecording: Bool = false
    @Published var error: RecognizerError?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    //silence stuff
    // private var speechTimer: Timer?
    // private var silenceTimer: Timer?
    // private var hasSpoken = false
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if status != .authorized {
                    self.error = .notAuthorizedToRecognize
                }
            }
        }
    }
    
    func startRecording() {
        if isRecording { return }
        
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            self.error = .recognizerIsUnavailable
            return
        }
        
    
        #if os(iOS)
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            self.error = .notPermittedToRecord
            return
        }
        #endif
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            self.error = .nilRecognizer
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        //works only for ios 13 anddd above...
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = true
        }
        
        let inputNode = audioEngine.inputNode
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            
            if let result = result {
                self.transcript = result.bestTranscription.formattedString
                isFinal = result.isFinal
                
                // self.hasSpoken = true
                // self.silenceTimer?.invalidate()
                // self.speechTimer?.invalidate()
                /*
                self.speechTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
                }
                */
            }
            
            if error != nil || isFinal {
                self.stopRecording()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isRecording = true
            error = nil
            // hasSpoken = false
            transcript = ""
            
            // startSilenceTimer()
        } catch {
            self.error = .notPermittedToRecord
        }
    }
    
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
            
            recognitionTask?.cancel()
            recognitionTask = nil
            
            #if os(iOS)
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            #endif
            
            isRecording = false
            // silenceTimer?.invalidate()
            // speechTimer?.invalidate()
        }
    }
    
    func reset() {
        stopRecording()
        transcript = ""
        error = nil
    }
    
    /*
    private func startSilenceTimer() {
        silenceTimer?.invalidate()
        // 10s silence timeout for initial speech
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            if !self.hasSpoken {
                // If needed, we could stop recording here.
                // For now, we'll just log or handle as appropriate.
                // self.stopRecording() // Uncomment to enable auto-stop on start silence
            }
        }
    }
    */
}
