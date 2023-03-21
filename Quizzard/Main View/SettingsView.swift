//
//  SettingsView.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/20/23.
//

import SwiftUI

struct SettingsView: View {
    @State var timeCurvingOn = false
    @State var tutorialSheetPresent = false

    @EnvironmentObject var model: UserDataModel

    func clearAllSettingsAndData() {
        model.userTimerList.removeAll()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("review period: coming soon")
                }
                Section {
                    Text("time curving: coming soon")
//                    Toggle("time curving", isOn: $timeCurvingOn)
//                        .toggleStyle(.switch)
                }
                Section {
                    Text("alarm sound")
                }
                Section {
                    Button {
                        clearAllSettingsAndData()
                    } label: {
                        Text("clear all settings and data")
                            .foregroundColor(.red)
                    }//.alert(Text("cleared!"), isPresented: <#T##Binding<Bool>#>), actions: )
                }
                Section {
                    Text("feedback")
                    Text("contact me")
                }
            }
            .navigationBarTitle("settings & info")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        tutorialSheetPresent = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }
                }
            }
            .sheet(isPresented: $tutorialSheetPresent){
                TutorialView()
            }

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
