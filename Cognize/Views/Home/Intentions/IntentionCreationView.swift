//
//  IntentionLogCreationView.swift
//  Cognize
//
//  Created by Matvii Ustich on 30/07/2025.
//

import SwiftUI
import FamilyControls
import SwiftData

struct IntentionCreationView: View {
    //    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let category: Category
    
    @State private var reason: String = ""
    @State private var duration: Int = 10
    
    var body: some View {
        ZStack {
            // Background
            AngularGradient(
                gradient: Gradient(colors: gradientColors(from: category.color)),
                center: gradientCenter(for: category.color),
                angle: .degrees(360)
            )
            .blur(radius: 20)
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Log Your Intention")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    TextField("What's your intention?", text: $reason)
                        .padding()
                        .background(.black.opacity(0.25))
                        .cornerRadius(12)
                    
                    HStack {
                        Text("Break duration:")
                            .padding(.leading)
                        
                        Spacer()
                        
                        Picker("Break duration", selection: $duration) {
                            ForEach(1...30, id: \.self) { minute in
                                Text("\(minute)").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80, height: 130)
                        .clipped()
                        .compositingGroup()
                        .padding(-8)
                        
                        Text("minute\(duration == 1 ? "" : "s")")
                            .padding(.trailing)
                    }
                    .padding()
                    .background(.black.opacity(0.25))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
//                    .background(.black.opacity(0.25))
//                    .cornerRadius(12)
                }
                
                Spacer()
                
                Group {
                    Button {
                        let _ = IntentionLog(category: category, reason: reason, duration: duration)
                        //                    modelContext.insert(log)
                        dismiss()
                    } label: {
                        Text("Save Intention")
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
                    .disabled(reason.isEmpty)
                    .opacity(reason.isEmpty ? 0.6 : 1)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.gray.gradient.opacity(0.25), in: Capsule())
                            .foregroundStyle(.white)
                    }
                    .padding(.top, -15)
                }

                
            }
            .padding()
        }
        .gesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )
        
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Helpers
    private func gradientColors(from base: Color) -> [Color] {
        let uiColor = UIColor(base)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            return [base.opacity(0.6), base.opacity(0.3), base.opacity(0.6)]
        }
        
        let c1 = Color(hue: Double(h), saturation: Double(s), brightness: Double(b * 1.1), opacity: 0.3)
        let c2 = Color(hue: Double((h + 0.03).truncatingRemainder(dividingBy: 1)), saturation: Double(s * 0.9), brightness: Double(b), opacity: 0.4)
        let c3 = Color(hue: Double((h + 0.06).truncatingRemainder(dividingBy: 1)), saturation: Double(s * 0.7), brightness: Double(b * 0.9), opacity: 0.25)
        
        return [c1, c2, c3, c1]
    }
    
    private func gradientCenter(for color: Color) -> UnitPoint {
        let uiColor = UIColor(color)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        let offset = CGFloat((h - 0.5) * 0.2)
        return UnitPoint(x: 0.5 + offset, y: 0.5 - offset)
    }
}

#Preview {
    let appSelection = FamilyActivitySelection()
    let category = Category(name: "Social", appSelection: appSelection, restrictionType: .shield, color: .blue)
    IntentionCreationView(category: category)
}
