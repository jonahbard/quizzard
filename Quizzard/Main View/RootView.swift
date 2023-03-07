//
//  RootView.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/13/23.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var model: UserDataModel
    
    @State var createTimerSheetPresented = false
    @State var infoSheetPresented = false


    var body: some View {
        return GeometryReader { geometry in
            NavigationStack {
                VStack {
                    ScrollView {
                        Rectangle()
                            .frame(height: 120)
                            .foregroundColor(.clear)
                        VStack {
                            ForEach(0 ..< model.userTimerList.count, id: \.self) { index in
                                NavigationLink {
                                    TimerPreview(indexInTimerList: index, notes: model.userTimerList[index].note)
                                } label: {
                                    TimerPreviewBox(testTimer: model.userTimerList[index])
                                }.simultaneousGesture(TapGesture().onEnded{
                                    model.selectedTestTimerIndex = model.userTimerList[index].id
                                    model.selectedTestTimer = model.userTimerList[index]
                                    model.functioningTimerModel = FunctioningTimerModel(length: model.userTimerList[index].lengthMin, questions: model.userTimerList[index].numberOfQuestions)
                                })
                            }
                            .onDelete { indexSet in
                                model.userTimerList.remove(atOffsets: indexSet)
                            }
                        }
                    }
                    .overlay {
                        ZStack(alignment: .bottom) {
                            Color.gray.opacity(0.4)
                                .opacity(0.25)
                                .background(.ultraThinMaterial)
                                .shadow(color: .gray.opacity(0.5), radius: 10)
                            VStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(height:45)
                                HStack {
                                    Button (
                                        action: {
                                            createTimerSheetPresented = true
                                        }
                                    ) {
                                        Image(systemName: "plus")
                                            .imageScale(.large)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .padding(EdgeInsets(top: 10, leading: 18, bottom: 15, trailing: 0))
                                            .frame(alignment: .bottom)
                                        }
                                    Spacer()
                                    NavigationLink {
                                        SettingsView()
                                    } label: {
                                        Image(systemName: "gear")
                                            .imageScale(.large)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 15, trailing: 18))
                                            .frame(alignment: .bottom)
                                        }
                                }
                                HStack {
                                    Text("my timers 🧙‍♂️")
                                        .frame(alignment: .leading)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black).opacity(0.7)
                                    .padding(EdgeInsets(top: 0, leading: 18, bottom: 10, trailing: 0))
                                    Spacer()
                                }
                            }
                        }
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 100)
                        .frame(minHeight: 100, maxHeight: .infinity, alignment: .top)
                    }
                    .background(Color(.white))
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .sheet(isPresented: $createTimerSheetPresented){
                CreateTimer()
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(UserDataModel())
    }
}
