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
    
    @State private var showActivityPicker = false
    
    var body: some View {
        Group {
            switch configuration.kind {
            case .shield:
                VStack {
                    HStack {
                        Text("Limit Type")
                        Spacer()
                        Picker("Limit Type", selection: $configuration.shield.kind) {
                            Text("Time Limit").tag(RestrictionDraft.Shield.Kind.shieldTime).foregroundStyle(.gray)
                            Text("Open Limit").tag(RestrictionDraft.Shield.Kind.shieldOpen).foregroundStyle(.gray)
                        }
                        .tint(.gray)
                    }
                    .frame(height: 30)
                    Divider()
                    Group {
                        switch configuration.shield.kind {
                        case .shieldTime:
                            HStack {
                                Text("Time Allowed")
                                Spacer()
                                Group {
                                    Button {
                                        if configuration.shield.shieldMinutesAllowed >= 30 { configuration.shield.shieldMinutesAllowed -= 15 }
                                    } label: {
                                        Text("-")
                                    }
                                    Text(selectedTimeFormatted(configuration.shield.shieldMinutesAllowed))
                                    Button {
                                        configuration.shield.shieldMinutesAllowed += 15
                                    } label: {
                                        Text("+")
                                    }
                                }
                                .tint(.gray)
                            }
                            .frame(height: 30)
                        case .shieldOpen:
                            HStack {
                                Text("Opens Allowed")
                                Spacer()
                                Group {
                                    Button {
                                        if configuration.shield.shieldOpensAllowed >= 1 { configuration.shield.shieldOpensAllowed -= 1 }
                                    } label: {
                                        Text("-")
                                    }
                                    Text("\(configuration.shield.shieldOpensAllowed)")
                                    Button {
                                        if configuration.shield.shieldOpensAllowed < 15 { configuration.shield.shieldOpensAllowed += 1 }
                                    } label: {
                                        Text("+")
                                    }
                                }
                                .tint(.gray)
                            }
                            .frame(height: 35)
                            Divider()
                            HStack {
                                Text("For Up To")
                                Spacer()
                                Group {
                                    Button {
                                        if configuration.shield.shieldMinutesPerOpen >= 3 { configuration.shield.shieldMinutesPerOpen -= 1 }
                                    } label: {
                                        Text("-")
                                    }
                                    Text("\(configuration.shield.shieldMinutesPerOpen)m")
                                    Button {
                                        if configuration.shield.shieldMinutesPerOpen < 60 { configuration.shield.shieldMinutesPerOpen += 1 }
                                    } label: {
                                        Text("+")
                                    }
                                }
                                .tint(.gray)
                            }
                            .frame(height: 30)
                        }
                    }
                }
            case .interval:
                VStack {
                    HStack {
                        Text("Block Threshold")
                        Spacer()
                        Group {
                            Button {
                                if configuration.interval.intervalThresholdTime > 2 { configuration.interval.intervalThresholdTime -= 1 }
                            } label: {
                                Text("-")
                            }
                            Text("\(configuration.interval.intervalThresholdTime)m")
                            Button {
                                if configuration.interval.intervalThresholdTime + 1 < configuration.interval.intervalLength { configuration.interval.intervalThresholdTime += 1 }
                            } label: {
                                Text("+")
                            }
                        }
                        .tint(.gray)
                    }
                    .frame(height: 30)
                    Divider()
                    HStack {
                        Text("Interval")
                        Spacer()
                        Group {
                            Button {
                                if configuration.interval.intervalLength > 15 && configuration.interval.intervalLength > configuration.interval.intervalThresholdTime + 1 { configuration.interval.intervalLength -= 1 }
                            } label: {
                                Text("-")
                            }
                            Text("\(configuration.interval.intervalLength)m")
                            Button {
                                if configuration.interval.intervalLength < 60 { configuration.interval.intervalLength += 1 }
                            } label: {
                                Text("+")
                            }
                        }
                        .tint(.gray)
                    }
                    .frame(height: 30)
                }
            case .open:
                VStack {
                    Toggle("Has Limits?", isOn: Binding(
                        get: {
                            configuration.open.kind == .openLimit
                        },
                        set: { newValue in
                            if newValue {
                                configuration.open.kind = .openLimit
                            } else {
                                configuration.open.kind = .openAlways
                            }
                        }
                    ))
                    .tint(color)
                    .frame(height: 30)
                    if configuration.open.kind == .openLimit {
                        Divider()
                        HStack {
                            Text("Time Allowed")
                            Spacer()
                            Group {
                                Button {
                                    if configuration.open.openMinutesAllowed >= 30 { configuration.open.openMinutesAllowed -= 15 }
                                } label: {
                                    Text("-")
                                }
                                Text(selectedTimeFormatted(configuration.open.openMinutesAllowed))
                                Button {
                                    configuration.open.openMinutesAllowed += 15
                                } label: {
                                    Text("+")
                                }
                            }
                            .tint(.gray)
                        }
                        .frame(height: 30)
                    }
                }
            }
        }
        .padding()
        .font(.body)
        .glassEffect(in: .rect(cornerRadius: 30))
//        .glass(gradientOpacity: 0.3, gradientStyle: .normal, shadowColor: .clear)
    }
    
    private func selectedTimeFormatted(_ timeAllowed: Int) -> String {
        let hours = timeAllowed / 60
        let minutes = timeAllowed % 60
        return hours == 0 ? "\(minutes)m" : "\(hours)h \(minutes)m"
    }
    
}
#Preview {
    @Previewable @State var draftConfig = RestrictionDraft()
    RestrictionEditor(color: .blue, configuration: $draftConfig)
}
