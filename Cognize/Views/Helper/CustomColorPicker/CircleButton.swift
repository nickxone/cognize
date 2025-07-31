//
//  CircleButton.swift
//  Cognize
//
//  Created by Matvii Ustich on 31/07/2025.
//

import SwiftUI

struct CircleButton: View {
    let item: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Circle()
            .fill(item)
            .frame(width: 32, height: 32)
            .overlay {
                Circle()
                    .stroke(item.adjust(brightness: -0.2), lineWidth: 2)
            }
            .padding(5)
            .overlay {
                if isSelected {
                    Circle()
                        .stroke(Color.accentColor, lineWidth: 3)
                }
            }
            .onTapGesture(perform: action)
    }
}

#Preview {
    VStack {
        CircleButton(item: .red, isSelected: true, action: {})
        CircleButton(item: .red, isSelected: false, action: {})
    }
}
