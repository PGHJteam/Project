 import Foundation
import Alamofire

 struct APIConstants {
     // MARK: - Start Endpoint
     static var baseURL: URL {
//         return URL(string: "http://dev-pghj-lb-1661151695.ap-northeast-2.elb.amazonaws.com:8000")!
         
         return URL(string: "https://d9c53cef-5902-4d3f-843e-cd96a5ae9d95.mock.pstmn.io")! //mock server
     }
 }

enum Endpoint: URLConvertible {
    func asURL() throws -> URL {
        return URL(string: "\(APIConstants.baseURL)\(path)")!
    }
    
    case signin
    case signup
    case signout
    case tokenRefresh
    case uploadImage
    case createRequest
    case download
    case history
    
    private var path: String {
        switch self {
        case .signin:
            return "/api/users/signin/"
        case .signup:
            return "/api/users/signup/"
        case .signout:
            return "/api/users/signout/"
        case .tokenRefresh:
            return "/api/users/token/refresh/"
        case .uploadImage:
            return "/api/files/upload/images/"
        case .createRequest:
            return "/api/files/create/pptx/"
        case .download:
            return "/api/files/download/pptx/"
        case .history:
            return "/api/users/history/"
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
