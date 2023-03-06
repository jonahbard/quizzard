//
//  CurrentTimer.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/23/23.
//

import Foundation

class FunctioningTimerModel: ObservableObject {
    
    @Published var lengthMin: Int
    @Published var currentQuestion = 1
    @Published var totalQuestions: Int
    
    @Published var timeRemainingThisQuestionAsString = " "
    @Published var totalSecondsRemainingThisQuestion: Double = 0
    
    @Published var timeRemainingAsString: String = " "
    @Published var totalSecondsRemaining: Double
    
    @Published var isRunning = false
    @Published var isPaused = false
    
    @Published var timerDone = false
    @Published var questionDueDatePassed = false

    var currentQuestionDueDate = Date()
    var timerEndDate = Date()
    
    
    init(length: Int, questions: Int){
        lengthMin = length
        totalQuestions = questions
        totalSecondsRemaining = Double(60*length)
    }
    
    func start() {
        self.timerEndDate = Calendar.current.date(byAdding: .minute, value: lengthMin, to: Date())!
        self.isRunning = true
        timerDone = false
        calculateAverageTimePerQuestionRemaining()
    }
    
    func pause(){
        isPaused = true
        isRunning = false
    }
    
    func resume(){
        self.timerEndDate = Calendar.current.date(byAdding: .second, value: Int(totalSecondsRemaining), to: Date())!
        self.currentQuestionDueDate = Calendar.current.date(byAdding: .second, value: Int(totalSecondsRemainingThisQuestion), to: Date())!
        isPaused = false
        isRunning = true
    }
    
    func reset(){
        self.isRunning = false

        self.totalSecondsRemaining = Double(lengthMin*60)
        
        self.currentQuestion = 1
        
        //Resets time displays
        self.timeRemainingAsString = "\(lengthMin):00"
        self.timeRemainingThisQuestionAsString = "\((Int(totalSecondsRemaining)/totalQuestions)/60):\((Int(totalSecondsRemaining)/totalQuestions)%60)"
    }
    
    func nextQuestion(){
        if currentQuestion <= totalQuestions {
            currentQuestion += 1
            calculateAverageTimePerQuestionRemaining()
        }
    }
    
    func backQuestion(){
        if currentQuestion >= 1 {
            currentQuestion -= 1
            calculateAverageTimePerQuestionRemaining()
        }
    }
    
    func calculateAverageTimePerQuestionRemaining(){
        totalSecondsRemainingThisQuestion = totalSecondsRemaining / Double((totalQuestions-currentQuestion)+1)
        print("total sec remaining: \(Int(totalSecondsRemaining))")
        print("time per question: \(totalSecondsRemainingThisQuestion)")
        currentQuestionDueDate = Calendar.current.date(byAdding: .second, value: Int(totalSecondsRemainingThisQuestion), to: Date())!
    }
    
    func updateCountdowns(){
        guard isRunning else {return}
        
        if totalSecondsRemaining <= 0 {
            isRunning = false
            timeRemainingAsString = "00:00"
            timerDone = true
            return
        }
        
        let currentDate = Date()
        
        totalSecondsRemaining = timerEndDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970
        
        let date = Date(timeIntervalSince1970: totalSecondsRemaining)
        let calendar = Calendar.current
        let minutesRemaining = calendar.component(.minute, from: date)
        let secondsRemainingThisMinute = calendar.component(.second, from: date)

        self.timeRemainingAsString = String(format:"%d:%02d", minutesRemaining, secondsRemainingThisMinute)
        
        
        //QUESTION TIME UPDATER FOR DATE-BASED TIMER
        totalSecondsRemainingThisQuestion = currentQuestionDueDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970
        
        if totalSecondsRemainingThisQuestion >= 0 {
            
            questionDueDatePassed = false
            
            let timeLeftThisQuestionDate = Date(timeIntervalSince1970: totalSecondsRemainingThisQuestion)
            let minutesRemainingThisQuestion = calendar.component(.minute, from: timeLeftThisQuestionDate)
            let secondsRemainingThisQuestionThisMinute = calendar.component(.second, from: timeLeftThisQuestionDate)
            
            timeRemainingThisQuestionAsString = String(format:"%d:%02d", minutesRemainingThisQuestion, secondsRemainingThisQuestionThisMinute)
            
        } else {
            
            questionDueDatePassed = true
            totalSecondsRemainingThisQuestion -= 1
            
            let timeSinceDueDate = Date(timeIntervalSince1970: -totalSecondsRemainingThisQuestion)
            let minutesRemainingThisQuestion = calendar.component(.minute, from: timeSinceDueDate)
            let secondsRemainingThisQuestionThisMinute = calendar.component(.second, from: timeSinceDueDate)
            
            timeRemainingThisQuestionAsString = "-" + String(format:"%d:%02d", minutesRemainingThisQuestion, secondsRemainingThisQuestionThisMinute)
        }
        
    }
    
}
