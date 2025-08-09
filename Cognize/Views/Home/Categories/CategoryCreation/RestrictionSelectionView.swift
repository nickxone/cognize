//
//  RestrictionSelection.swift
//  Cognize
//
//  Created by Matvii Ustich on 02/08/2025.
//

// TODO: this view should initialise a Restriction class rather than different parameters
import SwiftUI
import FamilyControls

struct RestrictionSelectionView: View {
    let color: Color
    @Binding var configuration: RestrictionDraft
    let backAction: () -> ()
    let doneAction: () -> ()
    
    
    @State private var showActivityPicker = false
    
    var body: some View {
        ZStack {
            // Background
            ColorfulBackground(color: color, animate: true)
            
            VStack(spacing: 24) {
                Text("Choose Restriction Type")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 50)
                
                Picker("Restriction Type", selection: $configuration.kind) {
                    Text("Shield").tag(RestrictionDraft.Kind.shield)
                    Text("Interval").tag(RestrictionDraft.Kind.interval)
                    Text("Open").tag(RestrictionDraft.Kind.open)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                Text(restrictionDescription)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                appSelectionRow
                
                RestrictionEditor(color: color, configuration: _configuration)
                
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
            CustomActivityPicker(activitySelection: $configuration.appSelection, color: color)
        }
        .preferredColorScheme(.dark)
        .interactiveDismissDisabled()
        
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
        switch configuration.kind {
        case .shield:
            return "Apps in this category will be fully blocked until you return to Cognize."
        case .interval:
            return "Apps will be available until you exceed a block threshold in a short interval (e.g. 15 mins)."
        case .open:
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
    @Previewable @State var draftConfig = RestrictionDraft()
    
    RestrictionSelectionView(color: .blue, configuration: $draftConfig) {
        
    } doneAction: {
        
    }
    
}
