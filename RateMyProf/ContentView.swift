//
//  ContentView.swift
//  RateMyProf
//
//  Created by SAIL on 09/12/24.

import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool = Constants.loginResponse != nil
    @Namespace private var animation
    @State private var fadeIn = false // For fade-in effect
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255) // Updated to #0047AB

    var body: some View {
//        NavigationStack {
            ZStack {
                // White Background with Subtle Shapes
                Color.white.ignoresSafeArea()
                    .overlay(
                        ZStack {
                            Circle()
                                .fill(customColor.opacity(0.1)) // Updated to customColor
                                .frame(width: 300, height: 300)
                                .offset(x: -100, y: -200)
                                .blur(radius: 50)
                            
                            Circle()
                                .fill(customColor.opacity(0.1)) // Updated to customColor
                                .frame(width: 200, height: 200)
                                .offset(x: 150, y: 250)
                                .blur(radius: 40)
                        }
                    )
                
                VStack {
                    // App Title
                    Text("RateMyProf.")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.black) // Change text color to black
                        .padding(.bottom, 10)
                        .opacity(fadeIn ? 1 : 0)
                        .animation(.easeIn(duration: 1), value: fadeIn)
                    
                    // Tagline
                    Text("Find the best professors. Share your experience.")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .italic()
                        .foregroundColor(customColor)
                        .padding(.bottom, 30)
                        .opacity(fadeIn ? 1 : 0)
                        .animation(.easeIn(duration: 1.5), value: fadeIn)
                    
                    // "I am a" Text with a different font style
                    Text("I am a..")
                        .font(.custom("Palatino", size: 28))

                        .italic()
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .center) // Center the text
                    
                    // Buttons (Student, Professor, Admin)
                    if isLoggedIn {
                        StudentHomePage()
                    } else {
                        VStack(spacing: 20) {
                            loginCard(image: Image("image11"), title: "Student", destination: StudentLoginView())
                            loginCard(image: Image("image 2"), title: "Professor", destination: ProfessorLoginView())
                            loginCard(image: Image("image3"), title: "Admin", destination: AdminLoginView())
                        }
                        .opacity(fadeIn ? 1 : 0)
                        .animation(.easeIn(duration: 1.2), value: fadeIn)
                    }
                }
                .padding()
            }
            .onAppear {
                fadeIn = true
            }
            .navigationBarBackButtonHidden(true)
//        }
    }
    
    // Login Card View
    func loginCard<Destination: View>(image: Image, title: String, destination: Destination) -> some View {
        NavigationLink(destination: destination) {
            HStack {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding()
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black) // Set text color to black
                
                Spacer()
            }
            .padding()
            .background(Color.clear) // Transparent background
            .cornerRadius(15)
            .shadow(color: customColor.opacity(0.4), radius: 5, x: 0, y: 5) // Shadow for depth
            .overlay(
                RoundedRectangle(cornerRadius: 15) // Border around the button
                    .stroke(customColor, lineWidth: 2) // Purple border with a line width of 2
            )
            .matchedGeometryEffect(id: title, in: animation)
            .scaleEffect(fadeIn ? 1 : 0.8)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: fadeIn)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
