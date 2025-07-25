//
//  CustomActivityPicker.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import SwiftUI
import FamilyControls

struct CustomActivityPicker: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var activitySelection: FamilyActivitySelection
    
    var body: some View {
        VStack(spacing: 0) {
            // Picker with bottom shadow effect
            ZStack(alignment: .bottom) {
                FamilyActivityPicker(headerText: "Select Apps or Websites", selection: $activitySelection)
                
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
//                    model.saveSelections()
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
                .hapticFeedback(.confirmHaptic)

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
                .hapticFeedback(.cancelHaptic)
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .preferredColorScheme(.dark)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    
}
