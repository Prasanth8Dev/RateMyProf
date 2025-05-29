//
//  Feedback.swift
//  RateMyProf
//
//  Created by SAIL on 23/12/24.
//
import SwiftUI
import Combine

struct Feedback: View {
    let professor: ProfessorData
    @State private var feedback: String = ""
    @State private var isSubmitted = false
    @State private var cancellables = Set<AnyCancellable>()
    var ratingId: Int
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
//        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background with circles and blur effect
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

                        // Professor feedback section
                        VStack {
                            // Professor profile
                            Rectangle()
                                .foregroundStyle(.clear)
                                .border(Color.customColor)
                                .frame(width: 100, height: 150)
                                .overlay(
                                    VStack {
                                        if let imageUrl = URL(string: "\(APIService.baseURL+professor.profilePic)") {
                                            AsyncImage(url: imageUrl) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 120)
                                                    .cornerRadius(10)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                        Text(professor.firstName)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .frame(width: 100)
                                            .background(Color.customColor)
                                    }
                                )
                                .padding(.bottom, 20.0)

                            Text("Your Feedback")
                                .font(.largeTitle)

                            Rectangle()
                                .frame(width: 300, height: 150)
                                .foregroundColor(.white)
                                .overlay(
                                    VStack {
                                        TextField("Enter your feedback...(optional)", text: $feedback)
                                            .padding()
                                        Spacer()
                                    }
                                )
                                .border(customColor)

                            // Submit button with navigation to ThankYouForRating view
                            Button(action: {
                                sendFeedback()
                            }) {
                                Text("Submit")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 30)
                                    .background(Color.customColor)
                                    .clipShape(Capsule())
                            }
                            .padding()
                            .disabled(feedback.isEmpty) // Disable if no feedback is entered

                            NavigationLink(destination: ThankYouForRating(), isActive: $isSubmitted) {
                                EmptyView()
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer()
                    }
                }
            }
            .navigationBarBackButtonHidden(false) // Show default back button
//        }
    }

    func sendFeedback() {
        guard let url = URL(string: "\(APIService.sendFeedBackForProfessor)?RatingID=\(ratingId)&Feedback=\(feedback)") else { return }
        APIWrapper.shared.getRequestMethod(url: url, responseType: FeedBackResponseModel.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                print(err)
            }
        } receiveValue: { response in
            if response.status {
                isSubmitted = true
            } else {
                print("Error submitting feedback: \(response.message ?? "Unknown error")")
            }
        }
        .store(in: &cancellables)
    }
}

#Preview {
    Feedback(professor: ProfessorData(profID: "1122", firstName: "Prasanth", lastName: "S", title: "Developer", university: "SCLAS", dept: "MCA", email: "Prasanths.sse@saveetha.com", phnNo: "98402585564", username: "Prasanth", password: "123", profilePic: "", bio: ""), ratingId: 123)
}
