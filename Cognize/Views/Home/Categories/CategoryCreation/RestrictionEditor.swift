//
//  RestricionOptionsView.swift
//  Cognize
//
//  Created by Matvii Ustich on 09/08/2025.
//

import SwiftUI
import FamilyControls

struct RestrictionEditor: View {
    let color: Color
    @Binding var configuration: RestrictionDraft
    
    var body: some View {
        Group {
            switch configuration.kind {
            case .shield:
                ShieldEditorView(
                    config: $configuration.shield,
                    formatter: selectedTimeFormatted
                )
            case .interval:
                IntervalEditorView(
                    color: color,
                    config: $configuration.interval
                )
            case .open:
                OpenEditorView(
                    color: color,
                    config: $configuration.open,
                    formatter: selectedTimeFormatted
                )
            }
        }
        .padding()
        .font(.body)
        .glassEffect(in: .rect(cornerRadius: 30))
    }
    
    private func selectedTimeFormatted(_ timeAllowed: Int) -> String {
        let hours = timeAllowed / 60
        let minutes = timeAllowed % 60
        return hours == 0 ? "\(minutes)m" : "\(hours)h \(minutes)m"
    }
}

struct SettingStepper: View {
    let title: String
    let value: String
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.primary)
            
            Spacer()
            
            HStack(spacing: 0) {
                Button(action: onDecrement) {
                    Image(systemName: "minus")
                        .font(.body.weight(.medium))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                
                Text(value)
                    .monospacedDigit()
                    .font(.body)
                    .frame(minWidth: 48)
                    .multilineTextAlignment(.center)
                    .contentTransition(.numericText())
                
                Button(action: onIncrement) {
                    Image(systemName: "plus")
                        .font(.body.weight(.medium))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
            }
            .foregroundStyle(.gray)
        }
        
        .frame(height: 30)
    }
}


struct ShieldEditorView: View {
    @Binding var config: RestrictionDraft.Shield
    let formatter: (Int) -> String
    
    var body: some View {
        VStack {
            HStack {
                Text("Limit Type")
                Spacer()
                Picker("Limit Type", selection: $config.kind.animation(.bouncy)) {
                    Text("Time Limit").tag(RestrictionDraft.Shield.Kind.shieldTime)
                    Text("Open Limit").tag(RestrictionDraft.Shield.Kind.shieldOpen)
                }
                .tint(.gray)
            }
            .frame(height: 30)
            
            Divider()
            
            switch config.kind {
            case .shieldTime:
                SettingStepper(
                    title: "Time Allowed",
                    value: formatter(config.shieldMinutesAllowed),
                    onDecrement: { if config.shieldMinutesAllowed >= 30 { config.shieldMinutesAllowed -= 15 } },
                    onIncrement: { config.shieldMinutesAllowed += 15 }
                )
                .transition(.blurReplace) 
                
            case .shieldOpen:
                SettingStepper(
                    title: "Opens Allowed",
                    value: "\(config.shieldOpensAllowed)",
                    onDecrement: { if config.shieldOpensAllowed >= 1 { config.shieldOpensAllowed -= 1 } },
                    onIncrement: { if config.shieldOpensAllowed < 15 { config.shieldOpensAllowed += 1 } }
                )
                .transition(.blurReplace)
                
                Divider()
                
                SettingStepper(
                    title: "For Up To",
                    value: "\(config.shieldMinutesPerOpen)m",
                    onDecrement: { if config.shieldMinutesPerOpen >= 3 { config.shieldMinutesPerOpen -= 1 } },
                    onIncrement: { if config.shieldMinutesPerOpen < 60 { config.shieldMinutesPerOpen += 1 } }
                )
            }
        }
    }
}

struct IntervalEditorView: View {
    let color: Color
    @Binding var config: RestrictionDraft.Interval
    
    var body: some View {
        VStack {
            Toggle("Custom duration?", isOn: $config.isCustomized.animation(.bouncy))
                .tint(color)
                .frame(height: 30)
            
            if config.isCustomized {
                Group {
                    Divider()
                    
                    SettingStepper(
                        title: "Block Threshold",
                        value: "\(config.intervalThresholdTime)m",
                        onDecrement: { if config.intervalThresholdTime > 2 { config.intervalThresholdTime -= 1 } },
                        onIncrement: { if config.intervalThresholdTime + 1 < config.intervalLength { config.intervalThresholdTime += 1 } }
                    )
                    
                    Divider()
                    
                    SettingStepper(
                        title: "Interval",
                        value: "\(config.intervalLength)m",
                        onDecrement: { if config.intervalLength > 15 && config.intervalLength > config.intervalThresholdTime + 1 { config.intervalLength -= 1 } },
                        onIncrement: { if config.intervalLength < 60 { config.intervalLength += 1 } }
                    )
                }
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity.combined(with: .scale(scale: 0.0, anchor: .top))
                    )
                )
                .clipped()
            }
        }
    }
}

struct OpenEditorView: View {
    let color: Color
    @Binding var config: RestrictionDraft.Open
    let formatter: (Int) -> String
    
    var hasLimits: Binding<Bool> {
        Binding(
            get: { config.kind == .openLimit },
            set: { newValue in withAnimation(.bouncy) { config.kind = newValue ? .openLimit : .openAlways } }
        )
    }
    
    var body: some View {
        VStack {
            Toggle("Has Limits?", isOn: hasLimits.animation(.bouncy))
                .tint(color)
                .frame(height: 30)
            
            if config.kind == .openLimit {
                Group {
                    Divider()
                    SettingStepper(
                        title: "Time Allowed",
                        value: formatter(config.openMinutesAllowed),
                        onDecrement: { if config.openMinutesAllowed >= 30 { config.openMinutesAllowed -= 15 } },
                        onIncrement: { config.openMinutesAllowed += 15 }
                    )
                }
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity.combined(with: .scale(scale: 0.0, anchor: .top))
                    )
                )
                .clipped()
            }
        }
    }
}

#Preview {
    @Previewable @State var draftConfig = RestrictionDraft()
    
    RestrictionSelectionView(color: .blue, configuration: $draftConfig) {
        
    } doneAction: {
        
    }
}
