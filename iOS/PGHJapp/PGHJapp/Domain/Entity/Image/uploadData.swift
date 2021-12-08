import Foundation

struct UploadData: Codable {
    let id: Int
    let images: [Image]
    enum CodingKeys: String, CodingKey {
        case id = "upload"
        case images
    }
}
