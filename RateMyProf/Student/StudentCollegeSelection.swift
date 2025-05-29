//
//  StudentCollegeSelection.swift
//  RateMyProf
//
//  Created by SAIL on 17/12/24.
//
import SwiftUI

struct StudentCollegeSelection: View {
    @State private var selectedCollege = ""
    @State private var selectedDepartment = ""
    @State private var colleges = ["SCLAS", "SEC", "SSE"]
    @State private var departments: [String: [String]] = [
        "SCLAS": ["MCA", "BCA", "BSC"],
        "SEC": ["Mechanical", "AI & DS", "AI & ML"],
        "SSE": ["ECE", "CSE", "EEE"]
    ]

    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255) // Custom color for borders and text

    var body: some View {
//        NavigationStack {
            ZStack {
                // Background with circles as in ProfessorHomePage
                Color(UIColor.systemGray6).ignoresSafeArea() // Light gray background
                    .overlay(
                        ZStack {
                            Circle()
                                .fill(Color(UIColor.systemBlue).opacity(0.1)) // Light blue circle overlay
                                .frame(width: 300, height: 300)
                                .offset(x: -100, y: -200)
                                .blur(radius: 50)

                            Circle()
                                .fill(Color(UIColor.systemGray3).opacity(0.1)) // Light gray circle overlay
                                .frame(width: 200, height: 200)
                                .offset(x: 150, y: 250)
                                .blur(radius: 40)
                        }
                    )

                VStack {
                    // Header Section: Title alignment and styling
                    HStack {
                        Spacer() // Push title to the center
                        Text("RateMyProf.")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        Spacer() // Push title to the center
                        NavigationLink(destination: StudentMyProfile()) {
                            Image(.circle3)
                                .overlay(Image(.image5))
                                .padding(10)
                                .background(Circle().fill(Color.white).shadow(radius: 5))
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    VStack(alignment: .center) {
                        Text("Select your college:")
                            .font(.headline)
                            .padding(.top, 20)

                        // College Selection Menu
                        Menu {
                            ForEach(colleges, id: \.self) { college in
                                Button(college) {
                                    selectedCollege = college
                                    selectedDepartment = ""
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedCollege.isEmpty ? "Select" : selectedCollege)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(customColor, lineWidth: 1)
                            )
                        }

                        Text("Select your department:")
                            .font(.headline)
                            .padding(.top, 20)
                        if !selectedCollege.isEmpty {
                            // Department Selection Menu
                            Menu {
                                ForEach(departments[selectedCollege] ?? [], id: \.self) { department in
                                    Button(department) {
                                        selectedDepartment = department
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedDepartment.isEmpty ? "Select" : selectedDepartment)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(customColor, lineWidth: 1)
                                )
                            }
                        } else {
                            Text("Please select a college first")
                                .foregroundColor(.black)
                        }

                        NavigationLink(destination: StudentRatingList(selectedCollege: selectedCollege, selectedDept: selectedDepartment)) {
                            Text("Next")
                                .font(.title3)
                                .padding()
                                .frame(width: 100)
                                .background(customColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(selectedCollege.isEmpty || selectedDepartment.isEmpty)
                        .padding(.leading, 200)
                        .padding()

                        Text("Just one step ahead...")
                            .font(.title)
                            .foregroundStyle(.black)
                            .italic()
                            .padding(.top, 10)
                            .padding(.top, 50)
                    }
                    .frame(width: 300, alignment: .center)
                    .padding(.top, 60)

                    Spacer()
                }
            }
//        }
    }
}

#Preview {
    StudentCollegeSelection()
}
