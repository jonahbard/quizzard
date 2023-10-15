//
//  TutorialView.swift
//  Quizzard
//
//  Created by Jonah Bard on 3/19/23.
//

import SwiftUI

typealias action = () -> Void


struct TutorialView: View {
    
    
    // view declaration in Root must take an actual inline closure to set tutorialpresented to true
    init(handler: @escaping action) {
        self.handler = handler
    }
    
    
    @State private var pageIndex = 0
    @Environment(\.dismiss) var dismiss
    
    let handler: action
    let pages: [TutorialPage] = TutorialPage.pages
    let dotAppearance = UIPageControl.appearance()
    
    var body: some View {
        TabView(selection: $pageIndex){
            ForEach(pages) { page in
                VStack {
                    //display tutorial page
                    Spacer()
                    TutorialPageView(page: page)
                        .padding()
                    Spacer()
                    
                    //if last tutorial page, present dismiss button. handler takes in method action
                    if page.index+1==pages.count {
                        withAnimation {
                            Button("let's go!"){
                                dismiss()
                                handler()
                            }.buttonStyle(.bordered).buttonBorderShape(.capsule)
                        }
                    }
                    Spacer()
                    Spacer()
                    Spacer()

                }
                .tag(page.index)
            }
        }
        .animation(.easeInOut, value: pageIndex)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .black
            dotAppearance.pageIndicatorTintColor = .gray
        }
    }
    
    func nextPage(){
        pageIndex += 1
    }
    
    func backPage(){
        pageIndex -= 1
    }
    
    func firstPage(){
        pageIndex = 0
    }
    
    func dismissAndCreateFirstTimer(){
        dismiss()
    }
}

//struct TutorialView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialView()
//    }
//}
