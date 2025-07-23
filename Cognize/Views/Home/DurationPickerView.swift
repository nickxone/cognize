//
//  DurationPickerView.swift
//  Cognize
//
//  Created by Matvii Ustich on 20/07/2025.
//

import SwiftUI

struct DurationPickerView: View {
    @Binding var selectedDuration: Int
    
    @Environment(\.dismiss) var dismiss
    
    var onConfirm: () -> Void
    
    var body: some View {
            VStack {
                Text("Unlock Duration")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                Spacer()
                
                HStack {
                    Text("Break duration:")
                        .padding(.leading)
                    
                    Spacer()
                    
                    Picker("Break duration", selection: $selectedDuration) {
                        ForEach(1...30, id: \.self) { minute in
                            Text("\(minute)").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80, height: 130)
                    .clipped()
                    .compositingGroup()
                    
                    Text("minute\(selectedDuration == 1 ? "" : "s")")
                        .padding(.trailing)
                }
                
                Spacer()
                
                Button(action: {
                    onConfirm()
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
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
    
    }
}

#Preview {
    @Previewable @State var isPresented = true
    @Previewable @State var duration: Int = 5
    
    Color(.black)
        .sheet(isPresented: $isPresented) {
            DurationPickerView(selectedDuration: $duration, onConfirm: { print("Start break button pressed") })
                .presentationDetents([.medium])
        }
        .ignoresSafeArea()
}
