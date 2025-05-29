//
//  SingleAdminProfessor.swift
//  RateMyProf
//
//  Created by SAIL on 26/12/24.
//

import SwiftUI

struct SingleAdminProfessor: View {
    let professor: ProfessorData
    @State private var navigateToNextView = false
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
//        NavigationStack {
            VStack {
                Button(action: {
                    navigateToNextView.toggle()
                }) {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .border(customColor)
                        .frame(width:100, height: 150)
                        .overlay{
                            VStack {
                                if let imageURL = URL(string: APIService.baseURL+professor.profilePic) {
                                    AsyncImage(url: imageURL) { image in
                                        image .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 120)
                                            .cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                   }
                                Text(professor.firstName)
                                    .font(.headline)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 90)
                                    .background(Color(customColor))
                            }
                        }
                }
                .navigationDestination(isPresented: $navigateToNextView) {
                    AdminProfessorView(professor:professor)
                }
            }
//        }
    }
}

struct SingleAdminProfessor_Previews: PreviewProvider {
    static var previews: some View {
        let professor = ProfessorData(profID: "12354", firstName: "Bijohn", lastName: "S", title: "iOS Developer", university: "SSE", dept: "CSE", email: "bj@gmail.com", phnNo: "984521575", username: "Prasanth", password: "", profilePic: "", bio: "Hi, I'm Dr. John, an Associate Professor of Computer Science at Saveetha University. I'm passionate about teaching and research, with a focus on AI, machine learning, and data science. Outside of academia, I'm always up for a conversation about tech, education, or life!")
        SingleAdminProfessor(professor: professor)
    }
}
