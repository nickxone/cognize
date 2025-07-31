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
    let color: Color
    
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
                    dismiss()
                }) {
                    Text("Save Intention")
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
                .padding(.top, 4)
                .hapticFeedback(.confirmHaptic)

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
                .hapticFeedback(.cancelHaptic)
                .padding(.top, -8)
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .preferredColorScheme(.dark)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    CustomActivityPicker(activitySelection: .constant(FamilyActivitySelection()), color: .green)
}
