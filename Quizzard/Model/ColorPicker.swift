//
//  ColorPicker.swift
//  Quizzard
//
//  Created by Jonah Bard on 3/3/23.
//

import SwiftUI

struct ColorPicker: View {
    
    @EnvironmentObject var model: UserDataModel
    
    @Binding var selectedColorIndex: Int
    
    var body: some View {
        HStack {
            ForEach(0..<model.colors.count, id: \.self) { i in
                Circle()
                    .foregroundColor(model.colors[i])
                        .frame(width: 35)
                        .padding(5)
                        .onTapGesture {selectedColorIndex = i}
                        .overlay{
                            ZStack {
                                Circle().stroke(selectedColorIndex == i ? .white : .clear, lineWidth: 5)
                                    .frame(width: 35)
                                Circle()
                                    .stroke(model.colors[i], lineWidth: selectedColorIndex == i ? 3 : 0)
                                    .frame(width:40)
                            }
                        }
            }
        }
        .padding()
    }
}
