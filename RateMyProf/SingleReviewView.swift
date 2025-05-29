//
//  SingleReviewView.swift
//  RateMyProf
//
//  Created by SAIL on 16/12/24.
//
import SwiftUI

struct SingleReviewView: View {
    var review: FeedbackData

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 200)
            .overlay {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Image(systemName: "person.circle")
                            .font(.largeTitle)
                        
                        VStack(alignment: .leading) {
                            Text(review.username)
                                .font(.title2)
                            Text(review.postedAt)
                                .font(.footnote)
                                .foregroundColor(.secondary).frame(width: 120,alignment: .leading)
                        }
                       
                        RatingStarImage(rating: Double(review.averageRating) ?? 0.0)
                            .font(.footnote)
                            .scaleEffect(0.7).frame(width: 150)
                    }
                    Text(review.feedback)
                    .font(.body)
                    .minimumScaleFactor(0.7)
                    
                }
            }
    }
}

struct Review {
    var studentName: String
    var rating: Int
    var date: String
    var reviewText: String
}

#Preview {
    SingleReviewView(review: FeedbackData(feedback:  "This is a feedback comment", averageRating: "3", postedAt: "12/10/2024", username: "Prasanth", totalFeedbackCount: 4))
}
