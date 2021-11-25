////
////  NetworkManager.swift
////  PGHJapp
////
////  Created by 김지선 on 2021/09/17.
////
//
//import Foundation
//import Alamofire
//
//class APIClient {
//    static func login(id: String, password: String) -> Bool {
//        var isSuccess: Bool = false
//        print("user", id, password)
//        AF.request(APIRouter.signin(id: id, password: password))
//            .responseDecodable(of: Token.self) { response in
//                switch response.result {
//                case .success(let token):
//                    UserDefaults.standard.set(token.refresh, forKey: "refreshToken")
//                    UserDefaults.standard.set(token.access, forKey: "accessToken")
//                    isSuccess = true
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        return isSuccess
//    }
//    
//    static func uploadImage(imageData: Data) {
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(imageData, withName: "imageFile", fileName: "image\(index)")
//        }, to: APIRouter.uploadImage)
//        
//    }
//    
////    static func test(id: String, password: String, completion: @escaping (Result<User, AFError>) -> Void){
////        AF.request(APIRouter.signin(id: id, password: password))
////            .responseDecodable { (response: DataResponse<User, AFError>) in
////                completion(response.result)
////            }
////    }
////    typealias onSuccess<T> = ((T) -> Void)
////    typealias onFailure = ((_ error: Error) -> Void)
//    
////    static func request<T>(_ object: T.Type,
////                           router: APIRouter.,
////                                  success: @escaping onSuccess<T>,
////                                  failure: @escaping onFailure) where T: Decodable {
////        AF.request(router)
////            .validate(statusCode: 200..<500)
////            .responseDecodable(of: object) { response in
////                switch response.result {
////                case .success:
////                    guard let decodedData = response.value else { return }
////                    success(decodedData)
////                case .failure(let err):
////                    failure(err)
////                }
////        }
////    }
//}
