//
//  AdminProfessorView.swift
//  RateMyProf
//
//  Created by SAIL on 26/12/24.
//
import SwiftUI

struct AdminProfessorView: View {
    var professor: ProfessorData
    @Environment(\.dismiss) var dismiss

    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
//        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background with circle overlays matching AdminStudentProfile design
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
                        // Header with title
                        HStack {
                            Spacer()
                            Text("RateMyProf.")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.horizontal)

                        Spacer()

                        ScrollView {
                            VStack(spacing: 20) {
                                // Profile Image Card
                                VStack {
                                    if let imageURL = URL(string: APIService.baseURL + professor.profilePic) {
                                        AsyncImage(url: imageURL) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 120, height: 120)
                                        }
                                    }
                                    Text(professor.firstName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.top, 10)
                                    Text(professor.title)
                                        .font(.subheadline)
                                        .foregroundColor(customColor)
                                        .padding(.bottom, 20)
                                }
                                .frame(maxWidth: geometry.size.width * 0.9)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .padding(.top, 70)

                                // Information Card for Department and College
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Text("DEPARTMENT:")
                                            .font(.headline)
                                        Spacer()
                                        Text(professor.dept)
                                            .font(.body)
                                    }
                                    .padding(.horizontal)

                                    HStack(alignment: .top) {
                                        Text("COLLEGE:")
                                            .font(.headline)
                                        Spacer()
                                        Text(professor.university)
                                            .font(.body)
                                    }
                                    .padding(.horizontal)

                                    HStack {
                                        Text("Reg.No:")
                                            .font(.headline)
                                        Spacer()
                                        Text(professor.profID)
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(maxWidth: geometry.size.width * 0.9)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)

                                // Bio Section with updated design
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("BIO:")
                                        .font(.headline)
                                        .padding(.bottom, 5)
                                    Text(professor.bio)
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                        .padding()
                                        .frame(maxWidth: geometry.size.width * 0.9)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(radius: 5)
                                        .padding(.horizontal, 10) // Add padding to prevent touching the edges
                                }
                                .padding(.top, 20)

                                Spacer()

                                // Action Buttons for Ratings and Reviews
                                VStack(spacing: 15) {
                                    NavigationLink(destination: ProfessorRatings(professorId: professor.profID)) {
                                        Text("Ratings")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 200, height: 50)
                                            .background(customColor)
                                            .clipShape(Capsule())
                                            .shadow(radius: 5)
                                    }

                                    NavigationLink(destination: ProfessorReviews(professorId: professor.profID)) {
                                        Text("Reviews")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 200, height: 50)
                                            .background(customColor)
                                            .clipShape(Capsule())
                                            .shadow(radius: 5)
                                    }
                                }
                                .padding(.top, 20)
                            }
                            .padding(.bottom, 30)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    }
                }
            }
//        }
    }
}

struct AdminProfessorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let professor = ProfessorData(profID: "12354", firstName: "Bijohn", lastName: "S", title: "iOS Developer", university: "SSE", dept: "CSE", email: "bj@gmail.com", phnNo: "984521575", username: "Prasanth", password: "", profilePic: "", bio: "Hi, I'm Dr. John, an Associate Professor of Computer Science at Saveetha University. I'm passionate about teaching and research, with a focus on AI, machine learning, and data science. Outside of academia, I'm always up for a conversation about tech, education, or life!")
            AdminProfessorView(professor: professor)
        }
    }
}

