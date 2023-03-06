//
//  QuizzardApp.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/13/23.
//

import SwiftUI

@main
struct QuizzardApp: App {
    @StateObject private var model = UserDataModel()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(model)
        }
    }
}
