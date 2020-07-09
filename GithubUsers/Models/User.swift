//
//  User.swift
//  GithubUsers
//
//  Created by dearwolves on 7/9/20.
//  Copyright © 2020 dearwolves. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int
    var login: String
    var avatar_url: String
    var note: String?
    
}
