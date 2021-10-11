 import Foundation
import Alamofire

 struct APIConstants {
     // MARK: - Start Endpoint
     static var baseURL: URL {
//         return URL(string: "http://13.125.209.10:8000")!
         return URL(string: "https://d9c53cef-5902-4d3f-843e-cd96a5ae9d95.mock.pstmn.io")! //mock server
     }

     static let token = ""
 }

enum Endpoint: URLConvertible {
    func asURL() throws -> URL {
        return URL(string: "\(APIConstants.baseURL)\(path)")!
    }
    
    case signin
    case signup
    case uploadImage
    case createRequest
    case download
    
    private var path: String {
        switch self {
        case .signin:
            return "/api/users/signin/"
        case .signup:
            return "/api/users/signup/"
        case .uploadImage:
            return "/api/files/upload/images/"
        case .createRequest:
            return "/api/files/create/pptx/"
        case .download:
            return "/api/files/download/pptx/"
        }
    }
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
