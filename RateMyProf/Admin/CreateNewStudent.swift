//
//  CreateNewStudent.swift
//  RateMyProf
//
//  Created by SAIL on 24/12/24.
//

import SwiftUI

struct CreateNewStudent: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var regNo: String = ""
    @State private var selectedDepartment: String = ""
    @State private var selectedUniversity: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var isDepartmentDropdownShown = false
    @State private var isUniversityDropdownShown = false
    @State private var navigateToNextView = false

    let universities = ["SSE", "SEC", "SCLAS"]
    let universityDepartments: [String: [String]] = [
        "SSE": ["ECE", "CSE", "EEE"],
        "SEC": ["Mechanical", "AI & DS", "CSE"],
        "SCLAS": ["BCA", "BCOM", "MCA"]
    ]

    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
        NavigationView {
            ZStack {
                // Subtle background with color and circle overlays
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

                ScrollView {
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

                        // Title Section
                        Text("Create New Student")
                            .font(.system(size: 30))
                            .italic()
                            .foregroundStyle(customColor)
                            .padding(.bottom, 20)

                        VStack(alignment: .leading) {
                            Text("First Name:")
                                .font(.headline)
                                .foregroundColor(.customColor)
                            TextField("Enter First Name", text: $firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 20)

                            Text("Last Name:")
                                .font(.headline)
                                .foregroundColor(.customColor)
                            TextField("Enter Last Name", text: $lastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 20)

                            Text("Reg.No:")
                                .font(.headline)
                                .foregroundColor(.customColor)
                            TextField("Enter Reg.No", text: $regNo)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 20)

                            Text("University:")
                                .font(.headline)
                                .foregroundColor(.customColor)
                            HStack {
                                TextField("Select University", text: $selectedUniversity)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(true)
                                Image(systemName: "chevron.down")
                                    .onTapGesture {
                                        isUniversityDropdownShown.toggle()
                                    }
                            }
                            .padding(.bottom, 20)

                            if isUniversityDropdownShown {
                                VStack {
                                    ForEach(universities, id: \ .self) { university in
                                        Button(action: {
                                            selectedUniversity = university
                                            isUniversityDropdownShown = false
                                        }) {
                                            Text(university)
                                                .padding(.vertical, 10)
                                        }
                                    }
                                }
                                .frame(maxHeight: .infinity)
                                .background(Color.white)
                                .cornerRadius(5)
                                .padding(.bottom, 20)
                            }

                            Text("Department:")
                                .font(.headline)
                                .foregroundColor(.customColor)
                            HStack {
                                TextField("Select Department", text: $selectedDepartment)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(true)
                                Image(systemName: "chevron.down")
                                    .onTapGesture {
                                        isDepartmentDropdownShown.toggle()
                                    }
                            }
                            .padding(.bottom, 20)

                            if isDepartmentDropdownShown {
                                VStack {
                                    ForEach(universityDepartments[selectedUniversity] ?? [], id: \ .self) { department in
                                        Button(action: {
                                            selectedDepartment = department
                                            isDepartmentDropdownShown = false
                                        }) {
                                            Text(department)
                                                .padding(.vertical, 10)
                                        }
                                    }
                                }
                                .frame(maxHeight: .infinity)
                                .background(Color.white)
                                .cornerRadius(5)
                                .padding(.bottom, 20)
                            }

                            Text("Email:")
                                .font(.headline)
                                .foregroundColor(.customColor)
                            TextField("Enter Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 20)

                            Text("Phone Number:")
                                .font(.headline)
                                .foregroundColor(.customColor)
                            TextField("Enter Phone Number", text: $phoneNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 20)

                        NavigationLink(destination: StudentUsernamePassword(
                                         firstName: firstName,
                                         lastName: lastName,
                                         regNo: regNo,
                                         selectedUniversity: selectedUniversity,
                                         selectedDepartment: selectedDepartment,
                                         email: email,
                                         phoneNumber: phoneNumber
                                     ), isActive: $navigateToNextView) {
                                         EmptyView()
                                     }
                        Button(action: {
                            // Navigate only if all fields except Last Name are filled
                            if !firstName.isEmpty && !regNo.isEmpty && !selectedUniversity.isEmpty && !selectedDepartment.isEmpty && !email.isEmpty && !phoneNumber.isEmpty {
                                navigateToNextView.toggle()
                            }
                        }) {
                            Text("Next")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 30)
                                .background(Color.customColor)
                                .clipShape(Capsule())
                        }
                        .padding()
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    CreateNewStudent()
}

