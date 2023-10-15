//
//  CurrentTimer.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/23/23.
//

import Foundation

class FunctioningTimerModel: ObservableObject {
    
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var currentQuestion = 1

    
    var lengthMin: Int      // timer length in minutes
    var totalQuestions: Int // amount of questions in test
    var reviewPeriod: Int   // review period length in minutes
    var actualReviewPeriodLengthSecs: Int  // reviewperiod length in seconds
    @Published var reviewPeriodRunning = false  // for timer, is the review period currently running?
    
    @Published var timeRemainingThisQuestionAsString = " "   // big string to display as time remaining this question
    @Published var totalSecondsRemainingThisQuestion = 0.0   // seconds remaining on current question
    @Published var timeRemainingThisQuestionProportion = 0.0 // proportion of time remaining : total time
    var avgTimePerQuestionRemaining = 0.0                    // time user can spend per remaining question, on avg
    
    @Published var timeRemainingAsString: String = " "       // big string to display time remaining for test
    @Published var totalSecondsRemaining: Double             // total seconds remaining on test
    @Published var totalSecondsRemainingMinusReview: Double  // total seconds remaining on test, w/o review period
    
    @Published var isRunning = false  // is the timer actively incrementing?
    @Published var isPaused = false   // has the timer been paused by the user?
    
    @Published var timerDone = false  // has the timer finished?
    @Published var questionDueDatePassed = false  // has the user taken longer than the alloted time on a question?

    
    //precise millisecond dates, for precision, as opposed to just measuring 1-second timer increments!
    var currentQuestionDueDate = Date()  // arbitrary date instantiation: will be set to Date + secs remaining each q
    var timerEndDate = Date()            // another arbitrary instantiation: will set to Date + total secs
    
    //for time curving (not implemented yet):
    var firstQuestionTimeLimit: Int?
    var lastQuestionTimeLimit: Int?
    
    //we know how long the test will be in questions, review, and time.
    init(length: Int, questions: Int, review: Int){
        lengthMin = length
        totalQuestions = questions
        reviewPeriod = review
        actualReviewPeriodLengthSecs = review*60
        totalSecondsRemaining = Double(60*length)
        totalSecondsRemainingMinusReview = Double(60*length)-Double(60*review)
    }
    
    //set timer end date, set isRunning, make sure timer isn't "done", initiate time per question calculation
    func start() {
        //refresh timer because of slight delay in starting timer view
        totalSecondsRemainingMinusReview = totalSecondsRemaining-Double(actualReviewPeriodLengthSecs)
        
        self.timerEndDate = Calendar.current.date(byAdding: .minute, value: lengthMin, to: Date())!
        self.isRunning = true
        timerDone = false
        calculateAverageTimePerQuestionRemaining()
        reviewPeriodRunning = false
        
        print("timer started!")
    }
    
    func pause(){
        isPaused = true
        isRunning = false
    }
    
    func resume(){
        //reset end date as well as current question end date
        self.timerEndDate = Calendar.current.date(byAdding: .second, value: Int(totalSecondsRemaining), to: Date())!
        self.currentQuestionDueDate = Calendar.current.date(byAdding: .second, value: Int(totalSecondsRemainingThisQuestion), to: Date())!
        isPaused = false
        isRunning = true
    }
    
    func reset(){
        self.isRunning = false
        
        self.totalSecondsRemaining = Double(lengthMin*60)
        
        self.currentQuestion = 1
        
        //reset timer displays
        self.timeRemainingAsString = "\(lengthMin):00"
        self.timeRemainingThisQuestionAsString = "\((Int(totalSecondsRemainingMinusReview)/totalQuestions)/60):\((Int(totalSecondsRemainingMinusReview)/totalQuestions)%60)"
        
        reviewPeriodRunning = false

    }
    
    func nextQuestion(){
        // increment while enforcing bounds
        if currentQuestion < totalQuestions {
            currentQuestion += 1
            calculateAverageTimePerQuestionRemaining()
        // or, begin review period if it exists
        } else if reviewPeriod > 0 {
            reviewPeriodRunning = true
            actualReviewPeriodLengthSecs = Int(totalSecondsRemaining)
            timeRemainingThisQuestionProportion = 1
        }
    }
    
