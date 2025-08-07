//
//  CategoryCreationView.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI
import FamilyControls

fileprivate enum CategoryCreationDestination: Hashable {
    case appSelection
    case restrictionSelection
}

struct CategoryCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.categoryStore) private var store
    
    @Binding var categories: [Category]
    
    @State private var name = ""
    @State private var color: Color = .black
    
    @State private var restrictionType: Category.RestrictionType = .shield
    @State private var appSelection = FamilyActivitySelection()
    
    @State private var showPicker = false
    @State private var showRestrictionView = false
    @State private var showActivityPicker = false
    
    @State private var limitType: ShieldRestriction.LimitType = .timeLimit
    
    init(categories: Binding<[Category]>) {
        self._categories = categories
    }
    
    var body: some View {
        ZStack {
            // Background
            ColorfulBackground(color: color, animate: true)
            
            VStack {
                Text("Create New Category")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 50)
                
                TextField("Enter name", text: $name)
                    .padding()
                    .glass(strokeWidth: 1.0, shadowColor: .black)
                
                Spacer()
                
                CustomColorPicker(selectedColour: $color)
                
                Spacer()
                
                Button {
                    showRestrictionView = true
                } label: {
                    Text("Next")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            ZStack {
                                Capsule()
                                    .fill(color.gradient)
                                Capsule()
                                    .fill(.black.opacity(0.2))
                            }
                            .clipShape(Capsule())
                        }
                        .foregroundStyle(.white)
                }
                .disabled(name.isEmpty)
                .opacity(name.isEmpty ? 0.6 : 1)
                
            }
            
            .padding()
        }
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
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
        .presentationDetents([.medium])
        .presentationCornerRadius(32)
        .background(.clear)
        .fullScreenCover(isPresented: $showRestrictionView) {
            RestrictionSelectionView(color: color, restrictionType: $restrictionType, appSelection: $appSelection, shieldLimitType: $limitType) {
                showRestrictionView = false
            } doneAction: {
//                let category = Category(name: name, appSelection: appSelection, restrictionType: restrictionType, color: color)
//                categories.append(category)
//                switch category.restrictionType {
//                case .shield:
//                    (category.strategy as! ShieldRestriction).shield()
//                case .interval:
//                    (category.strategy as! IntervalTrackRestriction).track(thresholdUsageMinutes: 2, duringIntervalMinutes: 15)
//                case .allow:
//                    print("Allow")
//                }
//                store.save(categories)
//                print(category)
                dismiss()
//                showRestrictionView = false
            }

        }
    }
    
}

#Preview {
    @Previewable @State var showSheet: Bool = true
    @Previewable @State var categories: [Category] = []
    Button {
        showSheet.toggle()
    } label: {
        Text("Show Sheet")
    }
    .sheet(isPresented: $showSheet) {
        CategoryCreationView(categories: $categories)
    }
    
}
