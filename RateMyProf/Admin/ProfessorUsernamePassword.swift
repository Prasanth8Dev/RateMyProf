//
//  ProfessorUsernamePassword.swift
//  RateMyProf
//
//  Created by SAIL on 24/12/24.
//
import SwiftUI
import PhotosUI
import Combine

struct ProfessorUsernamePassword: View {
    // Data passed from CreateNewProfessor
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var selectedTitle: String
    @Binding var selectedDepartment: String
    @Binding var selectedUniversity: String
    @Binding var email: String
    @Binding var phoneNumber: String
    
    // New fields for username, password, and profile picture
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showNextView = false
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @State private var cancellables = Set<AnyCancellable>()
    
    // Image Picker State
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
//        NavigationStack {
            ZStack {
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
                    // Header Section
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

                    Text("Create New Professor")
                        .font(.system(size: 30))
                        .italic()
                        .foregroundStyle(customColor)
                        .padding(.top, 20)
                    
                    // Profile Image with placeholder handling
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
                    
                    // Upload Image Button using PhotosPicker
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("Upload Image")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .frame(width: 150, height: 30)
                            .background(Color.gray.opacity(0.2))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.customColor, lineWidth: 2))
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
                    Button(action: {
                        submitProfessorDetails()
                    }) {
                        Text("Submit")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 40)
                            .background(Color.customColor)
                            .clipShape(Capsule())
                    }
                    .padding()
                    .navigationDestination(isPresented: $showNextView) {
                        ProfessorCreatedMessage()
                    }
                    
                    Spacer()
                }
            }
//        }
    }
    
    // Function to load image from PhotosPicker
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
    
    // Function to submit professor details to the server
    func submitProfessorDetails() {
        // Check if password and confirm password match
        guard password == confirmPassword else {
            // Show an alert or some error handling here
            print("Passwords do not match.")
            return
        }
        
        // Check if all fields are filled except profile pic
        guard !username.isEmpty && !password.isEmpty && !confirmPassword.isEmpty else {
            print("Please fill in all fields.")
            return
        }
        
        guard let url = URL(string: APIService.createProfessor) else {
            return
        }

        let param = ["FirstName": firstName,
                     "LastName": lastName,
                     "Title": selectedTitle,
                     "University": selectedUniversity,
                     "Dept": selectedDepartment,
                     "Email": email,
                     "PhnNo": phoneNumber,
                     "Username": username,
                     "Password": password,
                     "ProfilePic": selectedImage ?? UIImage(),
                     "Bio": ""] as [String: Any]
        
        APIWrapper.shared.postMultipartFormData(url: url, parameters: param, responseType: CreateProfessorModel.self).sink { completion in
            
            switch completion {
            case .finished:
                break
            case .failure(let err):
                print(err)
            }
        } receiveValue: { response in
            if response.status {
                DispatchQueue.main.async {
                    self.showNextView = true
                }
            } else {
                // Add alert for failure case
            }
        }
        .store(in: &cancellables)
    }
}

#Preview {
    ProfessorUsernamePassword(firstName: .constant("John"),
                              lastName: .constant("Doe"),
                              selectedTitle: .constant("Professor"),
                              selectedDepartment: .constant("Computer Science"),
                              selectedUniversity: .constant("SSE"),
                              email: .constant("john.doe@email.com"),
                              phoneNumber: .constant("123-456-7890"))
}
