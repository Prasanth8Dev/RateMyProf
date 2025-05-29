//
//  ProfessorLoginResponse.swift
//  RateMyProf
//
//  Created by Harini S on 18/01/25.
//


import Foundation

// MARK: - ProfessorLoginResponse
struct ProfessorLoginResponse: Codable {
    let status: Bool
    let message: String
    let data: [Datum]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let profID: Int
    let firstName, lastName, email, dept: String
    let university: String
    let phnNo: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case profID = "ProfID"
        case firstName = "FirstName"
        case lastName = "LastName"
        case email = "Email"
        case dept = "Dept"
        case university = "University"
        case phnNo = "PhnNo"
        case username = "Username"
    }
}
