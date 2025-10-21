import Foundation
import CoreLocation

struct EstadioRestaurantes: Decodable, Identifiable {
    var id: String { estadio.nombre }

    let estadio: Estadio
    let restaurantes: [PuntoInteres]
}

struct Estadio: Decodable {
    let nombre: String
    let latitud: Double
    let longitud: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
    }
}

struct PuntoInteres: Decodable, Identifiable {
    var id: String { nombre + "\(latitud)\(longitud)" }

    let nombre: String
    let latitud: Double
    let longitud: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
    }
}
