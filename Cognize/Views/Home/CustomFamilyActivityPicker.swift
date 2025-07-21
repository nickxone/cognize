//
//  CustomFamilyActivityPicker.swift
//  Cognize
//
//  Created by Matvii Ustich on 21/07/2025.
//

import SwiftUI
import FamilyControls

struct CustomFamilyActivityPicker: View {
    let shieldCategory: ShieldCategory
    
    @EnvironmentObject var model: ShieldViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Picker with bottom shadow effect
            ZStack(alignment: .bottom) {
                FamilyActivityPicker(headerText: "Select Apps or Websites", selection: shieldCategory == .entertainment ?  $model.entertainmentSelection : $model.workSelection)
                
                // Shadow fade at the bottom
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(1.0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 50)
                .edgesIgnoringSafeArea(.horizontal)
            }

            VStack(spacing: 16) {
                Button(action: {
                    model.saveSelections()
                    dismiss()
                }) {
                    Text("Select Apps or Website")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 4)

                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .preferredColorScheme(.dark)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    @Previewable @StateObject var model = ShieldViewModel()
    CustomFamilyActivityPicker(shieldCategory: .entertainment)
        .environmentObject(model)
}
