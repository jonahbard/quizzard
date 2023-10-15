//
//  TimerPreviewBox.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/14/23.
//

import SwiftUI

struct TimerPreviewBox: View {
    
    @EnvironmentObject var model: UserDataModel
    var testTimer: TestTimer
    
    var body: some View {
        ZStack (alignment: .leading) {
            //colored rounded rectangle
            Rectangle()
                .cornerRadius(30)
                .foregroundColor(model.colors[testTimer.colorIndex].opacity(0.5))
                .frame(alignment: .leading)
                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 5)
            
            //preview text
            VStack(alignment: .leading) {
                Text(testTimer.title)
                    .frame(alignment: .trailing)
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.bottom, 0.5)
                Text("\(String(testTimer.lengthMin)) minutes")
                    .foregroundColor(.black)
                    .padding(.bottom, 0.1)

                Text("\(String(testTimer.numberOfQuestions)) questions")
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(25)
        }
        .frame(maxWidth: 420, maxHeight: 200, alignment: .leading)
        .padding(EdgeInsets(top: 9, leading: 18, bottom: 9, trailing: 18))
    }
}

struct TimerPreviewBox_Previews: PreviewProvider {
    static var previews: some View {
        TimerPreviewBox(testTimer: TestTimer(reviewPeriod: 2, lengthMin: 100, colorIndex: 0, title: "ACT: Math", numberOfQuestions: 75))
            .environmentObject(UserDataModel())
    }
}
