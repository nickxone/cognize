//
//  CategoryActionView.swift
//  Cognize
//
//  Created by Matvii Ustich on 30/07/2025.
//

import SwiftUI
import FamilyControls

struct CategoryActionView: View {
    let category: Category
    
    @State private var showCreateIntentionView = false
    
    var body: some View {
        ZStack {
            // Background
            ColorfulBackground(color: category.color, animate: false)
            
            VStack {
                Spacer()
                
                Button {
                    showCreateIntentionView = true
                } label: {
                    Text("Create Intention")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            ZStack {
                                Capsule()
                                    .fill(category.color.gradient)
                                Capsule()
                                    .fill(.black.opacity(0.2))
                            }
                            .clipShape(Capsule())
                        }
                        .foregroundStyle(.white)
                }
                //                .disabled(reason.isEmpty)
            }
            .padding()
            
        }
        .frame(width: UIScreen.main.bounds.width - 60,
               height: UIScreen.main.bounds.height * 0.2)
        .cornerRadius(20)
        .shadow(color: category.color.opacity(0.25), radius: 12, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(category.color.opacity(0.15), lineWidth: 1)
        )
        .sheet(isPresented: $showCreateIntentionView) {
            IntentionCreationView(category: category)
        }
        .preferredColorScheme(.dark)
    }
    
}

#Preview {
    let category = Category(name: "Social", color: .blue, configuration: RestrictionConfiguration.shield(.init(appSelection: FamilyActivitySelection(), timeAllowed: 5, opensAllowed: 5)))
    CategoryActionView(category: category)
}
