//
//  Background.swift
//  Cognize
//
//  Created by Matvii Ustich on 07/08/2025.
//

import SwiftUI

struct ColorfulBackground: View {
    let color: Color
    let animate: Bool
    
    @State private var rotation: Angle = .degrees(0)
    
    var body: some View {
        AngularGradient(
            gradient: Gradient(colors: gradientColors(from: color)),
            center: gradientCenter(for: color),
            angle: rotation
        )
        .blur(radius: 12)
        .animation(.linear(duration: 15).repeatForever(autoreverses: false), value: rotation)
        .onAppear {
            if animate {
                rotation = .degrees(360)
            }
        }
    }
    
    // MARK: - Helpers
    private func gradientColors(from base: Color) -> [Color] {
        let uiColor = UIColor(base)
        var hue: CGFloat = 0, sat: CGFloat = 0, bri: CGFloat = 0, alpha: CGFloat = 0

        guard uiColor.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha) else {
            return [base.opacity(0.6), base.opacity(0.3), base.opacity(0.6)]
        }

        let color1 = Color(hue: Double(hue), saturation: Double(sat * 0.9), brightness: Double(bri * 1.1), opacity: 0.4)
        let color2 = Color(hue: Double(hue + 0.03).truncatingRemainder(dividingBy: 1.0), saturation: Double(sat * 0.7), brightness: Double(bri * 0.9), opacity: 0.5)
        let color3 = Color(hue: Double(hue + 0.08).truncatingRemainder(dividingBy: 1.0), saturation: Double(sat * 0.6), brightness: Double(bri), opacity: 0.3)

        return [color1, color2, color3, color1]
    }

    private func gradientCenter(for color: Color) -> UnitPoint {
        let uiColor = UIColor(color)
        var hue: CGFloat = 0, sat: CGFloat = 0, bri: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)

        let offset = CGFloat((hue - 0.5) * 0.2)
        return UnitPoint(x: 0.5 + offset, y: 0.5 - offset)
    }
}

#Preview {
    ColorfulBackground(color: .blue, animate: false)
}
