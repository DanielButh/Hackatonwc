import Foundation

final class MapDataService {
    static let shared = MapDataService()
    private init() {}

    func loadMapData() throws -> [EstadioRestaurantes] {
        guard let url = Bundle.main.url(forResource: "map_data", withExtension: "json") else {
            throw NSError(domain: "MapData", code: 404, userInfo: [NSLocalizedDescriptionKey: "map_data.json no encontrado"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([EstadioRestaurantes].self, from: data)
    }
}
