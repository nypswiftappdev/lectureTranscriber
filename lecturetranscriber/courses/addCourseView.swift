import SwiftUI
import SwiftData

struct AddCourseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var code = ""
    @State private var selectedColor = Color.blue
    @State private var selectedIcon = "book.fill"
    
    let icons = ["book.fill", "graduationcap.fill", "pencil.tip", "brain.head.profile", "lightbulb.fill", "atom", "function", "globe.americas.fill"]
    let colors: [Color] = [.blue, .red, .green, .yellow, .orange, .purple, .pink, .teal]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Course Name")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .textCase(.uppercase)
                            TextField("Course Name", text: $name, prompt: Text("e.g. Advanced Mathematics").foregroundStyle(.gray.opacity(0.7)))
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                    
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Course Code")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .textCase(.uppercase)
                            TextField("Course Code", text: $code, prompt: Text("e.g. MATH301").foregroundStyle(.gray.opacity(0.7)))
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .textInputAutocapitalization(.characters)
                                .autocorrectionDisabled()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Theme Color")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .textCase(.uppercase)
                            HStack {
                                ForEach(colors, id: \.self) { color in
                                    Circle()
                                        .fill(color)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: selectedColor == color ? 2 : 0)
                                        )
                                        .onTapGesture {
                                            selectedColor = color
                                        }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Icon")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .textCase(.uppercase)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(icons, id: \.self) { icon in
                                        Image(systemName: icon)
                                            .font(.title2)
                                            .foregroundColor(selectedIcon == icon ? .black : .white)
                                            .frame(width: 50, height: 50)
                                            .background(selectedIcon == icon ? selectedColor : Color.white.opacity(0.1))
                                            .cornerRadius(12)
                                            .onTapGesture {
                                                selectedIcon = icon
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: addCourse) {
                        Text("Add Course")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(name.isEmpty || code.isEmpty ? Color.gray : selectedColor)
                            .cornerRadius(16)
                    }
                    .disabled(name.isEmpty || code.isEmpty)
                    .padding()
                }
            }
            .navigationTitle("New Course")
            .tint(selectedColor)
            .navigationBarTitleDisplayMode(.inline)
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
    
    private func addCourse() {
        let newCourse = Course(name: name, code: code, themeColorHex: selectedColor.toHex, icon: selectedIcon)
        modelContext.insert(newCourse)
        dismiss()
    }
}
