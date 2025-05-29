// RatingPage1.swift
// RateMyProf
// Created by SAIL on 17/12/24.

import SwiftUI
import Combine

extension Color {
    static let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)
}

struct RatingPage1: View {
    var professor: ProfessorData
    @State private var teachingStyleRating: Int = 0
    @State private var encouragingRating: Int = 0
    @State private var useOfTechnologyRating: Int = 0
    @State private var respectForStudentsRating: Int = 0
    @State private var selectedTeachingStyleOption: Int = 0
    @State private var selectedEncouragingOption: Int = 0
    @State private var selectedUseOfTechnologyOption: Int = 0
    @State private var selectedRespectForStudentsOption: Int = 0
    @State private var navigateToFeedback = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var isRatingSubmitted = false
    @State var ratingId = 0
    
    let teachingStyleOptions = [
        ["Hard to understand.", "Teaching feels rushed.", "Lessons are confusing.", "Needs more examples."],
        ["Sometimes clear.", "Could explain better.", "More examples needed.", "Not always engaging."],
        ["Mostly clear teaching.", "Uses some good examples.", "Easy to follow most times.", "Encourages questions."],
        ["Explains topics well.", "Gives useful examples.", "Lessons are well-organized.", "Makes learning interesting."],
        ["Very clear and easy to follow.", "Great examples for learning.", "Always engaging and helpful.", "Makes lessons fun and interactive."]
    ]

    let encouragingOptions = [
        ["Rarely gives support.", "Hardly motivates students.", "Limited feedback provided.", "Doesn't show much interest."],
        ["Gives some encouragement.", "Feedback is okay but brief.", "Shows some interest in progress.", "Could motivate more."],
        ["Supports students often.", "Gives helpful feedback.", "Notices when students improve.", "Encourages participation."],
        ["Often motivates students.", "Feedback is detailed and useful.", "Recognizes hard work.", "Creates a positive vibe."],
        ["Very supportive and kind.", "Always encouraging students.", "Gives detailed and caring feedback.", "Inspires everyone to do their best."]
    ]

    let useOfTechnologyOptions = [
        ["Hardly uses technology.", "Presentations are too basic.", "Tools feel outdated.", "Struggles with technical issues."],
        ["Uses some technology.", "Presentations are okay.", "Could use more tools.", "Handles tech with small issues."],
        ["Good use of technology.", "Presentations are clear.", "Tools are helpful for learning.", "Rarely has tech problems."],
        ["Uses technology really well.", "Presentations are creative.", "Tools make learning easier.", "Solves tech issues quickly."],
        ["Amazing use of technology.", "Presentations are engaging and fun.", "Tools make everything easy to understand.", "Always smooth and well-prepared."]
    ]

    let respectForStudentsOptions = [
        ["Doesn't always listen.", "Needs to be kinder to students.", "Rarely values student ideas.", "Hard to approach."],
        ["Sometimes listens to students.", "Treats students fairly most times.", "Could show more kindness.", "Accepts ideas but doesn’t act on them."],
        ["Treats students with respect.", "Listens and gives fair attention.", "Values student ideas occasionally.", "Approachable most of the time."],
        ["Always treats students fairly.", "Encourages sharing ideas.", "Shows care and kindness.", "Easy to talk to and open-minded."],
        ["Very respectful and fair.", "Makes students feel valued.", "Always listens and acts on ideas.", "Creates a safe and welcoming space."]
    ]

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

