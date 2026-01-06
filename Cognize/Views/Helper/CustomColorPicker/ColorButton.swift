//
//  ColorButton.swift
//  Cognize
//
//  Created by Matvii Ustich on 31/07/2025.
//

import SwiftUI

struct ColorButton: View {
    let selectedColor: Color
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action){
            Label(
                title: {
                    Text("Colour")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                },
                icon: {
                    Image(systemName: "paintpalette.fill")
                        .tint(.white)
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .background {
                            Circle()
                                .fill(selectedColor.gradient)
                        }
                        .glassEffect()
//                        .glass(shadowColor: .black)
                }
            )
            .labelStyle(.colourLabelStyle)
        }
    }
}

extension LabelStyle where Self == ColourLabelStyle {
    static var colourLabelStyle: ColourLabelStyle {
        ColourLabelStyle()
    }
}

struct ColourLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
            configuration.title
        }
    }
}

#Preview {
    ColorButton(selectedColor: .blue) {
        
    }
}
