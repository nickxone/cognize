//
//  FadingCardScrollView.swift
//  Cognize
//
//  Created by Matvii Ustich on 28/07/2025.
//

import SwiftUI

fileprivate struct CardMidXPreferenceKey: PreferenceKey {
    static var defaultValue: [AnyHashable: CGFloat] = [:]

    static func reduce(
        value: inout [AnyHashable: CGFloat],
        nextValue: () -> [AnyHashable: CGFloat]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

fileprivate enum LeadingViewID: Hashable {
    case leading
}

struct FadingCardScrollView<
    Item: Identifiable,
    Content: View,
    LeadingView: View
>: View {
    var items: [Item]
    var cardWidth: CGFloat = UIScreen.main.bounds.width - 60
    var spacing: CGFloat = 15
    var leadingView: (() -> LeadingView)?
    var content: (Item) -> Content

    @Binding var focusedItem: Item?

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
                            .background(
                                Color.clear.preference(key: CardMidXPreferenceKey.self, value: [LeadingViewID.leading: midX])
                            )
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
                            .background(
                                Color.clear.preference(key: CardMidXPreferenceKey.self, value: [AnyHashable(item.id): midX])
                            )
                    }
                    .frame(width: cardWidth)
                }

            }
            .scrollTargetLayout()
        }
        .onPreferenceChange(CardMidXPreferenceKey.self) { midXs in
            let screenMidX = UIScreen.main.bounds.width / 2
            if let closest = midXs.min(by: {
                abs($0.value - screenMidX) < abs($1.value - screenMidX)
            }) {
                if let key = closest.key as? Item.ID {
                    focusedItem = items.first(where: { $0.id == key })
                } else {
                    focusedItem = nil // e.g., for leading view
                }
            }
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, spacing * 2)
    }

}

#Preview {
    //    FadingCardScrollView()
}
