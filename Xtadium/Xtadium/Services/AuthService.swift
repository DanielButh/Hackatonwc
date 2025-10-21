import Foundation

struct AuthCredentials: Codable {
    let email: String
    let password: String
}

struct AuthRecord: Codable {
    let email: String
    let password: String
    let userId: String
    let displayName: String
}

final class AuthService {
    static let shared = AuthService()
    private init() {}

    func login(email: String, password: String) async throws -> (token: String, userId: String, displayName: String) {
        // Carga JSON local con cuentas válidas
        let records = try loadAuthRecords()
        guard let rec = records.first(where: { $0.email.lowercased() == email.lowercased() && $0.password == password }) else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Credenciales inválidas"])
        }
        // Token ficticio
        let token = "MOCK_TOKEN_\(UUID().uuidString)"
        return (token, rec.userId, rec.displayName)
    }

    private func loadAuthRecords() throws -> [AuthRecord] {
        guard let url = Bundle.main.url(forResource: "mock_auth", withExtension: "json") else {
            throw NSError(domain: "Auth", code: 404, userInfo: [NSLocalizedDescriptionKey: "mock_auth.json no encontrado"])
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([AuthRecord].self, from: data)
    }
}
