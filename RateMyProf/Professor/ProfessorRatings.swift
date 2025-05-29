import SwiftUI
import Combine

struct ProfessorRatings: View {
    @State private var overallRating: Double = 3.3
    @State private var numberOfRatings: Int = 45
    @State private var ratingResponse: ProfessorRatingModel?
    @State private var cancellables = Set<AnyCancellable>() // Combine cancellables
    @State var ratingPercentage: [Rating] = []
    var professorId = ""
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)
    
    
    var body: some View {
//        NavigationStack {
            ZStack {
                // Background with circles (matching StudentRatingList)
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
                        NavigationLink(destination: ProfessorMyProfile()) {
                            Image(.circle3)
                                .overlay(Image(.image5))
                                .padding(10)
                                .background(Circle().fill(Color.white).shadow(radius: 5))
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)

                    // "YOUR OVERALL RATING" section
                    Text("YOUR OVERALL RATING")
                        .font(.title3)
                        .italic()
                        .foregroundStyle(customColor)
                        .padding(.top, 40)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.customColor, lineWidth: 2)
                        .frame(width: 360, height: 400)
                        .foregroundColor(.white)
                        .overlay {
                            VStack {
                                Text("\(overallRating, specifier: "%.1f")")
                                    .font(.largeTitle)
                                    .padding()
                                RatingStarImage(rating: overallRating)
                                Text("Based on \(numberOfRatings) ratings")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                RatingDistributionView(ratings: $ratingPercentage)
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.vertical, 50)
                            .padding(.horizontal)
                        }

                    // "View Reviews" button
                    NavigationLink(destination: ProfessorReviews()) {
                        Text("View Reviews")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 30)
                    }
                    .background(Color.customColor)
                    .clipShape(Capsule())
                    .padding()

                    Spacer()
                }
            }
            .onAppear {
                ratingPercentage.removeAll()
                fetchRatings()
            }
//        }
    }

    private func fetchRatings() {
        // Logic to fetch ratings stays unchanged
        if let professorData = Constants.professorLoginResponse?.data.first {
            guard let url = URL(string: "\(APIService.fetchProfessorRating)?ProfID=\(professorData.profID)") else { return }
            APIWrapper.shared.getRequestMethod(url: url, responseType: ProfessorRatingModel.self).sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                } receiveValue: { response in
                    if response.status {
                        DispatchQueue.main.async {
                            ratingResponse = response
                            overallRating = Double(response.ratingData.averageRatings) ?? 0.0
                            numberOfRatings = Int(response.ratingData.overallRatingsCount)
                            if let starsPercentages = ratingResponse?.ratingData.starsPercentage.asRatingsArray() {
                                for (index, percentage) in starsPercentages.enumerated() {
                                    let rating = Rating(stars: index + 1, percentage: percentage)
                                    ratingPercentage.append(rating)
                                }
                            }
                        }
                    } else {
                        // Handle the failure case
                    }
                }
                .store(in: &cancellables)
        } else {
            guard let url = URL(string: "\(APIService.fetchProfessorRating)?ProfID=\(professorId)") else { return }
            APIWrapper.shared.getRequestMethod(url: url, responseType: ProfessorRatingModel.self).sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                } receiveValue: { response in
                    if response.status {
                        DispatchQueue.main.async {
                            ratingResponse = response
                            overallRating = Double(response.ratingData.averageRatings) ?? 0.0
                            numberOfRatings = Int(response.ratingData.overallRatingsCount)
                            if let starsPercentages = ratingResponse?.ratingData.starsPercentage.asRatingsArray() {
                                for (index, percentage) in starsPercentages.enumerated() {
                                    let rating = Rating(stars: index + 1, percentage: percentage)
                                    ratingPercentage.append(rating)
                                }
                            }
                        }
                    } else {
                        // Handle the failure case
                    }
                }
                .store(in: &cancellables)
        }
    }
}

#Preview {
    ProfessorRatings()
}
