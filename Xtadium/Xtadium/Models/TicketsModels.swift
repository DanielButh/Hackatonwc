import Foundation

struct TicketsResponse: Codable {
    let user: User
    let tickets: [Ticket]
    let meta: Meta
}

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
}

struct Ticket: Codable, Identifiable {
    var id: String { ticket_id }
    let ticket_id: String
    let event: EventInfo
    let seat: Seat
    let price: Price
    let status: String
    let barcode: String
    let delivery_method: String
    let purchase_date: Date
}

struct EventInfo: Codable {
    let name: String
    let date: Date
    let venue: Venue
}

struct Venue: Codable {
    let stadium: String
    let city: String
    let country: String
    let image: String?
}

struct Seat: Codable {
    let section: String
    let row: String
    let seat_number: String
}

struct Price: Codable {
    let currency: String
    let amount: Double
}

struct Meta: Codable {
    let source: String
    let last_updated: Date
}