                        ScrollView {
                            VStack {
                                Spacer()

                                VStack {
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
                                                .padding(.top, 10)
                                        )
                                }

                                Group {
                                    DynamicRatingSection(title: "Teaching Style", rating: $teachingStyleRating, selectedOption: $selectedTeachingStyleOption, options: teachingStyleOptions)
                                    DynamicRatingSection(title: "Encouraging", rating: $encouragingRating, selectedOption: $selectedEncouragingOption, options: encouragingOptions)
                                    DynamicRatingSection(title: "Use of Technology", rating: $useOfTechnologyRating, selectedOption: $selectedUseOfTechnologyOption, options: useOfTechnologyOptions)
                                    DynamicRatingSection(title: "Respect for Students", rating: $respectForStudentsRating, selectedOption: $selectedRespectForStudentsOption, options: respectForStudentsOptions)
                                }

                                Spacer()
                                Button(action: {
                                    postRating()
                                }) {
                                    Text("Next")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .frame(width: 200, height: 30)
                                }
                                .background(Color.customColor)
                                .clipShape(Capsule())
                                .padding()
                                .disabled(teachingStyleRating == 0 || encouragingRating == 0 || useOfTechnologyRating == 0 || respectForStudentsRating == 0 || selectedTeachingStyleOption == 0 || selectedEncouragingOption == 0 || selectedUseOfTechnologyOption == 0 || selectedRespectForStudentsOption == 0)
                                .frame(maxWidth: .infinity)

                                NavigationLink(destination: Feedback(professor: professor, ratingId: ratingId), isActive: $isRatingSubmitted) {
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
            }
//        }
    }

    func postRating() {
        guard let baseURL = URL(string: APIService.postReviewForProfessor),
              let regNo = Constants.loginResponse?.data.first?.regNo else { return }

        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        let queryItems = [
            URLQueryItem(name: "ProfID", value: "\(professor.profID)"),
            URLQueryItem(name: "TeachingStyle", value: "\(teachingStyleRating)"),
            URLQueryItem(name: "Encouraging", value: "\(encouragingRating)"),
            URLQueryItem(name: "UseOfTechnology", value: "\(useOfTechnologyRating)"),
            URLQueryItem(name: "RespectForStudents", value: "\(respectForStudentsRating)"),
            URLQueryItem(name: "RegNo", value: String(regNo)),
            URLQueryItem(name: "University", value: professor.university)
        ]
        urlComponents?.queryItems = queryItems

        guard let urlWithParams = urlComponents?.url else { return }

        APIWrapper.shared.getRequestMethod(url: urlWithParams, responseType: RatingResponseModel.self).sink { completion in
            switch completion {
            case .finished: break
            case .failure(let err): print(err)
            }
        } receiveValue: { response in
            if response.status {
                isRatingSubmitted = true
                ratingId = response.ratingID
            } else {
                print("Error submitting rating: \(response.message ?? "Unknown error")")
            }
        }
        .store(in: &cancellables)
    }
}


struct DynamicRatingSection: View {
    let title: String
    @Binding var rating: Int
    @Binding var selectedOption: Int
    let options: [[String]]

    let defaultMessage = "Select a rating to see options."

    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.title)
                .padding(.top, 20)
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Button(action: {
                        rating = index
                        selectedOption = 0
                    }) {
                        Image(systemName: rating >= index ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .padding(.bottom, 10)
            Text("Why?")
                .font(.headline)
                .foregroundColor(.customColor)
                .italic()
                .padding(.bottom, 10)
            VStack {
                ForEach(0..<4, id: \.self) { index in
                    Button(action: {
                        selectedOption = index + 1
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.customColor, lineWidth: 2)
                            .background(selectedOption == index + 1 ? Color.customColor : Color.white)
                            .frame(width: 300, height: 40)
                            .overlay(
                                Text(rating > 0 ? options[rating - 1][index] : defaultMessage)
                                    .foregroundColor(selectedOption == index + 1 ? .white : .black)
                                    .lineLimit(1)
                            )
                            .cornerRadius(8)
                            .shadow(radius: 2)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
#Preview{
    RatingPage1(professor: ProfessorData(profID: "1122", firstName: "Prasanth", lastName: "S", title: "Developer", university: "SCLAS", dept: "MCA", email: "Prasanths.sse@saveetha.com", phnNo: "98402585564", username: "Prasanth", password: "123", profilePic: "", bio: "A very good professor!"))
}
