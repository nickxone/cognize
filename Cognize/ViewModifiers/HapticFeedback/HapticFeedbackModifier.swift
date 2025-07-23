//
//  HapticFeedbackModifier.swift
//  Cognize
//
//  Created by Matvii Ustich on 23/07/2025.
//

import Foundation
import SwiftUI

enum HapticFeedbackType {
    case confirmHaptic, cancelHaptic, defaultHaptic
}

struct HapticFeedback: ViewModifier {
    var type: HapticFeedbackType
    
    private func feedbackValuesOnPress(type: HapticFeedbackType) -> (intensity: Float, sharpness: Float) {
        switch type {
            case .confirmHaptic: return (intensity: 0.5, sharpness: 0.2)
            case .cancelHaptic: return (intensity: 0.3, sharpness: 0.3)
            case .defaultHaptic: return (intensity: 0.3, sharpness: 0.5)
        }
    }
    
    private func feedbackValuesOnRelease(type: HapticFeedbackType) -> (intensity: Float, sharpness: Float) {
        switch type {
            case .confirmHaptic: return (intensity: 0.3, sharpness: 0.7)
            case .cancelHaptic: return (intensity: 0.3, sharpness: 0.3)
            case .defaultHaptic: return (intensity: 0.3, sharpness: 0.5)
        }
    }
    
    func body(content: Content) -> some View {
        let (onPressIntensity, onPressSharpness) = feedbackValuesOnPress(type: type)
        let (onReleaseIntensity, onReleaseSharpness) = feedbackValuesOnRelease(type: type)
        
        content
            .pressActions {
                HapticsEngine.shared.hapticFeedback(intensity: onPressIntensity, sharpness: onPressSharpness)
            } onRelease: {
                HapticsEngine.shared.hapticFeedback(intensity: onReleaseIntensity, sharpness: onReleaseSharpness)
            }

    }
}
