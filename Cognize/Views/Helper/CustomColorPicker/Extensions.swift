//
//  Extensions.swift
//  Cognize
//
//  Created by Matvii Ustich on 31/07/2025.
//

import Foundation
import SwiftUI

extension Color {
    func adjust(hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, opacity: CGFloat = 1) -> Color {
        let color = UIColor(self)
        var currentHue: CGFloat = 0
        var currentSaturation: CGFloat = 0
        var currentBrigthness: CGFloat = 0
        var currentOpacity: CGFloat = 0
        
        if color.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentOpacity) {
            return Color(hue: currentHue + hue, saturation: currentSaturation + saturation, brightness: currentBrigthness + brightness, opacity: currentOpacity + opacity)
        }
        return self
    }
}

extension Color {
    static let green2 = Color(red: 60 / 255, green: 136 / 255, blue: 37 / 255)
    static let green3 = Color(red: 143 / 255, green: 197 / 255, blue: 112 / 255)
    static let gold = Color(red: 255 / 255, green: 215 / 255, blue: 0)
    static let lightGreen = Color(red: 173 / 255, green: 255 / 255, blue: 47 / 255)
    static let darkGray = Color(red: 105 / 255, green: 105 / 255, blue: 105 / 255)
}

extension CGFloat {
    func map(from inputRange: ClosedRange<CGFloat>, to outputRange: ClosedRange<CGFloat>) -> CGFloat {
        // Ensure the input range is valid to prevent division by zero
        guard inputRange.lowerBound != inputRange.upperBound else {
            return outputRange.lowerBound // Return the lower bound of the target range if the input range is zero
        }
        
        // Normalize the value to a 0-1 range within the input range
        let normalizedValue = (self - inputRange.lowerBound) / (inputRange.upperBound - inputRange.lowerBound)
        
        // Map the normalized value to the target range
        return normalizedValue * (outputRange.upperBound - outputRange.lowerBound) + outputRange.lowerBound
    }
}
