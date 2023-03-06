//
//  EditTimer.swift
//  Quizzard
//
//  Created by Jonah Bard on 2/27/23.
//

import SwiftUI

struct EditTimer: View {
    
    let indexInTimerList: Int
    
    @EnvironmentObject var model: UserDataModel

    @State var testNameField: String
    @State var timeLimitMin: Int
    @State var numberOfQuestions: Int
    @State var colorIndex: Int
    
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
                    ZStack {
                        ColorPicker(selectedColorIndex: $colorIndex)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
                
                            
                //ColorSelector
                //Delete Timer
            }
            .navigationBarTitle("edit timer")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button("cancel"){
                        dismiss()
                    }.foregroundColor(.red)
                })
                ToolbarItem{
                    Button("save") {
                        if testNameField != "" && (timeLimitMin*60)/numberOfQuestions >= 5 {
                            model.userTimerList[indexInTimerList].title = testNameField
                            model.userTimerList[indexInTimerList].numberOfQuestions = numberOfQuestions
                            model.userTimerList[indexInTimerList].lengthMin = timeLimitMin
                            model.userTimerList[indexInTimerList].colorIndex = colorIndex
                            
                            model.selectedTestTimer = model.userTimerList[indexInTimerList]
                            
                            model.functioningTimerModel = FunctioningTimerModel(length: model.userTimerList[indexInTimerList].lengthMin, questions: model.userTimerList[indexInTimerList].numberOfQuestions)
                            
                            dismiss()
                        } else if (timeLimitMin*60)/numberOfQuestions < 5 {
                            notEnoughTimeDialogShowing = true
                        } else {
                            makeATitleDialogShowing = true
                        }
                    }
                    .alert(isPresented: $makeATitleDialogShowing){
                        Alert(title: Text("hmmm... 🤔"), message: Text("your test needs a name!"))
                    }
                }
            }
            .alert(isPresented: $notEnoughTimeDialogShowing){
                Alert(title: Text("slow down there, cowboy 🤠"), message: Text("are you sure you have enough time for each question?"))
            }
            
        }
        
    }
}

struct EditTimer_Previews: PreviewProvider {
    static var previews: some View {
        EditTimer(indexInTimerList: 0, testNameField: "Test Name", timeLimitMin: 0, numberOfQuestions: 0, colorIndex: 0)
    }
}
