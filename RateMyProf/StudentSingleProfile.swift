//
//  StudentSingleProfile.swift
//  RateMyProf
//
//  Created by SAIL on 26/12/24.
//

import SwiftUI

struct MyStudent: Identifiable {
    let id = UUID()
    let name: String
    let photo: ImageResource
}

struct StudentSingleProfile: View {
    let student: MyStudent

    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(.clear)
                .border(.purple)
                .frame(width: 100, height: 150)
                .overlay {
                    VStack {
                        Image(student.photo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 120)
                            .cornerRadius(10)
                        Text(student.name)
                            .font(.headline)
                            .frame(width: 90)
                            .background(Color.white)
                    }
                }
        }
        .padding()
    }
}


#Preview{
    StudentSingleProfile(student: MyStudent(name: "Emily Chen", photo: .download9))
}