    func backQuestion(){
        // decrement while enforcing bounds
        if currentQuestion > 1 && !reviewPeriodRunning{
            currentQuestion -= 1
            calculateAverageTimePerQuestionRemaining()
            reviewPeriodRunning = false
        // otherwise escape review period to go back to last question
        } else if reviewPeriodRunning {
            reviewPeriodRunning = false

        }
    }
    
    //called at beginning and at every question increment. adjusts the time it allots per question.
    func calculateAverageTimePerQuestionRemaining(){
        totalSecondsRemainingThisQuestion = totalSecondsRemainingMinusReview / Double((totalQuestions-currentQuestion)+1)
        avgTimePerQuestionRemaining = totalSecondsRemainingThisQuestion //stores TSRTQ val since it gets decremented
        currentQuestionDueDate = Calendar.current.date(byAdding: .second, value: Int(totalSecondsRemainingThisQuestion), to: Date())!
    }
    
    //time curving (not implemented)
    func scaledQuestionTimeLimit(questionNumber: Int) -> Int {
        guard totalQuestions > 2 else {return 0}
        guard (firstQuestionTimeLimit != nil) && (lastQuestionTimeLimit != nil) else {return 0}
        
        let incrementsToMake = totalQuestions-1
        let timeIncrement = (lengthMin*60)-(firstQuestionTimeLimit!+lastQuestionTimeLimit!)/incrementsToMake
        return firstQuestionTimeLimit!+(questionNumber-1)*timeIncrement
    }
    
    //called every second, as timer runs.
    func updateCountdowns(){
        //make sure the timer is running otherwise nothing should happen
        guard isRunning else {return}
        
        
        // if the timer finished...
        if totalSecondsRemaining <= 0 {
            isRunning = false
            timeRemainingAsString = "00:00"
            timerDone = true
            return
        }
        
        //TOTAL TIME UPDATER FOR DATE-BASED TIMER
        
        let currentDate = Date()
        
        // reset remaining time based on current date + due date
        totalSecondsRemaining = timerEndDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970
        totalSecondsRemainingMinusReview = totalSecondsRemaining-Double(reviewPeriod*60)
        
        let date = Date(timeIntervalSince1970: totalSecondsRemaining)
        let calendar = Calendar.current
        let minutesRemaining = calendar.component(.minute, from: date)
        let secondsRemainingThisMinute = calendar.component(.second, from: date)
        
        //sets display based on time calc
        self.timeRemainingAsString = String(format:"%d:%02d", minutesRemaining, secondsRemainingThisMinute)
        
        
        //QUESTION TIME UPDATER FOR DATE-BASED TIMER
        totalSecondsRemainingThisQuestion = currentQuestionDueDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970
        
        //stay on same question
        if totalSecondsRemainingThisQuestion >= 0 && !reviewPeriodRunning {
            
            questionDueDatePassed = false
            
            let timeLeftThisQuestionDate = Date(timeIntervalSince1970: totalSecondsRemainingThisQuestion)
            let minutesRemainingThisQuestion = calendar.component(.minute, from: timeLeftThisQuestionDate)
            let secondsRemainingThisQuestionThisMinute = calendar.component(.second, from: timeLeftThisQuestionDate)
            
            timeRemainingThisQuestionAsString = String(format:"%d:%02d", minutesRemainingThisQuestion, secondsRemainingThisQuestionThisMinute)
            
            timeRemainingThisQuestionProportion = totalSecondsRemainingThisQuestion/avgTimePerQuestionRemaining
            
        // oops took too long on current question
        } else if !reviewPeriodRunning {
            
            questionDueDatePassed = true
            totalSecondsRemainingThisQuestion -= 1
            
            let timeSinceDueDate = Date(timeIntervalSince1970: -totalSecondsRemainingThisQuestion)
            let minutesRemainingThisQuestion = calendar.component(.minute, from: timeSinceDueDate)
            let secondsRemainingThisQuestionThisMinute = calendar.component(.second, from: timeSinceDueDate)
            
            timeRemainingThisQuestionAsString = "-" + String(format:"%d:%02d", minutesRemainingThisQuestion, secondsRemainingThisQuestionThisMinute)
            
        //review time
        } else {
            timeRemainingThisQuestionProportion = totalSecondsRemaining/Double(actualReviewPeriodLengthSecs)
            print("total seconds remaining" + String(totalSecondsRemaining))
            print("actual review period length:" + String(actualReviewPeriodLengthSecs))
        }
    }
    
}
