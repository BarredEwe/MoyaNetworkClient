//
//  NewsAPI.swift
//  MoyaNetworkClient_Example
//
//  Created by Grishutin Maksim on 02/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Moya
import MoyaNC

enum NewsAPI {
    case dogFacts
    case catFacts
}

extension NewsAPI: MoyaTargetType {

    var baseURL: URL { return URL(string: "https://cat-fact.herokuapp.com")! }

    var route: Route {
        switch self {
        case .dogFacts, .catFacts: return .get("/facts/random")
        }
    }

    var sampleData: Data {
        switch self {
        case .dogFacts, .catFacts: return
            """
                [{
                    "_id": "591f9894d369931519ce358f",
                    "__v": 0,
                    "text": "A female cat will be pregnant for approximately 9 weeks - between 62 and 65 days from conception to delivery.",
                    "updatedAt": "2018-01-04T01:10:54.673Z",
                    "deleted": false,
                    "source": "api",
                    "used": false
                },
                {
                    "_id": "591f9854c5cbe314f7a7ad34",
                    "__v": 0,
                    "text": "It has been scientifically proven that stroking a cat can lower one's blood pressure.",
                    "updatedAt": "2018-01-04T01:10:54.673Z",
                    "deleted": false,
                    "source": "api",
                    "used": false
            }]
        """.data(using: .utf8)!
        }
    }

    var task: Task {
        switch self {
        case .catFacts: return .requestParameters(parameters: ["animal_type": "cat", "amount": 20], encoding: URLEncoding.default)
        case .dogFacts: return .requestParameters(parameters: ["animal_type": "dog", "amount": 20], encoding: URLEncoding.default)
        }
    }

    //var cachePolicy: MoyaCachePolicy {
    //    switch self {
    //    case .catFacts: return .returnCacheDataElseLoad
    //    case .dogFacts: return .returnCacheDataElseLoad
    //    }
    //}
}
