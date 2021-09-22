//
//  NetworkManager.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/23.
//

import Foundation

struct NetworkManager {
    // 싱글톤 패턴
    static let shared = NetworkManager()
    
    func signIn(id: String, password: String){
        let url = APIConstants.
                let header: HTTPHeaders = [
                    "Content-Type":"application/json"
                ]
                let body: Parameters = [
                    "email": email,
                    "password":password
                ]
    }
}
