//
//  HapticFeedbackViewExtension.swift
//  Cognize
//
//  Created by Matvii Ustich on 23/07/2025.
//

import Foundation
import SwiftUI
 
extension View {
    func hapticFeedback(_ type: HapticFeedbackType = .defaultHaptic) -> some View {
        modifier(HapticFeedback(type: type))
    }
}
