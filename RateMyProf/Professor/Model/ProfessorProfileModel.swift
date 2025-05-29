//
//  ProfessorProfileModel.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 31/01/25.
//


import Foundation

// MARK: - ProfessorProfileModel
struct ProfessorProfileModel: Codable {
    let status: Bool
    let message: String
    let profileData: [ProfessorProfileDatum]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case profileData = "ProfileData"
    }
}

// MARK: - ProfileDatum
struct ProfessorProfileDatum: Codable {
    let username, title, university, dept: String
       let profilePic, bio: String
       let profID: Int

       enum CodingKeys: String, CodingKey {
           case username = "Username"
           case title = "Title"
           case university = "University"
           case dept = "Dept"
           case profilePic = "ProfilePic"
           case bio = "Bio"
           case profID = "ProfID"
       }
   }
