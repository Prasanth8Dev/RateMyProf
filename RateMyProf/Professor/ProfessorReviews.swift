//
//  ProfessorReviews.swift
//  RateMyProf
//
//  Created by SAIL on 16/12/24.
//

import SwiftUI
import Combine

struct ProfessorReviews: View {
    @State var overallRating: Double = 3.3
    @State var numberOfReviews: Int = 4
    @State var professorReviewResponse: [FeedbackData] = []
    var professorId = ""
    
    @State private var cancellables = Set<AnyCancellable>()
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255) // The custom color used in StudentRatingList
    
    var body: some View {
//        NavigationStack {
            ZStack {
                // Background with circles (same as in StudentRatingList)
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

                    // Title for "REVIEWS"
                    Text("REVIEWS")
                        .font(.title)
                        .foregroundStyle(customColor)
                        .italic()
                        .padding(.top, 20)

                    // Reviews Section
                    ScrollView {
                        VStack {
                            VStack(alignment: .leading) {
                                Text("Viewing \(professorReviewResponse.count) reviews")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 20)
                                    .offset(x: 16)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(professorReviewResponse.indices, id: \.self) { index in
                                SingleReviewView(review: professorReviewResponse[index])
                                if index < professorReviewResponse.count - 1 {
                                    Divider()
                                }
                            }
                        }.frame(maxWidth: .infinity)
                        .padding()
                    }

                    Spacer()
                }
            }
            .onAppear {
                fetchReview()
            }
//        }
    }

    func fetchReview() {
        if professorId.isEmpty {
            guard let profId = Constants.professorLoginResponse?.data.first?.profID, let url = URL(string: "\(APIService.fetchProfessorFeedback)?ProfID=\(profId)") else { return }
            
            APIWrapper.shared.getRequestMethod(url: url, responseType: ProfessorReviewsModel.self).sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                } receiveValue: { response in
                    if response.status {
                        DispatchQueue.main.async {
                            professorReviewResponse = response.feedbackData
                        }
                    } else {
                        // Handle the failure case, e.g., show an alert
                    }
                }
                .store(in: &cancellables)
        } else {
            guard let url = URL(string: "\(APIService.fetchProfessorFeedback)?ProfID=\(professorId)") else { return }
            
            APIWrapper.shared.getRequestMethod(url: url, responseType: ProfessorReviewsModel.self).sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                } receiveValue: { response in
                    if response.status {
                        DispatchQueue.main.async {
                            professorReviewResponse = response.feedbackData
                        }
                    } else {
                        // Handle the failure case, e.g., show an alert
                    }
                }
                .store(in: &cancellables)
        }
    }
}

#Preview {
    ProfessorReviews()
}
