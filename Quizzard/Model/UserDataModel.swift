//
//  Model.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/14/23.
//

import Foundation
import UIKit
import SwiftUI

final class UserDataModel: ObservableObject {
    
    let colors: [Color] = [.red, .purple, .indigo, .blue, .green]
    
    @Published var userTimerList: [TestTimer] = [
        TestTimer(reviewPeriod: 1, lengthMin: 35, colorIndex: 4, title: "act: science", numberOfQuestions: 40),
        TestTimer(reviewPeriod: 1, lengthMin: 65, colorIndex: 0, title: "gmat: quantitative", numberOfQuestions: 36),
        TestTimer(reviewPeriod: 1, lengthMin: 60, colorIndex: 2, title: "psat: reading", numberOfQuestions: 47),
        TestTimer(reviewPeriod: 1, lengthMin: 70, colorIndex: 3, title: "ap psychology mcq", numberOfQuestions: 100)
    ]
    // just stores the current test timer. optional because one may not be selected.
    @Published var selectedTestTimer: TestTimer?
    
    // stores UUID ("index") of the selected test timer for function below.
    @Published var selectedTestTimerIndex: UUID?
    
    // funcitoning timer model: timer runner with the timer-specific info passed in.
    @Published var functioningTimerModel: FunctioningTimerModel?
    
    // a slightly unwieldy way to save modified timer data when edited in TimerPreview mode
    func updateTimerFromSelected() {
        for i: Int in 0...userTimerList.count-1 {
            if userTimerList[i].id == selectedTestTimerIndex {
                userTimerList[i] = selectedTestTimer!
            }
        }
    }
    
}
