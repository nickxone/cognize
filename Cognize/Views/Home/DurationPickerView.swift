//
//  DurationPickerView.swift
//  Cognize
//
//  Created by Matvii Ustich on 20/07/2025.
//

import SwiftUI

struct DurationPickerView: View {
    @Binding var selectedDuration: Int
    var onConfirm: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                HStack {
                    Text("Break duration:")
                    
                    
                    Picker("Break duration", selection: $selectedDuration) {
                        ForEach(1...30, id: \.self) { minute in
                            Text("\(minute)").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80, height: 100)
                    .clipped()
                    .compositingGroup()
                    .padding(.leading)
                    
                    Text("minute\(selectedDuration == 1 ? "" : "s")")
                }
                
                Spacer()
                
                Button("Start Break") {
                    onConfirm()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Select Break Duration")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    @Previewable @State var duration: Int = 5
    
    DurationPickerView(selectedDuration: $duration, onConfirm: { print("Start break button pressed") })
}
