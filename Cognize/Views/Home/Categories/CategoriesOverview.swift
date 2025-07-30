//
//  CategoriesOverview.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI

struct CategoriesOverview: View {
    let categories: [Category]

    @State private var rotation: Angle = .zero

    var body: some View {
        ZStack {
            AngularGradient(
                gradient: Gradient(colors: generateMixedColors(from: categories)),
                center: dynamicGradientCenter(from: categories),
                angle: rotation
            )
            .blur(radius: 20)
            .animation(.linear(duration: 30).repeatForever(autoreverses: false), value: rotation)
            .onAppear {
                rotation = .degrees(360)
            }

            VStack {
                Text("All Categories")
                    .font(.title.bold())
                    .foregroundStyle(.primary)
                    .padding()

                CategoriesReportView()
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .cornerRadius(20)
        .shadow(radius: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .preferredColorScheme(.dark)
    }


    private func generateMixedColors(from categories: [Category]) -> [Color] {
        // Convert category colors to hue-sorted array of CGFloat
        let hues = categories.compactMap { category -> CGFloat? in
            let uiColor = UIColor(category.color)
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            guard uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return nil }
            return h
        }.sorted()

        // Interpolate hues between each pair for smoother transitions
        var interpolatedColors: [Color] = []

        for i in 0..<hues.count {
            let h1 = hues[i]
            let h2 = hues[(i + 1) % hues.count] // wrap around to make it a circle
            let steps = 6

            for step in 0..<steps {
                let t = CGFloat(step) / CGFloat(steps)
                let interpolatedHue = h1 + t * ((h2 - h1 + 1).truncatingRemainder(dividingBy: 1.0))
                let hue = interpolatedHue.truncatingRemainder(dividingBy: 1.0)

                interpolatedColors.append(
                    Color(hue: Double(hue), saturation: 0.6, brightness: 1.0, opacity: 0.4)
                )
            }
        }

        return interpolatedColors.isEmpty ? [.blue, .green, .purple] : interpolatedColors
    }
    
    private func dynamicGradientCenter(from categories: [Category]) -> UnitPoint {
        let hues = categories.compactMap { category -> CGFloat? in
            let uiColor = UIColor(category.color)
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            guard uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return nil }
            return h
        }

        guard !hues.isEmpty else { return .center }

        let avgHue = hues.reduce(0, +) / CGFloat(hues.count)
        let offset = CGFloat((avgHue - 0.5) * 0.25) // scale it down

        return UnitPoint(x: 0.5 + offset, y: 0.5 - offset)
    }
}

#Preview {
    @Previewable @State var categories: [Category] = []
    CategoriesOverview(categories: categories)
}
