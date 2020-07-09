//
//  UserRestService.swift
//  GithubUsers
//
//  Created by dearwolves on 7/9/20.
//  Copyright © 2020 dearwolves. All rights reserved.
//

import Foundation

class UserRestService {
    func getUsers(since: Int, completion: @escaping ([User]) -> ()) {
        let urlString = "https://api.github.com/users?since=" + String(since)
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, rest, err in
                if let data = data {
                    let user = try! JSONDecoder().decode([User].self, from: data)
                    completion(user)
                }
            }.resume()
        }
        
        
    }
}
