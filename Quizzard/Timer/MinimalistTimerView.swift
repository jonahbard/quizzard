//
//  MinimalistTimerView.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/13/23.
//

import SwiftUI

struct MinimalistTimerView: View {
    
    var questionTimeLimitSecs: Int
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model: UserDataModel
    
    @State var menuShown = false
    @State var rectangleHeightProportion = 1.0
    @State var paused = false
    
    //resize, called each timer run and animated for smoothness
    func resizeRectangle(){
        if rectangleHeightProportion > 0 && rectangleHeightProportion > model.functioningTimerModel!.timeRemainingThisQuestionProportion {
            withAnimation(.linear(duration: 1)){
                rectangleHeightProportion = model.functioningTimerModel!.timeRemainingThisQuestionProportion
            }
        } else if rectangleHeightProportion < model.functioningTimerModel!.timeRemainingThisQuestionProportion {
            withAnimation(.none){
                rectangleHeightProportion = model.functioningTimerModel!.timeRemainingThisQuestionProportion
            }
        }
    }
    
    //reset
    func resetRectangle(){
        withAnimation(.none){
            rectangleHeightProportion = 1
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // the actual rectangle that moves with the timer
                Rectangle()
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height*rectangleHeightProportion)
                    .opacity(0.5)
                    .foregroundColor(model.colors[model.selectedTestTimer!.colorIndex].opacity(0.5))
                // current question
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Text(model.functioningTimerModel!.reviewPeriodRunning ? "review!" : String(model.functioningTimerModel!.currentQuestion))
                        .animation(.none)
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(rectangleHeightProportion > 0 ? .black : .red)
                    Spacer()
                }
                //menu view + function
                VStack {
                    Rectangle().foregroundColor(.clear).frame(height: 55)
                    if !menuShown {
                        Button {
                            menuShown = true
                        } label: {
                            Text("· · ·")
                                .fontWeight(.black).foregroundColor(.black).font(.title3)
                        }.padding()
                    } else {
                        HStack {
                            Button("back"){
                                dismiss()
                            }.foregroundColor(.black)
                            Text(" - ")
                            Button(paused ? "resume" : "pause") {
                                if model.functioningTimerModel!.isPaused {
                                    paused = false
                                    model.functioningTimerModel!.resume()
                                } else {
                                    model.functioningTimerModel!.pause()
                                    paused = true
                                }
                            }.foregroundColor(.black)
                            Text(" - ")
                            Button("hide"){
                                menuShown = false
                            }.foregroundColor(.black)
                        }
                        .padding()

                    }
                    // invisible question increment/decrement
                    HStack {
                        Button {
                            model.functioningTimerModel!.backQuestion()
                            resetRectangle()
                        } label: {
                            Rectangle()
                                .opacity(0)
                                .frame(width: 2*geometry.size.width/5)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button {
                            model.functioningTimerModel!.nextQuestion()
                            resetRectangle()
                        } label: {
                            Rectangle()
                                .opacity(0)
                                .frame(width: 2*geometry.size.width/5)
                                .foregroundColor(.gray)
                        }

                    }
                }
            }
            //updater (should potentially give this own struct a timer at some point)
            .onReceive(model.functioningTimerModel!.timer) { _ in
                if !paused {resizeRectangle()}
                if model.functioningTimerModel!.timerDone {dismiss()}
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
        .statusBarHidden()
    }
}

struct MinimalistTimerView_Previews: PreviewProvider {
    static var previews: some View {
        MinimalistTimerView(questionTimeLimitSecs: 120, rectangleHeightProportion: 1)
    }
}
