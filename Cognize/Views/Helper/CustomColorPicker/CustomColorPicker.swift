//
//  CustomColorPicker.swift
//  Cognize
//
//  Created by Matvii Ustich on 31/07/2025.
//

import SwiftUI

struct CustomColorPicker: View {
    @Binding var selectedColour: Color
    
    @State var colourSheetPresented = false
    @State private var brightness: CGFloat = 0
    
    let colors: [Color] = [
        .blue, .purple, .pink, .red, .orange, .yellow,
        .gold, .green, .lightGreen, .mint, .indigo, .brown,
        .gray, .darkGray, .cyan, .teal, .white, .black
    ]
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 52))
    ]
    
    var body: some View {
        ColorButton(selectedColor: selectedColour) {
            colourSheetPresented = true
        }
        .sheet(isPresented: $colourSheetPresented) {
            NavigationStack {
                ZStack {
                    ZStack {
                        Color(uiColor: UIColor.secondarySystemBackground)
                        LinearGradient(colors: [
                            selectedColour.adjust(brightness: brightness).opacity(0.05),
                            selectedColour.adjust(brightness: brightness).opacity(0.1),
                            selectedColour.adjust(brightness: brightness).opacity(0.15),
                            selectedColour.adjust(brightness: brightness).opacity(0.2),
                        ], startPoint: .top, endPoint: .bottom)
                    }
                    .ignoresSafeArea()
                    
                    VStack {
                        LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                            ForEach(colors, id: \.self) { item in
                                CircleButton(item: item.adjust(brightness: item == selectedColour ? brightness : 0), isSelected: item == selectedColour) {
                                    selectedColour = item
                                }
                            }
                        }
                        ColorSlider(value: $brightness, range: -0.5...0.5, selectedColor: $selectedColour)
                            .padding()
                    }
                    .padding(.horizontal)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {
                                colourSheetPresented = false
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .fontDesign(.rounded)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.gray)
                            })
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Select Colour")
                }
            }
            .presentationDetents([.fraction(0.4)])
            .presentationCornerRadius(32)
        }
        
    }
}

#Preview {
    @Previewable @State var color: Color = .blue
    CustomColorPicker(selectedColour: $color)
}
