//
//  ProfessorManagement.swift
//  RateMyProf
//
//  Created by SAIL on 24/12/24.
//
import SwiftUI

struct ProfessorManagement: View {
    @State private var selectedCollege: String = ""
    @State private var selectedDepartment: String = ""
    @State private var isCollegeDropdownShown = false
    @State private var isDepartmentDropdownShown = false
    @State private var navigateToNextView = false

    let colleges = ["SSE", "SEC", "SCLAS"]
    let collegeDepartments: [String: [String]] = [
        "SSE": ["ECE", "CSE", "EEE"],
        "SEC": ["Mechanical", "AI & DS", "CSE"],
        "SCLAS": ["BCA", "BCOM", "MCA"]
    ]
    
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

                    Spacer()

                    Text("Professor Management")
                        .font(.system(size: 30))
                        .foregroundStyle(customColor)
                        .italic()
                        .padding(.bottom, 30)

                    Text("Select College:")
                        .font(.headline)
                        .foregroundColor(.black)

                    // College Dropdown
                    HStack {
                        Spacer()
                        TextField("Select College", text: $selectedCollege)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(true)
                            .frame(width: 200).border(Color.customColor)
                        Image(systemName: "chevron.down")
                            .onTapGesture {
                                isCollegeDropdownShown.toggle()
                                isDepartmentDropdownShown = false // Reset department dropdown
                                selectedDepartment = "" // Clear selected department when college changes
                            }
                        Spacer()
                    }
                    .padding(.vertical, 10)

                    if isCollegeDropdownShown {
                        HStack {
                            Spacer()
                            VStack {
                                ForEach(colleges, id: \ .self) { college in
                                    Button(action: {
                                        selectedCollege = college
                                        isCollegeDropdownShown = false
                                    }) {
                                        Text(college)
                                            .font(.subheadline)
                                            .padding(.vertical, 5)
                                    }
                                }
                            }
                            .frame(width: 200, height: 100)
                            .background(Color.white)
                            .cornerRadius(5)
                            Spacer()
                        }
                        .padding(.bottom, 10)
                    }

                    Text("Select Department:")
                        .font(.headline)
                        .foregroundColor(.black)

                    // Department Dropdown
                    HStack {
                        Spacer()
                        TextField("Select Department", text: $selectedDepartment)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(true)
                            .frame(width: 200).border(Color.customColor)
                        Image(systemName: "chevron.down")
                            .onTapGesture {
                                isDepartmentDropdownShown.toggle()
                            }
                        Spacer()
                    }
                    .padding(.vertical, 10)

                    if isDepartmentDropdownShown && !selectedCollege.isEmpty {
                        HStack {
                            Spacer()
                            VStack {
                                ForEach(collegeDepartments[selectedCollege] ?? [], id: \ .self) { department in
                                    Button(action: {
                                        selectedDepartment = department
                                        isDepartmentDropdownShown = false
                                    }) {
                                        Text(department)
                                            .font(.subheadline)
                                            .padding(.vertical, 5)
                                    }
                                }
                            }
                            .frame(width: 200, height: 100)
                            .background(Color.white)
                            .cornerRadius(5)
                            Spacer()
                        }
                        .padding(.bottom, 20)
                    } else if selectedCollege.isEmpty {
                        Text("Please select a college first")
                            .foregroundColor(.gray)
                    }

                    NavigationLink(destination: AdminProfessorList(selectedCollege: selectedCollege, selectedDept: selectedDepartment), isActive: $navigateToNextView) {
                        EmptyView()
                    }

                    Button(action: {
                        navigateToNextView.toggle()
                    }) {
                        Text("Next")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 30)
                            .background(Color.customColor)
                            .clipShape(Capsule())
                    }
                    .padding()
                    .disabled(selectedCollege.isEmpty || selectedDepartment.isEmpty) // Disable button if no college or department is selected
                    Spacer()
                }
            }
        }
    }
}

struct ProfessorManagement_Previews: PreviewProvider {
    static var previews: some View {
        ProfessorManagement()
    }
}
 
