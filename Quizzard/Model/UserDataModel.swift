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
        TestTimer(reviewPeriod: 2, lengthMin: 10, colorIndex: 1, title: "sample timer", numberOfQuestions: 4)
    ]
    @Published var selectedTestTimer: TestTimer?
    @Published var selectedTestTimerIndex: UUID?
    @Published var functioningTimerModel: FunctioningTimerModel?
    
    @Published var settings = Info()
    
}
