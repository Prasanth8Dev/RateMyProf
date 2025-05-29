//
//  LoginResponse.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 07/01/25.
//


import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let status: Bool
    let message: String
    let data: [LoginData]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - Datum
struct LoginData: Codable {
    let studID: Int
    let firstName, lastName: String
    let regNo: Int
    let university, dept, email: String
    let phnNo: String
    let username: String
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
        case isActive = "isActive"
    }
}
