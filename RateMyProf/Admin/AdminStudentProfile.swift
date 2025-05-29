import SwiftUI
import Combine

struct AdminStudentProfile: View {
    @State var registrationNumber: String = ""
    @State private var cancellables = Set<AnyCancellable>()
    var studId = ""  // Pass student ID when initializing the view
    @State var studentData: [StudentDataModel]?
    @State private var isBlocked = false  // Keep track of whether the student is blocked or not
    @Environment(\.presentationMode) var presentationMode
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
//        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background matching StudentMyProfile view
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
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.horizontal)

                        Spacer()

                        ScrollView {
                            VStack(spacing: 20) {
                                // Profile Image Card
                                VStack {
                                    if let endpoint = studentData?.first?.profilePic, let imageURL = URL(string: APIService.baseURL + endpoint) {
                                        AsyncImage(url: imageURL) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 120, height: 120)
                                        }
                                    }
                                    Text(studentData?.first?.firstName ?? "Loading...")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.top, 10)
                                    Text("Student")
                                        .font(.subheadline)
                                        .foregroundColor(customColor)
                                        .padding(.bottom, 20)
                                }
                                .frame(maxWidth: geometry.size.width * 0.9)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .padding(.top, 70)

                                // Information Card for Department and College
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Text("DEPARTMENT:")
                                            .font(.headline)
                                        Spacer()
                                        Text(studentData?.first?.dept ?? "Computer Science")
                                            .font(.body)
                                    }
                                    .padding(.horizontal)

                                    HStack(alignment: .top) {
                                        Text("COLLEGE:")
                                            .font(.headline)
                                        Spacer()
                                        Text(studentData?.first?.university ?? "Saveetha College of Engineering")
                                            .font(.body)
                                    }
                                    .padding(.horizontal)

                                    HStack {
                                        Text("Reg. No:")
                                            .font(.headline)
                                        Spacer()
                                        if let regNo = studentData?.first?.regNo {
                                            Text("\(regNo)")
                                        }
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
                                    Button(action: {
                                        blockStudent()
                                    }) {
                                        Text(isBlocked ? "UnBlock Student" : "Block Student")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 200, height: 50)
                                            .background(Color(customColor))
                                            .clipShape(Capsule())
                                            .shadow(radius: 5)
                                    }

                                    Button(action: {
                                        deleteStudent()
                                    }) {
                                        Text("Delete Student")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 200, height: 50)
                                            .background(Color(customColor))
                                            .clipShape(Capsule())
                                            .shadow(radius: 5)
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
                .onAppear {
                    fetchStudent()
                }
            }
//        }
    }

    private func blockStudent() {
        if isBlocked {
            blockOrUnBlockStudent(urlString: APIService.unBlockStudent)
        } else {
            blockOrUnBlockStudent(urlString: APIService.blockStudent)
        }
    }

    private func blockOrUnBlockStudent(urlString: String) {
        guard let url = URL(string: "\(urlString)\(studId)") else { return }
        
        APIWrapper.shared.getRequestMethod(url: url, responseType: BlockAndUnBlockModel.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                print(err)
            }
        } receiveValue: { response in
            if response.status {
                isBlocked.toggle()
            }
        }
        .store(in: &cancellables)
    }

    private func fetchStudent() {
        guard let url = URL(string: "\(APIService.fetchStudentProfile)?RegNo=\(studId)") else { return }
        
        APIWrapper.shared.getRequestMethod(url: url, responseType: StudentProfileDataModel.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                print(err)
            }
        } receiveValue: { response in
            if response.status {
                studentData = response.data
                if let isActive = studentData?.first?.isActive {
                    isBlocked = (isActive == 0)
                }
            }
        }
        .store(in: &cancellables)
    }

    private func deleteStudent() {
        guard let url = URL(string: "\(APIService.deleteStudent)\(studId)") else { return }
        
        APIWrapper.shared.getRequestMethod(url: url, responseType: BlockAndUnBlockModel.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let err):
                print(err)
            }
        } receiveValue: { response in
            if response.status {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .store(in: &cancellables)
    }
}

struct AdminStudentProfile_Previews: PreviewProvider {
    static var previews: some View {
        AdminStudentProfile(studId: "12345")
    }
}

