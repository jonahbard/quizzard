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
        TestTimer(reviewPeriod: 1, lengthMin: 2, colorIndex: 1, title: "sample timer", numberOfQuestions: 2)
    ]
    @Published var selectedTestTimer: TestTimer?
    @Published var selectedTestTimerIndex: UUID?
    @Published var functioningTimerModel: FunctioningTimerModel?
    //@Published var settings = Info()
    
    func updateTimerFromSelected() {
        for i: Int in 0...userTimerList.count-1 {
            if userTimerList[i].id == selectedTestTimerIndex {
                userTimerList[i] = selectedTestTimer!
            }
        }
    }
    
}
