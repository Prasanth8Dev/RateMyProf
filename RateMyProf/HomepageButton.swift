//
//  HomepageButton.swift
//  RateMyProf
//
//  Created by SAIL on 14/12/24.
//

import SwiftUI

struct HomepageButton: View {
    var title: String
    var image: ImageResource
    var destination: AnyView
    
    
    let customColor = Color(red: 0/255, green: 71/255, blue: 171/255)

    var body: some View {
        NavigationLink(destination: destination) {
            ZStack{
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,20)
                    .frame(width:110, height:50)
                    .background(RoundedRectangle(cornerRadius: 10).fill(customColor))
                Circle()
                    .fill(Color.white)
                    .frame(width: 50, height:50)
                    .overlay(content: {
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundStyle(customColor)
                    })
                    .overlay(Image(image).resizable().scaledToFit().frame(width:30, height:30)).offset(x:-60)
            }
        }
    }
}

#Preview {
    HomepageButton(title: "jdiog", image: .image181, destination: AnyView(Text("Destination")))
}

