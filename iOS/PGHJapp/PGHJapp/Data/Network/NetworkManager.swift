//
//  NetworkManager.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/17.
//

import Foundation
import Alamofire

class NetworkManager {
    // url을 전달받으면 request 보내고 response를 completion으로 받는 함수 구현
    func getBasicData() {
        AF.request(Endpoint.URL,
                   method: .get,
                   parameters: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { data in
                //data 처리
            }
    }
    func postImageTest(image: UIImage){
        
    }
}
