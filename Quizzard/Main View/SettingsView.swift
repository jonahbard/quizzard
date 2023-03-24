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
    @State var resetAlertShowing = false

    @EnvironmentObject var model: UserDataModel

    func clearAllSettingsAndData() {
        model.userTimerList.removeAll()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("the following features coming soon...") {
                    Text("default review period")
                    Text("question auto-navigation")
                    Text("time curving")
                    Text("alarm sound")
                }
                    
                Section {
                    Button {
                        resetAlertShowing = true
                    } label: {
                        Text("clear all data")
                            .foregroundColor(.red)
                    }.alert(isPresented: $resetAlertShowing){
                        Alert (
                            title: Text("are you sure?"),
                            message: Text("all of your timers will be removed."),
                            primaryButton: .destructive(Text("clear"), action: {
                                clearAllSettingsAndData()
                            }),
                            secondaryButton: .cancel(Text("cancel"))
                        )
                    }
                        
                }
                Section {
                    Link("contact me", destination: URL(string: "mailto:jonahbard@gmail.com")!)
                }
            }
            .navigationBarTitle("settings & info")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        tutorialSheetPresent = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.orange)
                            .fontWeight(.semibold)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }
                }
            }
            .sheet(isPresented: $tutorialSheetPresent){
                TutorialView() {
                    return
                }
            }

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

//default review period

//clear all data

//contact

//time curving / questions take progressively more/less time

//tutorial

//about the app/me

//color scheme for timers?
//default review period
//font?
//background color/dark mode?
//app icon?
//60+minutes, or show hours on timer?
//background?
