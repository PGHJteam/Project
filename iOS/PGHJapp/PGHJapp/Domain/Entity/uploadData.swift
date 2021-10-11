import Foundation

struct Coordinate: Codable {
    var left: Double
    var top: Double
}

struct Size: Codable {
    var height: Double
    var width: Double
}

struct Text: Codable {
    var text: String
    var coordinate: Coordinate
    var size: Size
    let accuracy: Double
}

struct Image: Codable {
    let id: Int
    let results: [Text]
    enum CodingKeys: String, CodingKey {
        case id = "image_id"
        case results
    }
}

struct UploadData: Codable {
    let id: Int
    let images: [Image]
    enum CodingKeys: String, CodingKey {
        case id = "upload_id"
        case images
    }
}
