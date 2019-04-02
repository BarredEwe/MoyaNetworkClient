//
//  NewsAPI.swift
//  MoyaNetworkClient_Example
//
//  Created by Grishutin Maksim on 02/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Moya
import MoyaNetworkClient

enum NewsAPI {
    case randomFacts
    case catFacts
}

extension NewsAPI: MultiTargetType {

    var baseURL: URL { return URL(string: "https://cat-fact.herokuapp.com")! }

    var path: String {
        switch self {
        case .randomFacts: return "/facts/random&amount=20"
        case .catFacts: return "/facts?animal_type=cat"
        }
    }

    var method: Moya.Method {
        switch self {
        case .randomFacts, .catFacts: return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .randomFacts, .catFacts: return
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
        case .randomFacts, .catFacts: return .requestPlain
        }
    }

    var headers: [String : String]? {
        return nil
    }
}

