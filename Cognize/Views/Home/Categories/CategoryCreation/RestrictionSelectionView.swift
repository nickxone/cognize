//
//  RestrictionSelection.swift
//  Cognize
//
//  Created by Matvii Ustich on 02/08/2025.
//

import SwiftUI
import FamilyControls

struct RestrictionSelectionView: View {
    let color: Color
    @Binding var restrictionType: Category.RestrictionType
    @Binding var appSelection: FamilyActivitySelection
    @Binding var limitType: ShieldRestriction.LimitType
    
    let backAction: () -> ()
    let doneAction: () -> ()
    
    @State private var showActivityPicker = false
    
    var body: some View {
        ZStack {
            // Background
            AngularGradient(
                gradient: Gradient(colors: gradientColors(from: color)),
                center: gradientCenter(for: color),
                angle: .degrees(360)
            )
            .blur(radius: 20)
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Choose Restriction Type")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 50)
                
                Picker("Restriction Type", selection: $restrictionType) {
                    Text("Shield").tag(Category.RestrictionType.shield)
                    Text("Interval").tag(Category.RestrictionType.interval)
                    Text("Allow").tag(Category.RestrictionType.allow)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                Text(restrictionDescription(for: restrictionType))
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack {
                    Text("Apps")
                    Spacer()
                    Group {
                        Text(appSelectionText)
                        Image(systemName: "chevron.forward")
                    }
                    .foregroundStyle(.gray)
                }
                .font(.callout)
                .padding()
                .glass(gradientOpacity: 0.3, gradientStyle: .reverted, shadowColor: .clear)
                .onTapGesture {
                    showActivityPicker = true
                }
                
                VStack {
                    HStack {
                        Text("Limit Type")
                        Spacer()
                        Picker("Limit Type", selection: $limitType) {
                            Text("Time Limit").tag(ShieldRestriction.LimitType.timeLimit).foregroundStyle(.gray)
                            Text("Open Limit").tag(ShieldRestriction.LimitType.openLimit).foregroundStyle(.gray)
                        }
                        .tint(.gray)
                    }
//                    Divider()
//                    switch limitType {
//                    case .timeLimit:
//                        TimeLimitView(restriction: $restriction)
//                    case .openLimit:
//                        OpenLimitView(restriction: $restriction)
//                    }
                }
                .padding()
                .glass(gradientOpacity: 0.3, gradientStyle: .normal, shadowColor: .clear)
                
                Button {
                    doneAction()
//                    let category = Category(name: name, appSelection: appSelection, restrictionType: restrictionType, color: color)
//                    categories.append(category)
//                    switch restrictionType {
//                    case .shield:
//                        (category.strategy as! ShieldRestriction).shield()
//                    case .interval:
//                        (category.strategy as! IntervalTrackRestriction).track(thresholdUsageMinutes: 2, duringIntervalMinutes: 15)
//                    case .allow:
//                        print("Allow")
//                    }
//                    store.save(categories)
//                    showRestrictionView = false
//                    dismiss()
                } label: {
                    Text("Done")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            ZStack {
                                Capsule().fill(color.gradient)
                                Capsule().fill(.black.opacity(0.2))
                            }
                            .clipShape(Capsule())
                        }
                        .foregroundStyle(.white)
                }
                //                .padding(.horizontal)
                .padding(.top, -8)
            }
            .padding()
        }
        .overlay(alignment: .topLeading) {
            Button {
                backAction()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.callout)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background {
                        Circle()
                            .fill(.ultraThinMaterial)
                    }
                    .padding(12)
            }
            .hapticFeedback(.cancelHaptic)
        }
        .fullScreenCover(isPresented: $showActivityPicker) {
            CustomActivityPicker(activitySelection: $appSelection, color: color)
        }
        .preferredColorScheme(.dark)
        .interactiveDismissDisabled()
        
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
    
    private func restrictionDescription(for type: Category.RestrictionType) -> String {
        switch type {
        case .shield:
            return "Apps in this category will be fully blocked until you return to Cognize."
        case .interval:
            return "Apps will be available until you exceed a limit in a short interval (e.g. 15 mins)."
        case .allow:
            return "Apps are always available, but usage can be tracked or limited gently."
        }
    }
    
    private var appSelectionText: String {
        var text = ""
        let categoriesCount = appSelection.categories.count
        let appsCount = appSelection.applications.count
        
        if categoriesCount > 0 {
            text.append("\(categoriesCount) \(categoriesCount == 1 ? "category" : "categories")")
        }
        
        if appsCount > 0 {
            text.append(", \(appsCount) \(appsCount == 1 ? "app" : "apps")")
        }
        
        if text.isEmpty {
            text = "No apps selected"
        }
        return text
    }
}

#Preview {
    @Previewable @State var restrictionType: Category.RestrictionType = .shield
    @Previewable @State var appSelection = FamilyActivitySelection()
    @Previewable @State var limitType: ShieldRestriction.LimitType = .timeLimit
    
    RestrictionSelectionView(color: .blue, restrictionType: $restrictionType, appSelection: $appSelection, limitType: $limitType) {
        
    } doneAction: {
        
    }

}
