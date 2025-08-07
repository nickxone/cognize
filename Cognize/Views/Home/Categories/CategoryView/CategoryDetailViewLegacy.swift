//
//  CategoryDetail.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

//import SwiftUI
//import FamilyControls
//
//struct CategoryDetailViewLegacy: View {
//    let category: Category
//    
//    @State private var durationPickerIsPresented: Bool = false
//    @State private var selectedDuration: Int = 0
//    
//    var body: some View {
//        Form {
//            Section(header: Text("Name")) {
//                Text(category.name)
//            }
//            
//            Section(header: Text("Restriction Type")) {
//                Text(category.restrictionType.rawValue.capitalized)
//            }
//            
//            Section(header: Text("Apps Selected")) {
//                Text("\(category.appSelection.applicationTokens.count) apps")
//            }
//            
//            if category.restrictionType == .shield {
//                Button {
//                    durationPickerIsPresented = true
//                } label: {
//                    Text("Unlock apps")
//                }
//                .sheet(isPresented: $durationPickerIsPresented) {
//                    DurationPickerView(selectedDuration: $selectedDuration) {
//                        let strategy: ShieldRestriction = category.strategy as! ShieldRestriction
//                        strategy.unlockEntertainmentActivities(for: selectedDuration)
//                        durationPickerIsPresented = false
//                    }
//                    .presentationDetents([.medium])
//                }
//            }
//        }
//        .navigationTitle(category.name)
//    }
//}
//
//#Preview {
////    CategoryDetail()
//}
