//
//  TimerPreviewScreen.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/14/23.
//

import SwiftUI

struct TimerPreview: View {
    
    let indexInTimerList: Int
    
    @EnvironmentObject var model: UserDataModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var notes: String
    @State var reviewPeriodLengthSeconds = 300
    @State var editMode = false
    @State var deleteDialogShowing = false

    
    @FocusState var notesFocused: Bool
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                .cornerRadius(40)
                .padding()
                .shadow(color: .gray, radius: 10)
                .edgesIgnoringSafeArea(.bottom)
                .foregroundStyle(.regularMaterial)
                Rectangle()
                .cornerRadius(40)
                .padding()
                .edgesIgnoringSafeArea(.bottom)
                .foregroundColor(model.colors[model.selectedTestTimer!.colorIndex]).opacity(0.5)
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Button {
                            editMode = true
                        } label: {
                            Image(systemName: "pencil")
                                .fontWeight(.black)
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 45, leading: 10, bottom: 30, trailing: 0))
                                .imageScale(.large)
                        }
                    }
                    
                    Text(model.selectedTestTimer!.title)
                        .fontWeight(.heavy)
                        .font(Font.system(.title))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.01, trailing: 0))
                    
                    Text("\(model.selectedTestTimer!.lengthMin) Minutes •  \(model.selectedTestTimer!.numberOfQuestions) Questions")
                        .font(Font.system(.title3).smallCaps())
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    
//                    Text("my review period: 5:00")
//                        .font(Font.system(.headline))
//                        .foregroundColor(.black)
//                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                    
                    Text("time per question: \(model.selectedTestTimer!.lengthMin / model.selectedTestTimer!.numberOfQuestions):" + ( ((((model.selectedTestTimer!.lengthMin*60)/model.selectedTestTimer!.numberOfQuestions)%60) < 10) ? "0" : "") + "\((((model.selectedTestTimer!.lengthMin*60)/model.selectedTestTimer!.numberOfQuestions)%60))")
                        .font(Font.system(.headline))
                        .foregroundColor(.black.opacity(0.4))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                    
                    HStack {
                        Spacer()
                        NavigationLink {
                            MainTimerView()
                                .onAppear(perform: {
                                    model.functioningTimerModel!.start()
                                })
                        } label: {
                            Text("start session")
                        }
                        .buttonStyle(.bordered)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                        Spacer()
                    }
                    ZStack {
                        Rectangle()
                            .cornerRadius(20)
                            .frame(height: 270)
                            .foregroundStyle(.regularMaterial).opacity(0.4)
                        TextField(model.selectedTestTimer!.note == "" ? "Add a note..." : model.selectedTestTimer!.note, text: $notes, axis: .vertical)
                            .focused($notesFocused)
                            .frame(width: 270, height: 240, alignment: .topLeading)
                            .lineLimit(3...)
                            .submitLabel(.return)
                            .onSubmit({return})
                            .toolbar{
                                ToolbarItem(placement: .keyboard){
                                    Spacer()
                                }
                                ToolbarItem(placement: .keyboard){
                                    Button("done"){
                                        notesFocused = false
                                        model.selectedTestTimer!.note = notes
                                    }
                                }
                            }
                        
                    }
//                    Button("Edit", role: .destructive, action: {print("edit mode!")})
                    Spacer()
                    HStack {
                        Spacer()
                        Button("delete timer") {
                            deleteDialogShowing = true
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.red)
                        .alert(isPresented: $deleteDialogShowing){
                            Alert(
                                title: Text("are you sure?"),
                                message: Text("this timer will be permanently deleted."),
                                primaryButton: .destructive(Text("delete"), action: {
                                    dismiss()
                                    model.userTimerList.remove(atOffsets: IndexSet(integer: indexInTimerList))
//                                    model.userTimerList.remove(at: model.selectedTestTimerIndex!)
//                                    model.resetIDs()
//                                    model.selectedTestTimerIndex = nil
//                                    model.selectedTestTimer = nil
//                                    model.functioningTimerModel = nil
                                }),
                                secondaryButton: .cancel(Text("cancel"))
                            )
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 45, bottom: 0, trailing: 45))
            }
            .ignoresSafeArea(.keyboard)
            .sheet(isPresented: $editMode){
                EditTimer(indexInTimerList: self.indexInTimerList, testNameField: model.selectedTestTimer!.title, timeLimitMin: model.selectedTestTimer!.lengthMin, numberOfQuestions: model.selectedTestTimer!.numberOfQuestions, colorIndex: model.selectedTestTimer!.colorIndex)
            }
        }
        
    }
}

//struct TimerPreviewScreen_Previews: PreviewProvider {
//    @EnvironmentObject var model: UserDataModel
//    static var previews: some View {
//        TimerPreview()
//            .environmentObject(UserDataModel())
//
//    }
//}
