//
//  SettingsView.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/20/23.
//

import SwiftUI

struct SettingsView: View {
    @State var timeCurvingOn = false
    
    func clearAllSettingsAndData() {
        return
    }
    
    func showTutorial() {
        return
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("default review period")
                }
                Section {
                    Toggle("time curving", isOn: $timeCurvingOn)
                        .toggleStyle(.switch)
                }
                Section {
                    Text("color scheme")
                }
                Section {
                    Button {
                        clearAllSettingsAndData()
                    } label: {
                        Text("clear all settings and data")
                            .foregroundColor(.red)
                    }
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
                        showTutorial()
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }
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
