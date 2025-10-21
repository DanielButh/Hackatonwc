import Foundation
import _MapKit_SwiftUI
import MapKit
internal import Combine

@MainActor
final class StadiumMapViewModel: ObservableObject {
    @Published var items: [EstadioRestaurantes] = []
    @Published var selectedIndex: Int = 0
    @Published var cameraPosition: MapCameraPosition = .automatic

    func load() {
        do {
            let data = try MapDataService.shared.loadMapData()
            self.items = data
            if let first = data.first {
                center(on: first.estadio.coordinate, meters: 6000)
            }
        } catch {
            self.items = []
        }
    }

    func center(on coordinate: CLLocationCoordinate2D, meters: CLLocationDistance = 6000) {
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: meters,
                                        longitudinalMeters: meters)
        cameraPosition = .region(region)
    }

    var selected: EstadioRestaurantes? {
        guard items.indices.contains(selectedIndex) else { return nil }
        return items[selectedIndex]
    }
}
