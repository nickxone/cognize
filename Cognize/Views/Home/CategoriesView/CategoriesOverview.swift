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
                center: .center,
                angle: rotation
            )
            .blur(radius: 12)
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
        let allBlends = categories.flatMap { category in
            let uiColor = UIColor(category.color)
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

            return [
                Color(hue: Double(h), saturation: Double(s * 0.8), brightness: Double(b * 1.1), opacity: 0.3),
                Color(hue: Double((h + 0.05).truncatingRemainder(dividingBy: 1.0)), saturation: Double(s * 0.6), brightness: Double(b), opacity: 0.4),
                Color(hue: Double((h + 0.1).truncatingRemainder(dividingBy: 1.0)), saturation: Double(s * 0.4), brightness: Double(b * 0.9), opacity: 0.25)
            ]
        }

        return allBlends.isEmpty ? [.blue, .green, .purple] : allBlends + allBlends.reversed()
    }
}

#Preview {
    @Previewable @State var categories: [Category] = []
    CategoriesOverview(categories: categories)
}
