 import Foundation

 struct APIConstants {
     // MARK: - Start Endpoint
     static var baseURL: URL {
         return URL(string: "http://3.35.137.242:8080")!
     }

     static let token = ""
 }

 enum HTTPHeaderField: String {
     case authentication = "Authorization"
     case contentType = "Content-Type"
     case acceptType = "Accept"
     case acceptEncoding = "Accept-Encoding"
     case xAuthToken = "x-auth-token"
 }

 enum ContentType: String {
     case json = "application/json"
 }
