//
//  PressActions.swift
//  Cognize
//
//  Created by Matvii Ustich on 22/07/2025.
//

import Foundation
import SwiftUI


struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    @GestureState private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed, body: { _, state, _ in
                        if !state {
                            state = true
                            onPress()
                        }
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}
