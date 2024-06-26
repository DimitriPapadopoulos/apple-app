import Foundation

public struct Coordinate: Codable, Equatable, Sendable {
    public init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    public let lat: Double
    public let lon: Double
}
