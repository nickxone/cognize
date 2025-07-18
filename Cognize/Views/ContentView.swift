//
//  ContentView.swift
//  Cognize
//
//  Created by Matvii Ustich on 16/07/2025.
//

import SwiftUI
import FamilyControls
import DeviceActivity

struct ContentView: View {
    @ObservedObject private var model = ShieldViewModel()
    @State private var pickerIsPresented = false
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
            Button {
                pickerIsPresented = true
            } label: {
                Text("Select Apps")
            }
            .familyActivityPicker(isPresented: $pickerIsPresented, selection: $model.selectionToDiscourage)
            

        }
        .padding()
    }
    
    

}

#Preview {
    ContentView()
}
