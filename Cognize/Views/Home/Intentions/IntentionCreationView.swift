//
//  IntentionLogCreationView.swift
//  Cognize
//
//  Created by Matvii Ustich on 30/07/2025.
//

import SwiftUI
import FamilyControls
import SwiftData

struct IntentionCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    let category: Category
    
    @State private var reason: String = ""
    @State private var duration: Int = 10
    
    var body: some View {
        ZStack {
            ColorfulBackground(color: category.color, animate: true)
            
            VStack(spacing: 24) {
                Text("Log Your Intention")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    TextField("What's your intention?", text: $reason)
                        .padding()
                        .glassEffect()
                    
                    HStack {
                        Text("Break duration:")
                            .padding(.leading)
                        
                        Spacer()
                        
                        Picker("Break duration", selection: $duration) {
                            ForEach(1...30, id: \.self) { minute in
                                Text("\(minute)").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80, height: 130)
                        .clipped()
                        .compositingGroup()
                        .padding(-8)
                        
                        Text("minute\(duration == 1 ? "" : "s")")
                            .padding(.trailing)
                    }
                    .padding()
                    .glassEffect(in: .rect(cornerRadius: 25))
                }
                
                Spacer()
                
                Group {
                    Button {
                        saveIntention()
                        dismiss()
                    } label: {
                        Text("Save Intention")
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
                    .disabled(reason.isEmpty)
                    .opacity(reason.isEmpty ? 0.6 : 1)
                    
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
                    .padding(.top, -15)
                }
                
                
            }
            .padding()
        }
        .gesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )
        
        .preferredColorScheme(.dark)
    }
    
    private func saveIntention() {
        do {
            let log = IntentionLog(category: category, reason: reason, duration: duration)
            context.insert(log)
            try context.save()
            
        } catch {
            print("Failed to save an intention: \(error)")
        }
    }
    
}

#Preview {
    let category = Category.sampleData[0]
    
    IntentionCreationView(category: category)
}
