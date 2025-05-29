import SwiftUI
import Combine

struct StudentMyProfile: View {
    @State private var navigateToRating = false
    @State private var navigateToLogin = false
    @State private var showAlert = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var studentData: StudentProfileModel?

    var body: some View {
//        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background with circles and blur effect (same as before)
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
                        // Header with title and profile icon
                        HStack {
                            Spacer()
                            Text("RateMyProf.")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            Spacer()
                            NavigationLink(destination: StudentMyProfile()) {
                                Image(.circle3)
                                    .overlay(Image(.image5))
                                    .padding(10)
                                    .background(Circle().fill(Color.white).shadow(radius: 5))
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal)

                        Spacer()

                        // Profile Section with card-like design for the profile info
                        ScrollView {
                            VStack(spacing: 20) {
                                // Profile Card with padding to move it down
                                VStack {
                                    // Profile Image in Circle (removed the stroke and added padding)
                                    if let image = studentData?.profileData.first?.profilePic, let imageUrl = URL(string: "\(APIService.baseURL)\(image)") {
                                        AsyncImage(url: imageUrl) { profileImage in
                                            profileImage
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipShape(Circle()) // Circle shape for the image
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 120, height: 120)
                                        }
                                    }
                                    Text(studentData?.profileData.first?.firstName ?? "Loading")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.top, 10)
                                    Text("Student")
                                        .font(.subheadline)
                                        .foregroundColor(.customColor)
                                        .padding(.bottom, 20)
                                }
                                .frame(maxWidth: geometry.size.width * 0.9)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .padding(.top, 70) // This moves the entire profile card and image down

                                // Profile Information Card
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Text("Department:")
                                            .font(.headline)
                                        Spacer()
                                        Text(studentData?.profileData.first?.dept ?? "Loading")
                                            .font(.body)
                                    }
                                    .padding(.horizontal)

                                    HStack {
                                        Text("College:")
                                            .font(.headline)
                                        Spacer()
                                        Text(studentData?.profileData.first?.university ?? "Loading")
                                            .font(.body)
                                    }
                                    .padding(.horizontal)

                                    HStack {
                                        Text("Reg. No:")
                                            .font(.headline)
                                        Spacer()
                                        Text(String(studentData?.profileData.first?.regNo ?? 0))
                                            .font(.body)
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(maxWidth: geometry.size.width * 0.9)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)

                                Spacer()

                                // Action Buttons
                                VStack(spacing: 15) {
                                    // Start Rating Button
                                    NavigationLink(destination: StudentCollegeSelection(), isActive: $navigateToRating) {
                                        Button(action: {
                                            if studentData?.profileData.first?.isActive == 1 {
                                                navigateToRating.toggle()
                                            } else {
                                                showAlert = true
                                            }
                                        }) {
                                            Text("Start Rating")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .frame(width: 200, height: 50)
                                                .background(Color.customColor)
                                                .clipShape(Capsule())
                                                .shadow(radius: 5)
                                        }
                                    }
                                    .alert(isPresented: $showAlert) {
                                        Alert(title: Text("Not Eligible"), message: Text("You're not eligible to post reviews."), dismissButton: .default(Text("OK")))
                                    }

                                    // Log Out Button
                                    NavigationLink(destination: ContentView(isLoggedIn: false), isActive: $navigateToLogin) {
                                        Button(action: {
                                            logout()
                                        }) {
                                            Text("Log Out")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .frame(width: 200, height: 50)
                                                .background(Color.customColor)
                                                .clipShape(Capsule())
                                                .shadow(radius: 5)
                                        }
                                    }
                                }
                                .padding(.top, 20)
                            }
                            .padding(.bottom, 30)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40) // Add extra top padding to center content vertically
                    }
                }
                .onAppear {
                    loadStudentProfile()
                }
                .navigationBarBackButtonHidden(false)
//            }
             // Show default back button
        }
    }

    func loadStudentProfile() {
        guard let url = URL(string: APIService.studentProfile), let regNo = Constants.loginResponse?.data.first?.regNo else { return }

        let param = ["RegNo": String(regNo)]

        APIWrapper.shared.postMultipartFormData(url: url, parameters: param, responseType: StudentProfileModel.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                print(err.localizedDescription)
            }
        } receiveValue: { response in
            if response.status {
                studentData = response
            }
        }
        .store(in: &cancellables)
    }

    func logout() {
        Constants.loginResponse = nil
        navigateToLogin = true
    }
}

struct StudentMyProfile_Previews: PreviewProvider {
    static var previews: some View {
        StudentMyProfile()
    }
}
