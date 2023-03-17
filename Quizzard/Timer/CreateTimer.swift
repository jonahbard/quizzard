//
//  CreateTimer.swift
//  Quizzard
//
//  Created by Jonah Bard on 2/28/23.
//

import SwiftUI

struct CreateTimer: View {
    @EnvironmentObject var model: UserDataModel

    @State var testNameField = ""
    @State var timeLimitMin = 30
    @State var numberOfQuestions = 20
    @State var colorIndex = Int.random(in: 0..<5)
    
    @State var notEnoughTimeDialogShowing = false
    @State var makeATitleDialogShowing = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(){
                    TextField("test name", text: $testNameField)
                        .padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7))
                        .font(.title3).fontWeight(.medium)
                        .textInputAutocapitalization(.never)
                    
                    Picker("time limit", selection: $timeLimitMin) {
                        ForEach(1...90, id: \.self) { number in
                            if number == 1 {
                                Text("\(number) minute")
                            } else {
                                Text("\(number) minutes")
                            }
                        }
                    }.pickerStyle(WheelPickerStyle())
                    
                    Picker("time limit", selection: $numberOfQuestions) {
                        ForEach(2...150, id: \.self) { number in
                            Text("\(number) questions")
                        }
                    }.pickerStyle(WheelPickerStyle())
                    
                    ColorPicker(selectedColorIndex: $colorIndex)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                }
                
                //ColorSelector
            }
            .navigationBarTitle("create timer")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button("cancel"){
                        dismiss()
                    }.foregroundColor(.red)
                })
                ToolbarItem {
                    Button("save") {
                        if testNameField != "" && (timeLimitMin*60)/numberOfQuestions >= 5 {
                            model.userTimerList.append(TestTimer(reviewPeriod: 2, lengthMin: timeLimitMin, colorIndex: colorIndex, title: testNameField, numberOfQuestions: numberOfQuestions))
                            dismiss()
                        } else if (timeLimitMin*60)/numberOfQuestions < 5 {
                            notEnoughTimeDialogShowing = true
                        } else {
                            makeATitleDialogShowing = true
                        }
                        //Navigate to the preview of this timer?
                        
                        //model.selectedTestTimerIndex = model.newTestTimerIndex
                        
                        //model.functioningTimerModel = FunctioningTimerModel(length: model.userTimerList[model.selectedTestTimerIndex!].lengthMin, questions: model.userTimerList[model.selectedTestTimerIndex!].numberOfQuestions)
                        
                        //model.selectedTestTimerIndex =
                    }
                    .alert(isPresented: $makeATitleDialogShowing){
                        Alert(title: Text("hmmm... 🤔"), message: Text("your test needs a name!"))
                    }
                }
            }.alert(isPresented: $notEnoughTimeDialogShowing){
                Alert(title: Text("slow down there, cowboy 🤠"), message: Text("are you sure you have enough time for each question?"))
            }
            
            
        }
        
    }
}

struct CreateTimer_Previews: PreviewProvider {
    static var previews: some View {
        CreateTimer(testNameField: "Test Name", timeLimitMin: 0, numberOfQuestions: 0)
            .environmentObject(UserDataModel())
    }
}
