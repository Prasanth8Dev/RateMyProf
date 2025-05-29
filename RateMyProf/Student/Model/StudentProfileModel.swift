import Foundation

// MARK: - StudentProfileModel
struct StudentProfileModel: Codable {
    let status: Bool
    let message: String
    let profileData: [ProfileDatum]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case profileData = "ProfileData"
    }
}

// MARK: - ProfileDatum
struct ProfileDatum: Codable {
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
