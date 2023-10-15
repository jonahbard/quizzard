//
//  TutorialPageModel.swift
//  Quizzard
//
//  Created by Jonah Bard on 3/19/23.
//

import Foundation

struct TutorialPage: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var image: String
    var index: Int
    
    static var pages: [TutorialPage] = [
        TutorialPage(name: "practice exams and quizzes confidently.", description: "see how much time you have left on each question with a timer that automatically adjusts to your pace.", image: "quizzard-timer-view", index: 0),
        TutorialPage(name: "test distraction-free.", description: "with minimalisic view, a quick glance shows all the information you need to see—without interrupting your focus.", image: "quizzard-minimalistic-view", index: 1),
        TutorialPage(name: "train for any evaluation.", description: "quizzard works for educational evaluations of all levels.", image: "quizzard-home-page", index: 2),
        TutorialPage(name: "for best results, turn off auto-lock in device settings.", description: "navigate to settings > display and brightness > auto-lock > \"never\".", image: "auto-lock", index: 3)
    ]
    
}
