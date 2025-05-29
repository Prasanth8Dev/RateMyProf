//
//  RatingDistributionView.swift
//  RateMyProf
//
//  Created by SAIL on 16/12/24.
//

import SwiftUI

struct RatingDistributionView: View {
    @Binding var ratings: [Rating] // Use @Binding to allow updates

    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)
    
    var body: some View {
        VStack {
            ForEach(ratings, id: \.stars) { rating in
                HStack {
                    Text("\(rating.stars) star")
                    ZStack(alignment: .leading) {
                        Capsule()
                            .frame(width: 200, height: 10)
                            .foregroundColor(.gray)
                            .opacity(0.2)
                        
                        Capsule()
                            .frame(width: min(CGFloat(rating.percentage) * 2, 200), height: 10) // Limiting to 200 for maximum width
                            .foregroundColor(customColor)
                            .animation(.easeInOut, value: rating.percentage)
                    }
                    Text("\(Int(rating.percentage))%")
                        .frame(width: 50) // Adds space for percentage text
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct Rating {
    var stars: Int
    var percentage: Double
}

struct RatingDistributionView_Previews: PreviewProvider {
    @State static var previewRatings: [Rating] = [
        Rating(stars: 1, percentage: 10),
        Rating(stars: 2, percentage: 20),
        Rating(stars: 3, percentage: 40),
        Rating(stars: 4, percentage: 60),
        Rating(stars: 5, percentage: 80)
    ]

    static var previews: some View {
        RatingDistributionView(ratings: $previewRatings) // Pass the Binding to the @State property
            .previewLayout(.sizeThatFits) // Adjust the preview layout if needed
    }
}
