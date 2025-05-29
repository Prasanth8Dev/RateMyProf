//
//  ProfessorCreatedMessage.swift
//  RateMyProf
//
//  Created by SAIL on 24/12/24.
//

import SwiftUI

struct ProfessorCreatedMessage: View {
    @State private var showNextView = false
    

    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
//        NavigationStack {
            ZStack {
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
                    // Header Section
                    HStack {
                        Spacer()
                        Text("RateMyProf.")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)

                    Spacer()

                    Text("Create New Professor")
                        .font(.system(size: 30))
                        .italic()
                        .foregroundStyle(customColor)
                        .padding(.bottom, 20)

                    // Rectangle Box
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .stroke(Color.customColor, lineWidth: 2)
                        .frame(width: 250, height: 100)
                        .overlay(
                            Text("New Professor's Profile has been created.")
                                .font(.headline)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 20)
                        )
                        .padding(.bottom, 20)

                    // Go to Home Button
                    Button(action: {
                        showNextView = true
                    }) {
                        Text("Go to Home")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 40)
                            .background(Color.customColor)
                            .clipShape(Capsule())
                    }
                    .padding()
                    .navigationDestination(isPresented: $showNextView) {
                        AdminHomePage()
                    }

                    Spacer()
                }
            }
//        }
    }
}

#Preview {
    ProfessorCreatedMessage()
}
