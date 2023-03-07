//
//  Timer.swift
//  Quizzard
//
//  Created by Jonah Bard on 1/14/23.
//

import Foundation
import UIKit
import SwiftUI

struct TestTimer: Identifiable, Hashable, Codable {
    var id = UUID()
    var note: String = ""
    var lengthMin: Int
    var colorIndex: Int
    var title: String
    var numberOfQuestions: Int
}
