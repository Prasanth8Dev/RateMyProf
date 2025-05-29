import SwiftUI
import PhotosUI
import Combine

struct StudentUsernamePassword: View {
    
    let firstName: String
    let lastName: String
    let regNo: String
    let selectedUniversity: String
    let selectedDepartment: String
    let email: String
    let phoneNumber: String

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var navigateToNextView = false
    @State private var cancellables = Set<AnyCancellable>()
    
    // Image Picker
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                // Subtle background with color and circle overlays
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
                    // Header
                    HStack {
                        Spacer()
                        Text("RateMyProf.")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)

                    Text("Create New Student")
                        .font(.system(size: 30))
                        .italic()
                        .foregroundStyle(customColor)
                        .padding(.top, 10)

                    // Profile Image
                    ZStack {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.customColor, lineWidth: 2))
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Upload Image Button
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("Upload Image")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .frame(width: 150, height: 30)
                            .background(Color.gray.opacity(0.2))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(customColor, lineWidth: 2))
                            .cornerRadius(10)
                    }
                    .onChange(of: selectedItem) { newItem in
                        loadImage(from: newItem)
                    }
                    .padding(.bottom, 20)
                    
                    // Form fields
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Username:")
                                .font(.headline)
                                .foregroundColor(.customColor)
                            TextField("Enter username", text: $username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal, 20)
                        
                        HStack {
                            Text("Password:")
                                .font(.headline)
                                .foregroundColor(.customColor)
                            SecureField("Enter password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal, 20)
                        
                        HStack {
                            Text("Confirm Password:")
                                .font(.headline)
                                .foregroundColor(.customColor)
                            SecureField("Enter password again", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                    
                    // Submit Button
                    NavigationLink(destination: StudentCreatedMessage(), isActive: $navigateToNextView) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        createStudent()
                    }) {
                        Text("Submit")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 40)
                            .background(Color.customColor)
                            .clipShape(Capsule())
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
    
    // Function to load image
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let uiImage = UIImage(data: data) {
                        self.selectedImage = uiImage
                    }
                case .failure(let error):
                    print("Failed to load image: \(error)")
                }
            }
        }
    }
    
    private func createStudent() {
        guard let url = URL(string: APIService.createStudent) else { return }

        var param: [String: Any] = [
            "FirstName": firstName,
            "LastName": lastName,
            "RegNo": regNo,
            "University": selectedUniversity,
            "Dept": selectedDepartment,
            "Email": email,
            "PhnNo": phoneNumber,
            "Username": username,
            "Password": password,
            "ProfilePic": selectedImage ?? UIImage() // Fallback to default image if none selected
        ]
        
        APIWrapper.shared.postMultipartFormData(url: url, parameters: param, responseType: CreateProfessorModel.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    print(err)
                }
            } receiveValue: { response in
                if response.status {
                    DispatchQueue.main.async {
                        self.navigateToNextView = true
                    }
                }
            }
            .store(in: &cancellables)
    }
}

#Preview {
    StudentUsernamePassword(firstName: "", lastName: "", regNo: "", selectedUniversity: "", selectedDepartment: "", email: "", phoneNumber: "")
}
