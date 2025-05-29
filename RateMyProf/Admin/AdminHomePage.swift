//
//  AdminHomePage.swift
//  RateMyProf
//
//  Created by SAIL on 14/12/24.
//
import SwiftUI
import Combine

struct AdminHomePage: View {
    @State private var professorsCount: String = "Loading..."
    @State private var studentsCount: String = "Loading..."
    @State private var reviewsCount: String = "Loading..."
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var totalCounts: TotalCountsModel?
    @State private var isLoggedOut = false

    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255) // Custom color for the borders and text

    var body: some View {
        NavigationView {
            ZStack {
                // Background color with circles as you requested
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
                        Spacer()
                        Text("RateMyProf.")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                    // Greeting Section with adjusted padding to move it down
                    VStack(alignment: .leading) {
                        Text("Good Day,")
                            .font(.system(size: 45))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.top, 40) // Adjusted padding to move it down

                        Text("Admin!!")
                            .font(.system(size: 45))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.top, 1)
                    }
                    .padding(.leading, -140) // Left-aligned with some padding

                    Spacer()
                    
                    HStack(spacing: 16) {
                        statBox(title: "No.of         Profs", count: professorsCount)
                        
                        statBox(title: "No.of       Students", count: studentsCount)
                        
                        statBox(title: "No.of       Reviews", count: reviewsCount)
                    }
                    .padding(.top, -30)
                    .padding(.horizontal)

                    // Buttons for managing Professors and Students
                    VStack {
                        HStack {
                            HomepageButton(title: "Create new Professor", image: .image181, destination: AnyView(CreateNewProfessor()))
                                .offset(x: -20, y: 50)
                            HomepageButton(title: "Create new Student", image: .image11, destination: AnyView(CreateNewStudent()))
                                .offset(x: 45, y: 50)
                        }
                        HStack {
                            HomepageButton(title: "View Professor", image: .image181, destination: AnyView(ProfessorManagement()))
                                .offset(x: -20, y: 80)
                            HomepageButton(title: "View Student", image: .image11, destination: AnyView(StudentManagement()))
                                .offset(x: 45, y: 80)
                        }
                    }

                    Spacer()

                    Button(action: {
                        isLoggedOut = true
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(customColor)
                            .cornerRadius(10)
                            .padding()
                    }
                    .navigationDestination(isPresented: $isLoggedOut) {
                        ContentView()
                    }
                }
                .alert("Error", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(errorMessage)
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    fetchHomeData()
                }
            }
        }
    }

    // Existing statBox function
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

    // Fetch functions remain untouched
    private func fetchHomeData() {
        let groups = DispatchGroup()

        groups.enter()
        fetchTotalCounts {
            groups.leave()
        }

        groups.notify(queue: .main) {
            loadHomepageData()
        }
    }

    private func fetchTotalCounts(completion: @escaping () -> Void) {
        guard let url = URL(string: "http://localhost/RateMyProf/API/TotalCounts.php") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
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
        if let totalCountData = totalCounts {
            professorsCount = totalCountData.counts.totalProfessors
            reviewsCount = totalCountData.counts.totalRatings
            studentsCount = totalCountData.counts.totalStudents
        }
    }
}

#Preview {
    AdminHomePage()
}
