//
//  ChooseUserView.swift
//  RateMyProf
//
//  Created by SAIL on 12/12/24.
//

import SwiftUI

struct ChooseUserView: View {
    let image: ImageResource
    let title: String
    var body: some View {
        Rectangle().frame(width: 200,height: 200).foregroundColor(.white).overlay {
            VStack{
                Spacer()
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height:100)
                Spacer()
                Text(title).frame(maxWidth: .infinity).padding(.vertical, 5).background(Color.purple).foregroundColor(.white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
               
            }
        }.border(Color.purple)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

#Preview {
    ChooseUserView(image: .image11, title: "yfyhfhy")
}
