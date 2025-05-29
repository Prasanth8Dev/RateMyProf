//
//  ProfessorLoginView.swift
//  RateMyProf
//
//  Created by SAIL on 12/12/24.
//
import SwiftUI
import Combine

struct ProfessorLoginView: View {
    @State private var registrationNumber = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var cancellables = Set<AnyCancellable>()
    @State private var isLoading = false

    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255) // #0047AB color
    
    var body: some View {
//        NavigationStack {
            ZStack {
                // White Background with Subtle Shapes (Same as StudentLoginView)
                Color.white.ignoresSafeArea()
                    .overlay(
                        ZStack {
                            Circle()
                                .fill(customColor.opacity(0.1)) // Lighter opacity for a subtle effect
                                .frame(width: 300, height: 300)
                                .offset(x: -100, y: -200)
                                .blur(radius: 50)
                            
                            Circle()
                                .fill(customColor.opacity(0.1)) // Lighter circle color
                                .frame(width: 200, height: 200)
                                .offset(x: 150, y: 250)
                                .blur(radius: 40)
                        }
                    )

                VStack {
                    // Title with Large Font and Gradient Text Color
                    Text("RateMyProf.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .padding(.top, 50)
                    
                    Text("Your Dedication, Recognized!!")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .italic()
                        .foregroundColor(customColor)
                        .padding(.bottom, 40)
                    
                    // Login Box with Rounded Corners (Same UI as StudentLoginView)
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Prof ID")
                                .foregroundColor(customColor)
                                .font(.subheadline)
                            
                            // TextField with Floating Label
                            ZStack(alignment: .leading) {
                                if registrationNumber.isEmpty {
                                    Text("Enter your reg.no")
                                        .foregroundColor(Color.gray)
                                        .padding(.leading, 10)
                                }
                                TextField("", text: $registrationNumber)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: customColor.opacity(0.2), radius: 5, x: 0, y: 3)
                                    .padding(.bottom, 15)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Password")
                                .foregroundColor(customColor)
                                .font(.subheadline)
                            
                            // SecureField with Floating Label
                            ZStack(alignment: .leading) {
                                if password.isEmpty {
                                    Text("Enter your password")
                                        .foregroundColor(Color.gray.opacity(0.7))
                                        .padding(.leading, 10)
                                }
                                SecureField("", text: $password)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: customColor.opacity(0.2), radius: 5, x: 0, y: 3)
                                    .padding(.bottom, 30)
                            }
                        }
                        
                        // LOGIN Button with Animated Effect
                        Button(action: {
                            withAnimation {
                                login()
                            }
                        }) {
                            Text("LOGIN")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 250, height: 45)
                                .background(customColor)
                                .cornerRadius(25)
                                .shadow(color: customColor.opacity(0.3), radius: 5, x: 0, y: 5)
                        }
                        .scaleEffect(isLoading ? 0.95 : 1) // Animating the button scale
                        .opacity(isLoading ? 0.6 : 1) // Button opacity while loading
                    }
                    .padding(30)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    
                    Spacer()
                }
                .padding()

                if isLoading {
                    LoadingView()
                }
            }
            .alert("Login Error", isPresented: $showAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(errorMessage)
            })
            .navigationDestination(isPresented: $isLoggedIn) {
                ProfessorHomePage()
            }
//        }
    }

    private func login() {
        isLoading = true
        guard let url = URL(string: APIService.professorlogin) else {
            isLoading = false
            errorMessage = "Invalid URL"
            showAlert = true
            return
        }
        guard !registrationNumber.isEmpty else {
            isLoading = false
            errorMessage = "Please enter your Registration Number"
            showAlert = true
            return
        }
        guard !password.isEmpty else {
            isLoading = false
            errorMessage = "Please enter your Password"
            showAlert = true
            return
        }

        let parameters: [String: Any] = [
            "ProfID": registrationNumber,
            "Password": password
        ]

        APIWrapper.shared
            .postMultipartFormData(url: url, parameters: parameters, responseType: ProfessorLoginResponse.self)
            .sink(receiveCompletion: { completion in
                isLoading = false
                switch completion {
                case .failure(let error):
                    errorMessage = "Login failed: \(error.localizedDescription)"
                    showAlert = true
                case .finished:
                    break
                }
            }, receiveValue: { response in
                isLoading = false
                if response.status {
                    Constants.professorLoginResponse = response
                    isLoggedIn = true
                } else {
                    errorMessage = response.message
                    showAlert = true
                }
            })
            .store(in: &cancellables)
    }
}

#Preview {
    ProfessorLoginView()
}
