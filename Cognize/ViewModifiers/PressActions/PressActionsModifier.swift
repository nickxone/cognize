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
    
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        if !isPressed {
                            onPress()
                            isPressed.toggle()
                        }
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}
