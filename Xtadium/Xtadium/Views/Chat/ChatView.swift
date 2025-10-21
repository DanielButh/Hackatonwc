import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @State private var inputText: String = ""

    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                List(viewModel.messages) { message in
                    HStack {
                        if message.isUser { Spacer() }
                        MessageBubble(text: message.text, isUser: message.isUser)
                        if !message.isUser { Spacer() }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .id(message.id)
                }
                .listStyle(.plain)

                .onChange(of: viewModel.messages) { messages in
                    if let last = messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            if viewModel.isLoading {
                HStack {
                    Text("La IA está escribiendo...")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
            }

            HStack {
                TextField("Escribe tu mensaje...", text: $inputText, axis: .vertical)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                Button {
                    let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !text.isEmpty else { return }
                    viewModel.sendMessage(text)
                    inputText = ""
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(inputText.isEmpty || viewModel.isLoading ? .gray : .blue)
                }
                .disabled(inputText.isEmpty || viewModel.isLoading)
            }
            .padding([.horizontal, .bottom])
            .padding(.top, 5)
        }
    }
}
