//
//  ColorSlider.swift
//  Cognize
//
//  Created by Matvii Ustich on 31/07/2025.
//

import Foundation
import SwiftUI
import UIKit

struct ColorSlider: View {
    
    // MARK: Public
    
    @Binding var value: CGFloat
    var range: ClosedRange<CGFloat>
    @Binding var selectedColor: Color
    
    init(value: Binding<CGFloat>, range: ClosedRange<CGFloat>, selectedColor: Binding<Color>) {
        self._value = value
        self.range = range
        self._selectedColor = selectedColor
    }
    
    // MARK: - Private
    
    @State private var lastOffset: CGFloat = 0
    
    private var leadingOffset: CGFloat = -2
    private var trailingOffset: CGFloat = -2
    
    private var knobSize: CGSize = CGSize(width: 32, height: 32)
    
    var trackGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                selectedColor.adjust(brightness: range.upperBound),
                selectedColor,
                selectedColor.adjust(brightness: range.lowerBound)
            ]),
            startPoint: .leading,
            endPoint: .trailing)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .frame(height: 16)
                    .foregroundStyle(self.trackGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(trackGradient, lineWidth: 2)
                    )
                HStack {
                    Circle()
                        .fill(selectedColor.adjust(brightness: value))
                        .overlay {
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        }
                        .shadow(radius: 8, y: 5)
                        .frame(width: knobSize.width, height: knobSize.height)
                        .foregroundColor(.white)
                        .offset(x: knobOffset(in: geometry))
                        .gesture(dragGesture(in: geometry))
                    Spacer()
                }
            }
        }
    }
}

private extension ColorSlider {
    private func knobOffset(in geometry: GeometryProxy) -> CGFloat {
        let outputRange = min(self.leadingOffset, geometry.size.width - self.knobSize.width - self.trailingOffset)
        ... max(self.leadingOffset, geometry.size.width - self.knobSize.width - self.trailingOffset)
        
        return (geometry.size.width - self.knobSize.width - self.trailingOffset)
        - self.$value.wrappedValue.map(from: self.range, to: outputRange)
    }
    
    
    private func dragGesture(in geometry: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if abs(value.translation.width) < 0.1 {
                    self.lastOffset = (geometry.size.width - self.knobSize.width - self.trailingOffset) - self.$value.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset))
                }
                
                let sliderPos = max(0 + self.leadingOffset, min(self.lastOffset + value.translation.width, geometry.size.width - self.knobSize.width - self.trailingOffset))
                let sliderVal = (geometry.size.width - self.knobSize.width - self.trailingOffset - sliderPos).map(from: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), to: self.range)
                
                self.value = sliderVal
            }
    }
}

#Preview {
    @Previewable @State var value: CGFloat = 0
    @Previewable @State var color = Color.blue
    VStack {
        Rectangle()
            .fill(color)
            .brightness(value)
            .overlay {
                Text("\(value)")
            }
        ColorSlider(value: $value, range: -0.5...0.5, selectedColor: $color)
            .padding()
    }
}
