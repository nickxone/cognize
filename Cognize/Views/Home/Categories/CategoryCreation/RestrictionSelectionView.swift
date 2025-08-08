//
//  RestrictionSelection.swift
//  Cognize
//
//  Created by Matvii Ustich on 02/08/2025.
//

// TODO: this view should initialise a Restriction class rather than different parameters
import SwiftUI
import FamilyControls

fileprivate enum RestrictionKind: String, CaseIterable, Identifiable {
    case shield, interval, allow
    var id: Self { self }
}

struct RestrictionSelectionView: View {
    let color: Color
    @Binding var configuration: RestrictionConfiguration
    let backAction: () -> ()
    let doneAction: () -> ()
    
    @State private var showActivityPicker = false
    @State private var appSelection = FamilyActivitySelection()
    @State private var selectedKind: RestrictionKind = .shield
    
    init(
        color: Color,
        configuration: Binding<RestrictionConfiguration>,
        backAction: @escaping () -> Void,
        doneAction: @escaping () -> Void
    ) {
        self.color = color
        self.backAction = backAction
        self.doneAction = doneAction
        
        // Initialize the @Binding wrapper itself
        _configuration = configuration
        
        // Initialize the @State wrapper based on the incoming binding’s value
        switch configuration.wrappedValue {
        case .shield:   _selectedKind = State(initialValue: .shield)
        case .interval: _selectedKind = State(initialValue: .interval)
        case .allow:    _selectedKind = State(initialValue: .allow)
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            ColorfulBackground(color: color, animate: true)
            
            VStack(spacing: 24) {
                Text("Choose Restriction Type")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 50)
                
                Picker("Restriction Type", selection: $selectedKind) {
                    Text("Shield").tag(RestrictionKind.shield)
                    Text("Interval").tag(RestrictionKind.interval)
                    Text("Allow").tag(RestrictionKind.allow)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: selectedKind) { _, newKind in
                    let sel = configuration.appSelection // keep the current selection
                    switch newKind {
                    case .shield:
                        configuration = .shield(.init(appSelection: sel, timeAllowed: 30, opensAllowed: 5))
                    case .interval:
                        configuration = .interval(.init(appSelection: sel, thresholdTime: 5, intervalLength: 30))
                    case .allow:
                        configuration = .allow(.init(appSelection: sel, hasLimit: false, timeLimit: 30))
                    }
                }
                
                Text(restrictionDescription)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                appSelectionRow
                
                restrictionLimitOptions
                
                Button {
                    doneAction()
                    
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
            //            CustomActivityPicker(activitySelection: $appSelection, color: color)
        }
        .preferredColorScheme(.dark)
        .interactiveDismissDisabled()
        
    }
    
    private var restrictionLimitOptions: some View {
        Group {
            //            switch configuration {
            //            case .shield:
            //                VStack {
            //                    HStack {
            //                        Text("Limit Type")
            //                        Spacer()
            //                        Picker("Limit Type", selection: $shieldLimitType) {
            //                            Text("Time Limit").tag(ShieldRestriction.LimitType.timeLimit).foregroundStyle(.gray)
            //                            Text("Open Limit").tag(ShieldRestriction.LimitType.openLimit).foregroundStyle(.gray)
            //                        }
            //                        .tint(.gray)
            //                    }
            //                    .frame(height: 30)
            //                    Divider()
            //                    Group {
            //                        switch shieldLimitType {
            //                        case .timeLimit:
            //                            HStack {
            //                                Text("Time Allowed")
            //                                Spacer()
            //                                Group {
            //                                    Button {
            //                                        if timeAllowed >= 30 { timeAllowed -= 15 }
            //                                    } label: {
            //                                        Text("-")
            //                                    }
            //                                    Text(selectedTimeFormatted(timeAllowed))
            //                                    Button {
            //                                        timeAllowed += 15
            //                                    } label: {
            //                                        Text("+")
            //                                    }
            //                                }
            //                                .tint(.gray)
            //                            }
            //                            .frame(height: 30)
            //                        case .openLimit:
            //                            HStack {
            //                                Text("Opens Allowed")
            //                                Spacer()
            //                                Group {
            //                                    Button {
            //                                        if opensAllowed >= 1 { opensAllowed -= 1 }
            //                                    } label: {
            //                                        Text("-")
            //                                    }
            //                                    Text("\(opensAllowed)")
            //                                    Button {
            //                                        if opensAllowed < 15 { opensAllowed += 1 }
            //                                    } label: {
            //                                        Text("+")
            //                                    }
            //                                }
            //                                .tint(.gray)
            //                            }
            //                            .frame(height: 35)
            //                            Divider()
            //                            HStack {
            //                                Text("For Up To")
            //                                Spacer()
            //                                Group {
            //                                    Button {
            //                                        if forUpTo >= 3 { forUpTo -= 1 }
            //                                    } label: {
            //                                        Text("-")
            //                                    }
            //                                    Text("\(forUpTo)m")
            //                                    Button {
            //                                        if forUpTo < 60 { forUpTo += 1 }
            //                                    } label: {
            //                                        Text("+")
            //                                    }
            //                                }
            //                                .tint(.gray)
            //                            }
            //                            .frame(height: 30)
            //                        }
            //                    }
            //                }
            //            case .interval:
            //                VStack {
            //                    HStack {
            //                        Text("Block Threshold")
            //                        Spacer()
            //                        Group {
            //                            Button {
            //                                if thresholdTime > 2 { thresholdTime -= 1 }
            //                            } label: {
            //                                Text("-")
            //                            }
            //                            Text("\(thresholdTime)m")
            //                            Button {
            //                                if thresholdTime + 1 < intervalTime { thresholdTime += 1 }
            //                            } label: {
            //                                Text("+")
            //                            }
            //                        }
            //                        .tint(.gray)
            //                    }
            //                    .frame(height: 30)
            //                    Divider()
            //                    HStack {
            //                        Text("Interval")
            //                        Spacer()
            //                        Group {
            //                            Button {
            //                                if intervalTime > 15 && intervalTime > thresholdTime + 1{ intervalTime -= 1 }
            //                            } label: {
            //                                Text("-")
            //                            }
            //                            Text("\(intervalTime)m")
            //                            Button {
            //                                if intervalTime < 60 { intervalTime += 1 }
            //                            } label: {
            //                                Text("+")
            //                            }
            //                        }
            //                        .tint(.gray)
            //                    }
            //                    .frame(height: 30)
            //                }
            //            case .allow:
            //                VStack {
            //                    Toggle("Has Limits?", isOn: $hasLimit)
            //                        .tint(color)
            //                        .frame(height: 30)
            //                    if hasLimit {
            //                        Divider()
            //                        HStack {
            //                            Text("Time Allowed")
            //                            Spacer()
            //                            Group {
            //                                Button {
            //                                    if allowTimeLimit >= 30 { allowTimeLimit -= 15 }
            //                                } label: {
            //                                    Text("-")
            //                                }
            //                                Text(selectedTimeFormatted(allowTimeLimit))
            //                                Button {
            //                                    timeAllowed += 15
            //                                } label: {
            //                                    Text("+")
            //                                }
            //                            }
            //                            .tint(.gray)
            //                        }
            //                        .frame(height: 30)
            //                    }
            //                }
            //            }
        }
        .padding()
        .font(.body)
        .glass(gradientOpacity: 0.3, gradientStyle: .normal, shadowColor: .clear)
    }
    
    private var appSelectionRow: some View {
        HStack {
            Text("Apps")
            Spacer()
            Group {
                Text(appSelectionText)
                Image(systemName: "chevron.forward")
            }
            .foregroundStyle(.gray)
        }
        .font(.body)
        .padding()
        .glass(gradientOpacity: 0.3, gradientStyle: .reverted, shadowColor: .clear)
        .onTapGesture {
            showActivityPicker = true
        }
    }
    
    // MARK: - Helpers
    private var restrictionDescription: String {
        switch configuration {
        case .shield:
            return "Apps in this category will be fully blocked until you return to Cognize."
        case .interval:
            return "Apps will be available until you exceed a block threshold in a short interval (e.g. 15 mins)."
        case .allow:
            return "Apps are always available, but usage can be tracked or limited gently."
        }
    }
    
    private var appSelectionText: String {
        var text = ""
        let categoriesCount = configuration.appSelection.categories.count
        let appsCount = configuration.appSelection.applications.count
        
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
    
    private func selectedTimeFormatted(_ timeAllowed: Int) -> String {
        let hours = timeAllowed / 60
        let minutes = timeAllowed % 60
        return hours == 0 ? "\(minutes)m" : "\(hours)h \(minutes)m"
    }
}

#Preview {
    //    @Previewable @State var restrictionType: Category.RestrictionType = .shield
    @Previewable @State var appSelection = FamilyActivitySelection()
    @Previewable @State var limitType: ShieldRestriction.LimitType = .timeLimit
    //
    //    RestrictionSelectionView(color: .blue, restrictionType: $restrictionType, appSelection: $appSelection, shieldLimitType: $limitType) {
    //
    //    } doneAction: {
    //
    //    }
    
}
