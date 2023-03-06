//
//  Menu.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/13/23.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "plus")
                    .foregroundColor(Color(.darkGray))
                    .imageScale(.large)
                    .fontWeight(.bold)
                Text("New Timer")
                    .foregroundColor(Color(.darkGray))
                    .font(.headline)
            }
            .padding(.top, 100)
            HStack {
                Image(systemName: "chart.xyaxis.line")
                    .foregroundColor(Color(.darkGray))
                    .imageScale(.large)
                    .fontWeight(.heavy)
                Text("Stats")
                    .foregroundColor(Color(.darkGray))
                    .font(.headline)
            }
            .padding(.top, 30)
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(Color(.darkGray))
                    .imageScale(.large)
                    .fontWeight(.heavy)
                Text("Settings")
                    .foregroundColor(Color(.darkGray))
                    .font(.headline)
            }
            .padding(.top, 30)
            HStack {
                Image(systemName: "info")
                    .foregroundColor(Color(.darkGray))
                    .imageScale(.large)
                    .fontWeight(.heavy)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                Text("About")
                    .foregroundColor(Color(.darkGray))
                    .font(.headline)
            }
            .padding(.top, 30)
            Spacer()

        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.gray.opacity(0.3))
        .background(.ultraThinMaterial)
        .edgesIgnoringSafeArea(.all)
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
