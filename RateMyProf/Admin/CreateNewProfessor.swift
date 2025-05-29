//
//  CreateNewProfessor.swift
//  RateMyProf
//
//  Created by SAIL on 24/12/24.
//


import SwiftUI

struct CreateNewProfessor: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var selectedTitle: String = ""
    @State private var selectedDepartment: String = ""
    @State private var selectedUniversity: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var isTitleDropdownShown = false
    @State private var isDepartmentDropdownShown = false
    @State private var isUniversityDropdownShown = false
    @State private var showNextView = false

    let titles = ["Professor", "Assistant Professor", "Associate Professor"]
    let universities = ["SSE", "SEC", "SCLAS"]
    let universityDepartments: [String: [String]] = [
        "SSE": ["ECE", "CSE", "EEE"],
        "SEC": ["Mechanical", "AI & DS", "CSE"],
        "SCLAS": ["BCA", "BCOM", "MCA"]
    ]

    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255) // Custom border and text color

    var body: some View {
//        NavigationStack {
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
                        Text("Create New Professor")
                            .font(.system(size: 30))
                            .italic()
                            .foregroundStyle(customColor)
                            .padding(.bottom, 20)

                        VStack(alignment: .leading) {
                            fieldSection(title: "First Name:", placeholder: "Enter First Name", text: $firstName)
                            fieldSection(title: "Last Name:", placeholder: "Enter Last Name", text: $lastName)

                            dropdownSection(title: "Title:", placeholder: "Select Title", isDropdownShown: $isTitleDropdownShown, selectedValue: $selectedTitle, options: titles)

                            dropdownSection(title: "University:", placeholder: "Select University", isDropdownShown: $isUniversityDropdownShown, selectedValue: $selectedUniversity, options: universities)

                            dropdownSection(title: "Department:", placeholder: "Select Department", isDropdownShown: $isDepartmentDropdownShown, selectedValue: $selectedDepartment, options: universityDepartments[selectedUniversity] ?? [])

                            fieldSection(title: "Email:", placeholder: "Enter Email", text: $email)
                            fieldSection(title: "Phone Number:", placeholder: "Enter Phone Number", text: $phoneNumber)
                        }
                        .padding(.horizontal, 20)

                        // Next Button
                        Button(action: {
                            if allFieldsFilledExceptLastName() {
                                showNextView = true
                            }
                        }) {
                            Text("Next")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 30)
                                .background(customColor)
                                .clipShape(Capsule())
                        }
                        .padding()
                        .background(
                            NavigationLink(destination: ProfessorUsernamePassword(firstName: $firstName,
                                                                                   lastName: $lastName,
                                                                                   selectedTitle: $selectedTitle,
                                                                                   selectedDepartment: $selectedDepartment,
                                                                                   selectedUniversity: $selectedUniversity,
                                                                                   email: $email,
                                                                                   phoneNumber: $phoneNumber), isActive: $showNextView) {
                                EmptyView()
                            }
                        )
                    }
                }
            }
//        }
    }

    // Section for text fields
    private func fieldSection(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(customColor)
            TextField(placeholder, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
        }
    }

    // Section for dropdown fields
    private func dropdownSection(title: String, placeholder: String, isDropdownShown: Binding<Bool>, selectedValue: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(customColor)
            HStack {
                TextField(placeholder, text: selectedValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(true)
                Image(systemName: "chevron.down")
                    .onTapGesture {
                        isDropdownShown.wrappedValue.toggle()
                    }
            }
            .padding(.bottom, 20)

            if isDropdownShown.wrappedValue {
                VStack {
                    ForEach(options, id: \ .self) { option in
                        Button(action: {
                            selectedValue.wrappedValue = option
                            isDropdownShown.wrappedValue = false
                        }) {
                            Text(option)
                                .padding(.vertical, 10)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(5)
                .padding(.bottom, 20)
            }
        }
    }

    // Check if all required fields are filled
    func allFieldsFilledExceptLastName() -> Bool {
        return !firstName.isEmpty && !selectedTitle.isEmpty && !selectedDepartment.isEmpty &&
               !selectedUniversity.isEmpty && !email.isEmpty && !phoneNumber.isEmpty
    }
}

#Preview {
    CreateNewProfessor()
}
