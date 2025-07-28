//
//  FadingCardScrollView.swift
//  Cognize
//
//  Created by Matvii Ustich on 28/07/2025.
//

import SwiftUI

struct FadingCardScrollView<Item: Identifiable, Content: View, LeadingView: View>: View {
    var items: [Item]
    var cardWidth: CGFloat = UIScreen.main.bounds.width - 60
    var spacing: CGFloat = 15
    var leadingView: (() -> LeadingView)?
    var content: (Item) -> Content

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                if let leadingView = leadingView {
                    GeometryReader { geo in
                        let screenWidth = UIScreen.main.bounds.width
                        let midX = geo.frame(in: .global).midX
                        let distance = abs(screenWidth / 2 - midX)
                        let fade = max(0.5, 1 - distance / screenWidth)

                        leadingView()
                            .opacity(fade)
                            .scaleEffect(0.95 + 0.05 * fade)
                    }
                    .frame(width: cardWidth)
                }

                ForEach(items) { item in
                    GeometryReader { geo in
                        let screenWidth = UIScreen.main.bounds.width
                        let midX = geo.frame(in: .global).midX
                        let distance = abs(screenWidth / 2 - midX)
                        let fade = max(0.5, 1 - distance / screenWidth)

                        content(item)
                            .opacity(fade)
                            .scaleEffect(0.95 + 0.05 * fade)
                    }
                    .frame(width: cardWidth)
                }
                
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, spacing * 2)
    }
}

#Preview {
//    FadingCardScrollView()
}
