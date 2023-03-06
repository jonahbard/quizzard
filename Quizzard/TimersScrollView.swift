//
//  TimersScrollView.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/14/23.
//

import SwiftUI

struct TimersScrollView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        ScrollView {
            VStack {
            }
        }
    }
}

struct TimersScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TimersScrollView()
            .environmentObject(Model())
    }
}
