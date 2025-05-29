//
//  GetProfessorData.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 22/01/25.
//


import Foundation

// MARK: - GetProfessorData
struct GetProfessorData: Codable {
    let status: Bool
    let message: String
    let profileData: [ProfessorData]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case profileData = "ProfileData"
    }
}

// MARK: - ProfileDatum
struct ProfessorData: Codable {
    let profID, firstName, lastName, title: String
    let university, dept, email, phnNo: String
    let username, password, profilePic: String
    let bio: String

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
        case bio = "Bio"
    }
}
