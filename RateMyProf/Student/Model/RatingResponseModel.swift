//
//  RatingResponseModel.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 25/01/25.
//


import Foundation

// MARK: - RatingResponseModel
struct RatingResponseModel: Codable {
    let status: Bool
    let message: String
    let ratingID: Int

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case ratingID = "RatingID"
    }
}

