//
//  SingleProfessorFeedback.swift
//  RateMyProf
//
//  Created by SAIL on 23/12/24.
//

import SwiftUI


struct SingleProfessorFeedback: View {
    let professor: ProfessorData
    @State private var rating: Int = 0

    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(.clear)
                .border(.purple)
                .frame(width: 100, height: 150)
                .overlay {
                    VStack {
                     if let imageURL = URL(string: APIService.baseURL+professor.profilePic) {
                         AsyncImage(url: imageURL) { image in
                             image .resizable()
                                 .scaledToFit()
                                 .frame(width: 100, height: 120)
                                 .cornerRadius(10)
                         } placeholder: {
                             ProgressView()
                         }

                        }
                        Text(professor.firstName)
                            .font(.headline)
                            .frame(width: 90)
                            .background(Color.white)
                    }
                }
        }
        .padding()
    }
}

struct SingleProfessorFeedback_Previews: PreviewProvider {
    static var previews: some View {
        SingleProfessorFeedback(professor: ProfessorData(profID: "1122", firstName: "Prasanth", lastName: "S", title: "Developer", university: "SCLAS", dept: "MCA", email: "Prasanths.sse@saveetha.com", phnNo: "98402585564", username: "Prasanth", password: "123", profilePic: "", bio: ""))
    }
}
