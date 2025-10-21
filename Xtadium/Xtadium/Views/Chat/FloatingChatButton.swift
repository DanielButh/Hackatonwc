import SwiftUI

struct FloatingChatButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "message.fill")
                .font(.system(size: 22, weight: .bold))
                .padding(18)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .shadow(radius: 8)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 90) // arriba del TabBar
    }
}
