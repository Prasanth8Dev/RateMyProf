//
//  AdminProfessorList.swift
//  RateMyProf
//
//  Created by SAIL on 26/12/24.
//
import SwiftUI
import Combine

struct AdminProfessorList: View {
    @State private var professorList: GetProfessorData?
    var selectedCollege: String?
    var selectedDept: String?
    @State private var cancellables = Set<AnyCancellable>()
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
//        NavigationStack {
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

                    
                    Text("PROFESSORS")
                        .font(.title)
                        .foregroundStyle(customColor)
                        .italic()
                        .padding(.top, 20)

                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                            if let professorData = professorList?.profileData {
                                ForEach(professorData, id: \ .profID) { professor in
                                    NavigationLink(destination: AdminProfessorView(professor: professor)) {
                                        SingleAdminProfessor(professor: professor)
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    fetchProfessors()
                }
            }
//        }
    }

    private func fetchProfessors() {
        guard let url = URL(string: APIService.getProfessorList) else { return }

        let param = ["university": selectedCollege, "dept": selectedDept]
        APIWrapper.shared.postMultipartFormData(url: url, parameters: param, responseType: GetProfessorData.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                print(err.localizedDescription)
            }
        } receiveValue: { response in
            if response.status {
                professorList = response
            } else {
                // Show alert if needed
            }
        }
        .store(in: &cancellables)
    }
}


struct AdminProfessorList_Previews: PreviewProvider {
    static var previews: some View {
        AdminProfessorList()
    }
}
