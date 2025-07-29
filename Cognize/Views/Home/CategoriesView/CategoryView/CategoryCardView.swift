//
//  CategoryView.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI
import FamilyControls

struct CategoryCardView: View {
    @State private var rotation: Angle = .zero
    let category: Category
    
    var body: some View {
        VStack {
            VStack {
                Text(category.name)
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                    .padding()
                
                CategoryReportView(category: category)
            }
            .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.height * 0.6)
            .background(
                AngularGradient(
                    gradient: Gradient(colors: gradientColors(from: category.color)),
                    center: gradientCenter(for: category.color),
                    angle: rotation
                )
                .blur(radius: 10)
                .animation(.linear(duration: 15).repeatForever(autoreverses: false), value: rotation)
            )
            .onAppear {
                rotation = .degrees(360)
            }
            .cornerRadius(20)
            .shadow(color: category.color.opacity(0.25), radius: 12, x: 0, y: 6)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(category.color.opacity(0.15), lineWidth: 1)
            )
            
            Spacer()
        }
        .preferredColorScheme(.dark)
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

        // Map hue [0,1] to a subtle offset [-0.1, 0.1]
        let offset = CGFloat((hue - 0.5) * 0.2)
        return UnitPoint(x: 0.5 + offset, y: 0.5 - offset)
    }
}

#Preview {
    let appSelection = FamilyActivitySelection()
    let category = Category(name: "Social", appSelection: appSelection, restrictionType: .shield, color: .green)
    CategoryCardView(category: category)
    
}
