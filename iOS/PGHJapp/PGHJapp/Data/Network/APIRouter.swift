//
//  Endpoint.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/17.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible, URLConvertible {
    case signin(id: String, password: String)
//    case signup(id: String, password: String, name: String, email: String)
    case uploadImage
    case test(id: String, password: String)
    
    private var method: HTTPMethod {
        switch self {
        case .signin, .uploadImage, .test:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .signin:
            return "/api/users/signin/"
        case .uploadImage:
            return "/uploadImages/"
        case .test:
            return "/default/SwiftCamp/"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .uploadImage:
            return nil // 변경 필요
        case .signin(let id, let password), .test(let id, let password):
            return [
                "user_id": id,
                "password": password
            ]
        }
    }
    
    var encoding: ParameterEncoding {
            return JSONEncoding.default
    }
    
    func asURL() throws -> URL {
        return APIConstants.baseURL.appendingPathComponent(path)
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = APIConstants.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.method = method
        
        // Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(APIConstants.token, forHTTPHeaderField: HTTPHeaderField.xAuthToken.rawValue)
        
        // parameters
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
    
}
