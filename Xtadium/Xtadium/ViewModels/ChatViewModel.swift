import Foundation
import GoogleGenerativeAI
internal import Combine

class ChatViewModel: ObservableObject {

    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "AIzaSyAgOByMdpAFllOJZDB3519NG7k4r6XsUfo") as? String ?? "AIzaSyAgOByMdpAFllOJZDB3519NG7k4r6XsUfo"

    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false

    private var chat: Chat?
    private var initialContext: String?

    init(initialContext: String? = nil) {
        self.initialContext = initialContext

        do {
            let model = try GenerativeModel(name: "gemini-2.5-flash", apiKey: apiKey)
            self.chat = model.startChat()
            messages.append(ChatMessage(text: "¡Hola! Soy tu asistente del Mundial. Puedo ayudarte con tus boletos, estadios y lugares cercanos. ¿Qué necesitas?", isUser: false))
        } catch {
            messages.append(ChatMessage(text: "Error al inicializar la IA.", isUser: false))
            print("Error al inicializar Gemini: \(error.localizedDescription)")
        }
    }

    /// Inyecta el contexto una vez que lo tengas listo (tickets + mapa)
    func primeWithContextIfNeeded() {
        guard let chat = chat, let ctx = initialContext, !ctx.isEmpty else { return }
        // Enviamos el contexto como primer mensaje del "sistema"
        Task {
            do {
                _ = try await chat.sendMessage("""
                [CONTEXT]
                \(ctx)
                [/CONTEXT]
                """)
                await MainActor.run {
                    // Opcional: muestra un recordatorio visual
                    self.messages.append(ChatMessage(text: "Contexto cargado: ya conozco tus próximos boletos y lugares cercanos.", isUser: false))
                }
            } catch {
                await MainActor.run {
                    self.messages.append(ChatMessage(text: "No pude cargar el contexto.", isUser: false))
                }
            }
            // Evita reinyectarlo múltiples veces
            self.initialContext = nil
        }
    }

    func sendMessage(_ text: String) {
        guard !text.isEmpty, let chat = chat else { return }
        let userMessage = ChatMessage(text: text, isUser: true)
        messages.append(userMessage)
        isLoading = true

        Task {
            do {
                let response = try await chat.sendMessage(text)
                await MainActor.run {
                    self.isLoading = false
                    let geminiResponse = response.text ?? "No pude obtener una respuesta."
                    self.messages.append(ChatMessage(text: geminiResponse, isUser: false))
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.messages.append(ChatMessage(text: "Error de comunicación con el servidor.", isUser: false))
                }
                print("Error al enviar mensaje: \(error.localizedDescription)")
            }
        }
    }
}
