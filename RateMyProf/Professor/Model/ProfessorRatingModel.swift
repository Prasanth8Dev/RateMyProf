import Foundation

// MARK: - ProfessorRatingModel
struct ProfessorRatingModel: Codable {
    let status: Bool
    let message: String
    let ratingData: RatingData

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case ratingData = "RatingData"
    }
}

// MARK: - RatingData
struct RatingData: Codable {
    let overallRatingsCount: Int
    let averageRatings: String
    let starsPercentage: StarsPercentage

    enum CodingKeys: String, CodingKey {
        case overallRatingsCount = "OverallRatingsCount"
        case averageRatings = "AverageRatings"
        case starsPercentage = "StarsPercentage"
    }
}

// MARK: - StarsPercentage
struct StarsPercentage: Codable {
    let oneStar, twoStar, threeStar, fourStar, fiveStar: String

    enum CodingKeys: String, CodingKey {
        case oneStar = "OneStar"
        case twoStar = "TwoStar"
        case threeStar = "ThreeStar"
        case fourStar = "FourStar"
        case fiveStar = "FiveStar"
    }

    // Convert to an array of Rating percentages
    func asRatingsArray() -> [Double] {
        let percentages = [oneStar, twoStar, threeStar, fourStar, fiveStar]
        return percentages.compactMap { Double($0) }
    }
}
