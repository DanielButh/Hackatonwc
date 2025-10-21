import SwiftUI

struct MessageBubble: View {
    let text: String
    let isUser: Bool

    var body: some View {
        Text(text)
            .padding(10)
            .background(isUser ? Color.blue : Color(.systemGray5))
            .foregroundColor(isUser ? .white : .primary)
            .cornerRadius(10)
            .frame(maxWidth: 250, alignment: isUser ? .trailing : .leading)
    }
}
