//
//  Fact.swift
//  MoyaNetworkClient_Example
//
//  Created by Grishutin Maksim on 02/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct Fact: Codable {
    let id: String
    let text: String?
    let updatedAt: String?
    let deleted: Bool?
    let source: String?
    let used: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text, updatedAt, deleted, source, used
    }
}
