//
//  CategoryBackground.swift
//  Cognize
//
//  Created by Matvii Ustich on 29/07/2025.
//

import SwiftUI

struct CategoryBackgroundView: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Gradient Glow
                RadialGradient(
                    gradient: Gradient(colors: [
                        color.opacity(0.6),
                        color.opacity(0.1),
                        .black.opacity(0.01),
                    ]),
                    center: .top,
                    startRadius: 50,
                    endRadius: max(geo.size.width, geo.size.height)
                )
                .ignoresSafeArea()

                // Top-to-bottom fade to black
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 1),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
//    CategoryBackgroundView()
}
