//
//  MainTimerView.swift
//  Quizzard
//  
//  Created by Jonah Bard on 1/19/23.
//

import SwiftUI
import Foundation
import AVFoundation

struct MainTimerView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model: UserDataModel
        
    @State var viewIsPaused = false
    @State var totalTimeRemainingView = ""
    @State var timePerQuestionRemainingView = ""
    @State var resetAlertShowing = false
    @State var exitAlertShowing = false
    @State var timerDone = false
    
        
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Button(viewIsPaused ? "resume" : "pause") {
                        if model.functioningTimerModel!.isPaused {
                            viewIsPaused = false
                            model.functioningTimerModel!.resume()
                        } else {
                            model.functioningTimerModel!.pause()
                            viewIsPaused = true
                        }
                    }.foregroundColor(model.colors[model.selectedTestTimer!.colorIndex])
                    ///RESET BUTTON TECHNICALLY UNNECESSARY
//                    Text("-")
//                    Button(model.functioningTimerModel!.isRunning || model.functioningTimerModel!.isPaused ? "reset" : "start") {
//                        if model.functioningTimerModel!.isRunning || model.functioningTimerModel!.isPaused {
//                            resetAlertShowing = true
//                        } else {
//                            model.functioningTimerModel!.start()
//                        }
//                    }.foregroundColor(model.colors[model.selectedTestTimer!.colorIndex])
//                    .alert(isPresented: $resetAlertShowing){
//                        Alert(
//                            title: Text("reset?"),
//                            message: Text("this will completely reset your progress."),
//                            primaryButton: .destructive(Text("reset"), action: {
//                                model.functioningTimerModel!.reset()
//                                model.functioningTimerModel!.calculateAverageTimePerQuestionRemaining()
//                            }),
//                            secondaryButton: .cancel(Text("cancel"))
//                        )
//                    }
                    Text("-")
                    Button("exit") {
                        exitAlertShowing = true
                    }.foregroundColor(model.colors[model.selectedTestTimer!.colorIndex])
                    .alert(isPresented: $exitAlertShowing){
                        Alert(
                            title: Text("exit timer?"),
                            message: Text("progress will not be saved."),
                            primaryButton: .destructive(Text("exit"), action: {
                                totalTimeRemainingView = ""
                                timePerQuestionRemainingView = ""
                                model.functioningTimerModel!.reset()
                                dismiss()
                            }),
                            secondaryButton: .cancel(Text("cancel"))
                        )
                    }
                }
                .padding(EdgeInsets(top: 30, leading: 0, bottom: 10, trailing: 0))
                Text(totalTimeRemainingView)
                    .font(.system(size: 40, weight: .light))
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 5, trailing: 0))
                Text("total time remaining")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                Spacer()
                
                // if not review period--faster when check STT first
                if (model.selectedTestTimer!.reviewPeriod==0 || !model.functioningTimerModel!.reviewPeriodRunning ){
                    Text(timePerQuestionRemainingView)
                        .font(.system(size: 70, weight: .medium))
                        .padding()
                        .frame(width: 250)
                        .foregroundColor(model.functioningTimerModel!.questionDueDatePassed ? .red : .black)
                    
                    Text("question \(model.functioningTimerModel!.currentQuestion) of \(model.functioningTimerModel!.totalQuestions)")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                } else {
                    Text("review time!")
                        .bold()
                        .font(.title3)
                        .padding(EdgeInsets(top: 50, leading: 0, bottom: 50, trailing: 0))
                }
                // increment buttons
                HStack(spacing:50) {
                    Button("❮ back") {
                        model.functioningTimerModel!.backQuestion()
                    }.foregroundColor(model.colors[model.selectedTestTimer!.colorIndex])
                    .disabled(!model.functioningTimerModel!.isRunning || model.functioningTimerModel!.currentQuestion <= 1)
                    Button("next ❯") {
                        model.functioningTimerModel!.nextQuestion()
                    }.foregroundColor(model.colors[model.selectedTestTimer!.colorIndex])
                        .disabled(!model.functioningTimerModel!.isRunning || (model.functioningTimerModel!.currentQuestion >= model.functioningTimerModel!.totalQuestions && model.functioningTimerModel!.reviewPeriod == 0) || model.functioningTimerModel!.reviewPeriodRunning)
                }
                .padding()
                .alert(isPresented: self.$timerDone){
                    Alert(
                        title: Text("timer done!"), dismissButton: .default(Text("ok"), action: {
                        //AudioServicesDisposeSystemSoundID(1000) // uncomment if u want your ears to hate u
                            model.functioningTimerModel!.timerDone = false
                            model.functioningTimerModel!.reset()
                            self.timerDone = false
                            dismiss()
                    }))
                }
                Spacer()
                NavigationLink {
                    MinimalistTimerView(questionTimeLimitSecs: 120, rectangleHeightProportion: 1)
                } label: {
                    Image(systemName: "eye.slash")
                        .foregroundColor(model.colors[model.selectedTestTimer!.colorIndex])
                        .imageScale(.large)
                }
                Spacer()
                
            }
            //update view on each timer increment. at some point need to move the timer itself into this view.
            .onReceive(model.functioningTimerModel!.timer) { _ in
                model.functioningTimerModel!.updateCountdowns()
                timePerQuestionRemainingView = model.functioningTimerModel!.timeRemainingThisQuestionAsString
                totalTimeRemainingView = model.functioningTimerModel!.timeRemainingAsString
                if model.functioningTimerModel!.timerDone == true {
                    self.timerDone = true
                    AudioServicesPlaySystemSound(SystemSoundID(1000))
                }
            }
            
                    
        }
        .navigationBarBackButtonHidden(true)    }
}
