//
//  BlockAndUnBlockModel.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 30/01/25.
//


import Foundation

// MARK: - BlockAndUnBlockModel
struct BlockAndUnBlockModel: Codable {
    let status: Bool
    let message: String

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
    }
}