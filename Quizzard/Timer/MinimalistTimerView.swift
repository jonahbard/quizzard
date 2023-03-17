//
//  MinimalistTimerView.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/13/23.
//

import SwiftUI

struct MinimalistTimerView: View {
    
    var questionTimeLimitSecs: Int
    @State var rectangleHeightProportion: Double
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model: UserDataModel
    
    @State var menuShown = false
    
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
                    .foregroundColor(model.colors[model.selectedTestTimer!.colorIndex])
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Text(String(model.functioningTimerModel!.currentQuestion))
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
                            print("trying to show menu")
                        } label: {
                            Text("· · ·").fontWeight(.black).foregroundColor(.black).font(.title3)
                        }.buttonStyle(.bordered)
                    } else {
                        HStack {
                            Button("back"){
                                dismiss()
                            }
                            Text(" - ")
                            Button("nvm"){
                                menuShown = false
                            }
                        }
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
                withAnimation(.linear(duration: 1)){
                    resizeRectangle()
                }
                if model.functioningTimerModel!.timerDone {
                    dismiss()
                }
            }
        }
        .ignoresSafeArea(.all)

    }
}

struct MinimalistTimerView_Previews: PreviewProvider {
    static var previews: some View {
        MinimalistTimerView(questionTimeLimitSecs: 120, rectangleHeightProportion: 1)
    }
}
