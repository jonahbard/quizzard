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
    @State var rectangleHeightProportion: Double
    @State var paused = false
    
    func resizeRectangle(){
        if rectangleHeightProportion > 0 {
            rectangleHeightProportion = model.functioningTimerModel!.timeRemainingThisQuestionProportion
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height*rectangleHeightProportion)
                    .opacity(0.5)
                    .foregroundColor(model.colors[model.selectedTestTimer!.colorIndex].opacity(0.5))
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Text(model.functioningTimerModel!.reviewPeriodOn ? "review!" : String(model.functioningTimerModel!.currentQuestion))
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(rectangleHeightProportion > 0 ? .black : .red)
                    Spacer()
                }
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

                    HStack {
                        Button {
                            model.functioningTimerModel!.backQuestion()
                        } label: {
                            Rectangle()
                                .opacity(0)
                                .frame(width: 2*geometry.size.width/5)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button {
                            model.functioningTimerModel!.nextQuestion()
                        } label: {
                            Rectangle()
                                .opacity(0)
                                .frame(width: 2*geometry.size.width/5)
                                .foregroundColor(.gray)
                        }

                    }
                }
            }
            .onReceive(model.functioningTimerModel!.timer) { _ in
                if !paused {
                    withAnimation(.linear(duration: 1)){
                        resizeRectangle()
                    }
                }
                if model.functioningTimerModel!.timerDone {
                    dismiss()
                }
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
