import SwiftUI
import SwiftData

struct AddCourseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var code = ""
    @State private var selectedColor = Color.blue
    @State private var selectedIcon = "book.fill"
    
    let icons = ["book.fill", "graduationcap.fill", "pencil.tip", "brain.head.profile", "lightbulb.fill", "atom", "function", "globe.americas.fill", "music.note", "chart.bar.fill"]
    
    let colors: [Color] = [
        Color(red: 0.0, green: 0.48, blue: 1.0), // Blue
        Color(red: 1.0, green: 0.23, blue: 0.19), // Red
        Color(red: 0.2, green: 0.78, blue: 0.35), // Green
        Color(red: 1.0, green: 0.62, blue: 0.0), // Orange
        Color(red: 0.69, green: 0.32, blue: 0.87), // Purple
        Color(red: 1.0, green: 0.18, blue: 0.33), // Pink
        Color(red: 0.0, green: 0.78, blue: 0.75), // Teal
        Color(red: 0.35, green: 0.34, blue: 0.84)  // Indigo
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            VStack(alignment: .leading) {
                                Text("Preview")
                                    .font(.caption.bold())
                                    .foregroundColor(.gray)
                                    .textCase(.uppercase)
                                    .padding(.vertical, 10)
                                    
                                
                                CourseCard(course: Course(name: name.isEmpty ? "Course Name" : name, 
                                                         code: code.isEmpty ? "CODE101" : code, 
                                                         themeColorHex: selectedColor.toHex, 
                                                         icon: selectedIcon))
                                    .frame(height: 160)
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 20) {
                                customTextField(title: "Course Name", placeholder: "e.g. Advanced Mathematics", text: $name)
                                customTextField(title: "Course Code", placeholder: "e.g. MATH301", text: $code)
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Theme Color")
                                    .font(.caption.bold())
                                    .foregroundColor(.gray)
                                    .textCase(.uppercase)
                                
                                HStack(spacing: 12) {
                                    ForEach(colors, id: \.self) { color in
                                        Circle()
                                            .fill(color)
                                            .frame(width: 34, height: 34)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                                            )
                                            .onTapGesture {
                                                withAnimation(.spring()) {
                                                    selectedColor = color
                                                }
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Icon")
                                    .font(.caption.bold())
                                    .foregroundColor(.gray)
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
                                                    withAnimation(.spring()) {
                                                        selectedIcon = icon
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                    
                    Button(action: addCourse) {
                        Text("Create Course")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(name.isEmpty || code.isEmpty ? Color.white.opacity(0.3) : selectedColor)
                            .cornerRadius(16)
                            .shadow(color: selectedColor.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(name.isEmpty || code.isEmpty)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle("New Class")
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
            
            TextField("", text: text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.2)))
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
        }
    }
    
    private func addCourse() {
        let newCourse = Course(name: name, code: code, themeColorHex: selectedColor.toHex, icon: selectedIcon)
        modelContext.insert(newCourse)
        dismiss()
    }
}
