//
//  ProfessorMyProfile.swift
//  RateMyProf
//
//  Created by SAIL on 14/12/24.
//

//
//  ProfessorMyProfile.swift
//  RateMyProf
//
//  Created by SAIL on 14/12/24.
//
import SwiftUI
import Combine

struct ProfessorMyProfile: View {
    @State var professor: ProfessorProfileDatum?
    @State private var isLoggedOut = false
    @State private var cancellables = Set<AnyCancellable>()
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)
    
    var body: some View {
//        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background with circle overlays
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
                            Spacer()
                        }
                        .padding(.top, 20)

                        ScrollView {
                            VStack(spacing: 20) {
                                // Profile Image Card
                                VStack {
                                    if let endPoint = professor?.profilePic, let imageURL = URL(string: APIService.baseURL + endPoint) {
                                        AsyncImage(url: imageURL) { image in
                                            image.resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipShape(Circle())
                                                .padding(.top,20)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 120, height: 120)
                                        }
                                    }
                                    Text(professor?.username ?? "Loading...")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.top, 10)
                                    Text(professor?.title ?? "Loading...")
                                        .font(.subheadline)
                                        .foregroundColor(customColor)
                                        .padding(.bottom, 20)
                                }
                                .frame(maxWidth: geometry.size.width * 0.9, maxHeight: geometry.size.height * 0.4)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .padding(.top, 50)
                                
                                // Information Card
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Text("DEPARTMENT:")
                                            .font(.headline)
                                        Spacer()
                                        Text(professor?.dept ?? "Loading...")
                                            .font(.body)
                                    }
                                    .padding(.horizontal)
                                    
                                    HStack(alignment: .top) {
                                        Text("COLLEGE:")
                                            .font(.headline)
                                        Spacer()
                                        Text(professor?.university ?? "Loading...")
                                            .font(.body)
                                    }
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        Text("Reg.No:")
                                            .font(.headline)
                                        Spacer()
                                        if let id = professor?.profID {
                                            let userid = String(id)
                                            Text(userid).textCase(nil)
                                        } else {
                                            Text("Loading...")
                                        }
                                        
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(maxWidth: geometry.size.width * 0.9)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)

                                // Bio Section
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("BIO:")
                                        .font(.headline)
                                        .padding(.bottom, 5)
                                    Text(professor?.bio ?? "Loading...")
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                        .padding()
                                        .frame(maxWidth: geometry.size.width * 0.9)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(radius: 5)
                                        .padding(.horizontal, 10)
                                }
                                .padding(.top, 20)

                                // Action Buttons
                                VStack(spacing: 15) {
                                    NavigationLink(destination: ProfessorRatings()) {
                                        Text("VIEW RATINGS")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 200, height: 50)
                                            .background(customColor)
                                            .clipShape(Capsule())
                                            .shadow(radius: 5)
                                    }
                                    
                                    if let profID = professor?.profID {
                                        NavigationLink(destination: ProfessorReviews(professorId: "\(profID)")) {
                                            Text("VIEW REVIEWS")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .frame(width: 200, height: 50)
                                                .background(customColor)
                                                .clipShape(Capsule())
                                                .shadow(radius: 5)
                                        }
                                    }
                                    
                                    Button(action: {
                                        self.isLoggedOut = true
                                    }, label: {
                                        Text("LOG OUT")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 200, height: 50)
                                            .background(Color.red)
                                            .clipShape(Capsule())
                                            .shadow(radius: 5)
                                    })
                                    .navigationDestination(isPresented: $isLoggedOut) {
//                                        ProfessorLoginView()
                                        ContentView()
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
            .onAppear {
                fetchProfessorProfile()
            }
//        }
    }
    
    private func fetchProfessorProfile() {
        guard let profId = Constants.professorLoginResponse?.data.first?.profID, let url = URL(string: "\(APIService.fetchProfessorDetails)?ProfID=\(profId)") else { return }
        
        APIWrapper.shared.getRequestMethod(url: url, responseType: ProfessorProfileModel.self)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                if response.status, let profileData = response.profileData.first {
                    professor = profileData
                }
            }
            .store(in: &cancellables)
    }
}

//struct ProfessorMyProfile_Previews: PreviewProvider {
//    static var previews: some View {
//        let professor = Professor(
//            name: "Dr. John",
//            photo: .download1,
//            designation: "Associate Professor",
//            department: "Information & Technology",
//            college: "Saveetha College of Liberal Arts & Sciences",
//            regNo: "239762718",
//            bio: "Hi, I'm Dr. John, an Associate Professor of Computer Science at Saveetha University. I'm passionate about teaching and research, with a focus on AI, machine learning, and data science. Outside of academia, I'm always up for a conversation about tech, education, or life!"
//        )
//
//        return ProfessorMyProfile(professor: professor)
//    }
//}

