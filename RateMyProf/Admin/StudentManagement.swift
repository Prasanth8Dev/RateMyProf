//
//  StudentManagement.swift
//  RateMyProf
//
//  Created by SAIL on 26/12/24.
//
import SwiftUI

struct StudentManagement: View {
    @State private var registrationNumber: String = ""
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
        NavigationView {
            ZStack {
                // Subtle gradient background and overlay circles
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
                    // Updated title style
                    HStack {
                        Spacer()
                        Text("RateMyProf.")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)

                    Text("STUDENT MANAGEMENT")
                        .font(.title)
                        .foregroundStyle(customColor)
                        .italic()
                        .padding(.top, 20)
                    Spacer()
                    Text("Enter Registration Number:")
                        .font(.headline)
                    TextField("Enter Registration Number", text: $registrationNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.customColor, lineWidth: 1))
                        .padding(.vertical, 10)
                    NavigationLink(destination: AdminStudentProfile(studId: registrationNumber)) {
                        Text("Next")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 30)
                            .background(Color(customColor))
                            .clipShape(Capsule())
                    }
                    .padding()
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct StudentManagement_Previews: PreviewProvider {
    static var previews: some View {
        StudentManagement()
    }
}
