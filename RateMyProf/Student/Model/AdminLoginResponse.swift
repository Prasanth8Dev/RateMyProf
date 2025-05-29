//
//  AdminLoginResponse.swift
//  RateMyProf
//
//  Created by Harini S on 20/01/25.
//

import Foundation

// MARK: - AdminLoginResponse
struct AdminLoginResponse: Codable {
    let status: Bool
    let message: String
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let adminID: Int

    enum CodingKeys: String, CodingKey {
        case adminID = "AdminID"
    }
}

