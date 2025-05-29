//
//  SingleProfessorRate.swift
//  RateMyProf
//
//  Created by SAIL on 17/12/24.
//

import SwiftUI

struct SingleProfessorRate: View {
    let professor: ProfessorData
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(.clear)
                .border(customColor, width: 2)
                .frame(width: 130, height: 200)
                .overlay {
                    VStack {
                        if let imageURL = URL(string: "\(APIService.baseURL+professor.profilePic)") {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 120)
                                    .cornerRadius(10)
                            } placeholder: {
                                ProgressView() // Shows loading spinner
                            }
                        } else {
                            Image(systemName: "person.crop.circle.fill") // Fallback placeholder
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 120)
                                .foregroundColor(.gray)
                                .cornerRadius(10)
                        }
                        Text(professor.firstName)
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 130) // Fixed width
                            .background(customColor)
                            .multilineTextAlignment(.center) // Center the text
                            .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
                    }
                    .padding(.top, 32)
                }
            NavigationLink(destination: RatingPage1(professor: professor)) {
                Text("Rate")
                    .padding()
                    .frame(width: 100, height: 30)
                    .foregroundColor(.white)
                    .background(customColor)
                    .cornerRadius(20)
            }
        }
        .padding(.vertical)
    }
}



struct SingleProfessorRate_Previews: PreviewProvider {
    static var previews: some View {
        SingleProfessorRate(professor: ProfessorData(profID: "1122", firstName: "Prasanth", lastName: "S", title: "Developer", university: "SCLAS", dept: "MCA", email: "Prasanths.sse@saveetha.com", phnNo: "98402585564", username: "Prasanth", password: "123", profilePic: "", bio: ""))
    }
}
