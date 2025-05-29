//
//  StudentRatingList.swift
//  RateMyProf
//
//  Created by SAIL on 17/12/24.
//
import SwiftUI
import Combine

struct StudentRatingList: View {
    @State private var professorList: GetProfessorData?
    var selectedCollege: String?
    var selectedDept: String?
    @State private var cancellables = Set<AnyCancellable>()
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)
    
    var body: some View {
//        NavigationStack {
            ZStack {
                // Background with circles
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
                    // Header Section: Title and Profile Icon (aligned horizontally)
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

                    // Title for "Professors"
                    Text("PROFESSORS")
                        .font(.title)
                        .foregroundStyle(customColor)
                        .italic()
                        .padding(.top, 20)

                    // Scrollable list of professors
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                            if let profileData = professorList?.profileData {
                                ForEach(profileData, id: \.profID) { professor in
                                    SingleProfessorRate(professor: professor)
                                }
                            } else {
                                Text("Loading...")
                                    .font(.headline)
                                    .padding()
                            }
                        }
                    }
                    .padding(.top, 10)

                    Spacer()
                }
            }
            .onAppear {
                fetchProfessors()
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
                // handle failure case (e.g., show an alert)
            }
        }
        .store(in: &cancellables)
    }
}

#Preview {
    StudentRatingList()
}

