//
//  CustomError.swift
//  MoyaNetworkClient_Example
//
//  Created by Grishutin Maksim on 02/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

public struct MoyaNCError: Error, Codable {
    let error: String
}
