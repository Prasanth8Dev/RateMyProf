//
//  RatingStarImage.swift
//  RateMyProf
//
//  Created by SAIL on 16/12/24.
//

import SwiftUI

struct RatingStarImage: View {
    @State var rating: Double
    @State var selectedOption: Int = 0

    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Button(action: {
                    rating = Double(index)
                    selectedOption = 0
                }) {
                    Image(systemName: rating >= Double(index) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.system(size: 30)) // This changes the size of the star directly
                }
                .buttonStyle(PlainButtonStyle()) // Avoid button style changes like highlighting
            }
        }
    }
}

#Preview {
    RatingStarImage(rating: 3.3)
}
