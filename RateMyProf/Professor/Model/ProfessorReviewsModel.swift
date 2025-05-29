//
//  ProfessorReviewsModel.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 23/01/25.
//


import Foundation

// MARK: - ProfessorReviewsModel
struct ProfessorReviewsModel: Codable {
    let status: Bool
    let message: String
    let feedbackData: [FeedbackData]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case feedbackData = "FeedbackData"
    }
}

// MARK: - FeedbackDatum
struct FeedbackData: Codable {
    let feedback, averageRating, postedAt, username: String
    let totalFeedbackCount: Int

    enum CodingKeys: String, CodingKey {
        case feedback = "Feedback"
        case averageRating = "AverageRating"
        case postedAt = "PostedAt"
        case username = "Username"
        case totalFeedbackCount = "TotalFeedbackCount"
    }
}
