import SwiftUI
import Foundation

struct LTFormLabeledTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(.gray)
                .textCase(.uppercase)

            LTFormPlaceholderTextField(placeholder: placeholder, text: $text)
        }
    }
}

struct LTFormPlaceholderTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.2))
                    .padding(.horizontal, 16)
            }

            TextField("", text: $text)
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
}

struct LTFormSummaryEditor: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(.gray)
                .textCase(.uppercase)

            ZStack(alignment: .topLeading) {
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.2))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                }

                TextEditor(text: $text)
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
}

