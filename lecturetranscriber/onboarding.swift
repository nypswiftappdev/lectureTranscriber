//
//  onboarding.swift
//  lecturetranscriber
//
//  Created by Shadow33 on 15/1/26.
//
import SwiftUI

struct OnboardingView: View {
    @AppStorage("username") private var userName: String = ""
    @AppStorage("onboarded") private var onboarded: Bool = false
    @State private var isShowingDashboard = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Welcome to Classly")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gray)
                            .textCase(.uppercase)
                            .tracking(2)
                        
                        Text(userName.isEmpty ? "What's your name?" : "Hey \(userName)!")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .animation(.spring(), value: userName)
                    }
                    .padding(.top, 40)
                    
                    // Input Field
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("Enter your name", text: $userName)
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .accentColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        FeatureRow(
                            icon: "mic.fill",
                            title: "Record Lectures",
                            description: "Capture every detail of your classes in real-time.",
                            color: Color(red: 0.8, green: 0.95, blue: 0.85)
                        )
                        
                        FeatureRow(
                            icon: "sparkles",
                            title: "AI Summaries",
                            description: "Get instant bullet points from your voice recordings.",
                            color: Color(red: 0.9, green: 0.85, blue: 0.95)
                        )
                        
                        FeatureRow(
                            icon: "doc.text.magnifyingglass",
                            title: "Smart Search",
                            description: "Find specific keywords across all your transcripts.",
                            color: Color(red: 0.98, green: 0.92, blue: 0.8)
                        )
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    Button(action: {
                        if !userName.isEmpty {
                            onboarded = true
                            isShowingDashboard = true
                        }
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(userName.isEmpty ? Color.gray.opacity(0.3) : Color.white)
                            .cornerRadius(30)
                    }
                    .disabled(userName.isEmpty)
                    .animation(.easeInOut, value: userName)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 24)
            }
            .navigationDestination(isPresented: $isShowingDashboard) {
                ClassDashboard()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
