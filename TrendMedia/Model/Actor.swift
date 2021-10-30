//
//  Actor.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/16.
//

import Foundation


struct Actor: Codable {
    var id: Int
    var name: String
    var image: String
    var character: String
    var credit_id: String
}

struct Crew {
    var id: Int
    var name: String
    var profile_path: String
    var job: String
    var credit_id: String
}
