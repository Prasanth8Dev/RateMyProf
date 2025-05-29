//
//  FeedBackResponseModel.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 25/01/25.
//


import Foundation

// MARK: - FeedBackResponseModel
struct FeedBackResponseModel: Codable {
    let status: Bool
    let message: String

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
    }
}
