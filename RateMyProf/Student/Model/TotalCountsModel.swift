//
//  TotalCountsModel.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 08/01/25.
//


import Foundation

// MARK: - TotalCountsModel
struct TotalCountsModel: Codable {
    let status: Bool
    let message: String
    let counts: Counts

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case counts = "Counts"
    }
}

// MARK: - Counts
struct Counts: Codable {
    let totalRatings, totalStudents, totalProfessors: String

    enum CodingKeys: String, CodingKey {
        case totalRatings = "TotalRatings"
        case totalStudents = "TotalStudents"
        case totalProfessors = "TotalProfessors"
    }
}