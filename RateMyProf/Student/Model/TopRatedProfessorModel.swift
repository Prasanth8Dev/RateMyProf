//
//  TopRatedProfessorModel.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 08/01/25.
//


import Foundation

// MARK: - TopRatedProfessorModel
struct TopRatedProfessorModel: Codable {
    let status: Bool
    let message: String
    let topProfessor: TopProfessor
    let professorDetails: ProfessorDetails

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case topProfessor = "TopProfessor"
        case professorDetails = "ProfessorDetails"
    }
}

// MARK: - ProfessorDetails
struct ProfessorDetails: Codable {
    let profID: Int
    let firstName, lastName, title, university: String
    let dept, email: String
    let phnNo: String
    let username, password, profilePic: String

    enum CodingKeys: String, CodingKey {
        case profID = "ProfID"
        case firstName = "FirstName"
        case lastName = "LastName"
        case title = "Title"
        case university = "University"
        case dept = "Dept"
        case email = "Email"
        case phnNo = "PhnNo"
        case username = "Username"
        case password = "Password"
        case profilePic = "ProfilePic"
    }
}

// MARK: - TopProfessor
struct TopProfessor: Codable {
    let profID: Int
    let averageRating: String

    enum CodingKeys: String, CodingKey {
        case profID = "ProfID"
        case averageRating = "AverageRating"
    }
}
