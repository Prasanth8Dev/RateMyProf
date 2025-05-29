//
//  StudentHomePage.swift
//  RateMyProf
//
//  Created by SAIL on 13/12/24.
//
import SwiftUI
import Combine

struct StudentHomePage: View {

    @State private var professorsCount: String = "Loading..."
    @State private var studentsCount: String = "Loading..."
    @State private var reviewsCount: String = "Loading..."
    @State private var collegeName: String = "Loading..."
    @State private var departmentName: String = "Loading..."
    @State private var professorName: String = "Loading..."
    @State private var professorImage: String = "Loading..."
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var topRatedProfessor: TopRatedProfessorModel?
    @State private var totalCounts: TotalCountsModel?
    @State private var studentName: String = Constants.loginResponse?.data.first?.firstName ?? "Student"
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
        ZStack {
            // Background with the color scheme as previous screens
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
                // Header with app name centered and profile icon
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
                .padding(.horizontal) // Ensuring no content touches the edge
                
                // Greeting added below the title
             VStack(alignment: .leading) {
                 Text("Good Day,")
                     .font(.system(size: 45))
                     .fontWeight(.semibold)
                     .foregroundColor(.black)
                     .padding(.top, 40) // Adjusted padding to move it down

                 Text("\(studentName)")
                     .font(.system(size: 45))
                     .fontWeight(.medium)
                     .foregroundColor(.black)
                     .padding(.top, 1)
             }
             .padding(.leading, -140)
             Spacer()
                // Professor Info Section with solid color background
//                Rectangle()
//                    .fill(Color(UIColor.systemBlue).opacity(0.6)) // Solid blue background
//                    .frame(height: 200)
//                    .padding(.top, 20)
//                    .cornerRadius(15) // Rounded corners to match the previous views
//                    .shadow(radius: 10) // Slight shadow for elevated effect
//                    .overlay(
//                        VStack {
//                            Text(collegeName)
//                                .font(.subheadline)
//                                .foregroundColor(.white)
//                                .padding(.top, -5)
//
//                            // AsyncImage for professor profile picture
//                            if let profilePicURL = URL(string: professorImage) {
//                                AsyncImage(url: profilePicURL) { phase in
//                                    switch phase {
//                                    case .empty:
//                                        Image("placeholder")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .padding(.top, -5)
//                                    case .success(let image):
//                                        image
//                                            .resizable()
//                                            .scaledToFit()
//                                            .padding(.top, -5)
//                                    case .failure:
//                                        Image(.image8)
//                                            .resizable()
//                                            .scaledToFit()
//                                            .padding(.top, -5)
//                                    @unknown default:
//                                        Image("placeholder")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .padding(.top, -5)
//                                    }
//                                }.frame(width: 100, height: 100)
//                            }
//
//                            // Professor name and department
//                            Text(professorName)
//                                .font(.subheadline)
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.white)
//                                .padding(.top, -15)
//
//                            Text(departmentName)
//                                .font(.caption2)
//                                .foregroundColor(Color.white)
//                                .padding(.top, -1)
//                        }
//                    )

                // Statistics Section with equal height boxes
                HStack(spacing: 20) {
                    statBox(title: "No. of           Profs", count: professorsCount)
                    statBox(title: "No. of            Students", count: studentsCount)
                    statBox(title: "No. of         Reviews", count: reviewsCount)
                }
                .padding(.top, 30)
                .padding(.horizontal) // Ensure no content touches the edge

                // Start Rating Button with matching style
                VStack {
                    Text("Rate, review, and discover professors to achieve academic excellence.")
                        .padding()
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)

                    // Dynamic button for start rating
                    if Constants.loginResponse?.data.first?.isActive == 1 {
                        NavigationLink(destination: StudentCollegeSelection()) {
                            Text("START RATING")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(Color(customColor))
                                .cornerRadius(25) // Rounded corners to match previous views
                                .shadow(radius: 10) // Shadow for elevated button
                        }
                    } else {
                        Button(action: {
                            showAlert = true
                            errorMessage = "You're not eligible to post reviews."
                        }) {
                            Text("START RATING")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(Color.gray)
                                .cornerRadius(25)
                                .shadow(radius: 10)
                        }
                    }
                }

                Spacer()
            }
            .alert("Error", isPresented: $showAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(errorMessage)
            })
            .navigationBarBackButtonHidden(true)
            .onAppear() {
                fetchHomeData()
            }
        }
    }

    private func statBox(title: String, count: String) -> some View {
        VStack {
            Text(title)
                .font(.callout)
                .multilineTextAlignment(.center)
                .frame(height: 100) // Fixing the height for all stat boxes
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                     .stroke(customColor) // Adding the hex color border
                )

            Text(count)
                .font(.title2)
                .foregroundColor(customColor) // Set the font color to customColor
                .lineLimit(1) // Prevent overflow of long text
                .minimumScaleFactor(0.5) // Dynamically reduce text size if too long
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }

    private func fetchHomeData() {
     
        let groups = DispatchGroup()
//        groups.enter()
//        fetchTopRatedProfessor {
//            groups.leave()
//        }
        groups.enter()
        fetchTotalCounts {
            groups.leave()
        }
        groups.notify(queue: .main) {
            DispatchQueue.main.async {
                loadHomepageData()
            }
        }
        print("API Triggered")
    }

    private func fetchTopRatedProfessor(completion: @escaping () -> Void) {
        guard let url = URL(string: APIService.fetchTopRatedProfessor) else { return }
        if let loginData = Constants.loginResponse, let university = loginData.data.first?.university {
            let param = ["University": university]
            APIWrapper.shared.postMultipartFormData(url: url, parameters: param, responseType: TopRatedProfessorModel.self).sink { completion in
                switch completion {
                case .finished:
                    print("Task Finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { response in
                if response.status {
                    topRatedProfessor = response
                } else {
                    errorMessage = response.message
                    showAlert = true
                }
                completion()
            }
            .store(in: &cancellables)
        }
    }

    private func fetchTotalCounts(completion: @escaping () -> Void) {
        guard let url = URL(string: "http://localhost/RateMyProf/API/TotalCounts.php") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    completion()
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(TotalCountsModel.self, from: data)
                
                if responseModel.status {
                    DispatchQueue.main.async {
                        self.professorsCount = responseModel.counts.totalProfessors
                        self.reviewsCount = responseModel.counts.totalRatings
                        self.studentsCount = responseModel.counts.totalStudents
                        completion()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = responseModel.message
                        self.showAlert = true
                        completion()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response"
                    self.showAlert = true
                    completion()
                }
            }
        }.resume()
    }

    private func loadHomepageData() {
        if let topRatedData = self.topRatedProfessor {
            professorName = topRatedData.professorDetails.firstName
            collegeName = topRatedData.professorDetails.university
            departmentName = topRatedData.professorDetails.dept
            professorImage = "\(APIService.baseURL)\(topRatedData.professorDetails.profilePic)"
        }
     studentName = Constants.loginResponse?.data.first?.firstName ?? "Student"
    }
}

#Preview {
    StudentHomePage()
}

