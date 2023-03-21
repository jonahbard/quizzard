//
//  TutorialPageView.swift
//  Quizzard
//
//  Created by Jonah Bard on 3/19/23.
//

import SwiftUI

struct TutorialPageView: View {
    var page: TutorialPage
    var body: some View {
        VStack {
            Image(page.image)
                .resizable()
                .cornerRadius(15)
                .shadow(radius: 5)
                .frame(width: 200, height: 400)
                .padding()
            Text(page.name)
                .font(.title3)
                .fontWeight(.bold)
                .padding()
                .multilineTextAlignment(.center)
            Text(page.description)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
        }
    }
}

struct TutorialPageView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPageView(page: TutorialPage(name: "page name", description: "description", image: "quizzard-timer-view", index: 0))
    }
}
