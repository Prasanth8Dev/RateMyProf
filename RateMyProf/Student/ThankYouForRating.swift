//
//  ThankYouForRating.swift
//  RateMyProf
//
//  Created by SAIL on 23/12/24.

import SwiftUI

struct ThankYouForRating: View {
    var body: some View {
//        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background with circles and blur effect
                    Color(UIColor.systemGray6).ignoresSafeArea()
                        .overlay(
                            ZStack {
                                Circle()
                                    .fill(Color(UIColor.systemBlue).opacity(0.1))
                                    .frame(width: 300, height: 300)
                                    .offset(x: -100, y: -200)
                                    .blur(radius: 50)

                                Circle()
                                    .fill(Color(UIColor.systemGray3).opacity(0.1))
                                    .frame(width: 200, height: 200)
                                    .offset(x: 150, y: 250)
                                    .blur(radius: 40)
                            }
                        )

                    VStack {
                        // Header with title and profile icon
                        HStack {
                            Spacer()
                            Text("RateMyProf.")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            Spacer()
                            NavigationLink(destination: StudentMyProfile()) {
                                Image(.circle3)
                                    .overlay(Image(.image5))
                                    .padding(10)
                                    .background(Circle().fill(Color.white).shadow(radius: 5))
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal)

                        Spacer()

                        // Thank you message
                        Text("Thank You For Rating!!!")
                            .font(.system(size: 40))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding()

                        // Navigation link to home page
                        NavigationLink(destination: StudentHomePage()) {
                            Text("Go to Home")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 30)
                                .background(Color.customColor)
                                .clipShape(Capsule())
                        }
                        .padding()

                        Spacer()
                    }
                }
            }
            .navigationBarBackButtonHidden(true) // Hide default back button
//        }
    }
}

#Preview {
    ThankYouForRating()
}

