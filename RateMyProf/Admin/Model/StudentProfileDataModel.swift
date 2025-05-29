//
//  StudentProfileModel.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 30/01/25.
//


import Foundation

// MARK: - StudentProfileModel
struct StudentProfileDataModel: Codable {
    let status: Bool
    let message: String
    let data: [StudentDataModel]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - Datum
struct StudentDataModel: Codable {
    let studID: Int
    let firstName, lastName: String
    let regNo: Int
    let university, dept, email: String
    let phnNo: String
    let username, password, profilePic: String
    let isActive: Int

    enum CodingKeys: String, CodingKey {
        case studID = "StudID"
        case firstName = "FirstName"
        case lastName = "LastName"
        case regNo = "RegNo"
        case university = "University"
        case dept = "Dept"
        case email = "Email"
        case phnNo = "PhnNo"
        case username = "Username"
        case password = "Password"
        case profilePic = "ProfilePic"
        case isActive = "IsActive"
    }
}
