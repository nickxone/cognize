//
//  CategoryProgressStyle.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/01/2026.
//

import SwiftUI

struct CategoryProgressStyle: ProgressViewStyle {
    let color: Color
    var height: CGFloat = 12
    
    func makeBody(configuration: Configuration) -> some View {
        let fraction = configuration.fractionCompleted ?? 0
        
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.black.opacity(0.3))
                
                Capsule()
                    .fill(color.gradient)
                    .frame(width: geo.size.width * fraction)
                    .shadow(color: color.opacity(0.5), radius: 5, x: 0, y: 0)
            }
        }
        .frame(height: height)
    }
}
