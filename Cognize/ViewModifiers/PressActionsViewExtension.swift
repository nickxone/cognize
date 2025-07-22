//
//  PressActionsViewExtension.swift
//  Cognize
//
//  Created by Matvii Ustich on 22/07/2025.
//

import Foundation
import SwiftUI
 
extension View {
    func pressActions(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressActions(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}
