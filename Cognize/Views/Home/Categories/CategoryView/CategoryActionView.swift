//
//  CategoryActionView.swift
//  Cognize
//
//  Created by Matvii Ustich on 30/07/2025.
//

import SwiftUI
import FamilyControls

struct CategoryActionView: View {
    let category: Category
    
    @State private var showCreateIntentionView = false
    
    var body: some View {
        ZStack {
            // Background
            AngularGradient(
                gradient: Gradient(colors: gradientColors(from: category.color)),
                center: gradientCenter(for: category.color),
            )
            .blur(radius: 50)
            
            VStack {
                Spacer()
                
                Button {
                    showCreateIntentionView = true
                } label: {
                    Text("Create Intention")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            ZStack {
                                Capsule()
                                    .fill(category.color.gradient)
                                Capsule()
                                    .fill(.black.opacity(0.2))
                            }
                            .clipShape(Capsule())
                        }
                        .foregroundStyle(.white)
                }
                //                .disabled(reason.isEmpty)
            }
            .padding()
            
        }
        .frame(width: UIScreen.main.bounds.width - 60,
               height: UIScreen.main.bounds.height * 0.2)
        .cornerRadius(20)
        .shadow(color: category.color.opacity(0.25), radius: 12, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(category.color.opacity(0.15), lineWidth: 1)
        )
        .sheet(isPresented: $showCreateIntentionView) {
            IntentionCreationView(category: category)
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
        
        let offset = CGFloat((hue - 0.5) * 0.2)
        return UnitPoint(x: 0.5 + offset, y: 0.5 - offset)
    }
}

#Preview {
    let appSelection = FamilyActivitySelection()
    let category = Category(name: "Social", appSelection: appSelection, restrictionType: .shield, color: .green)
    CategoryActionView(category: category)
}
