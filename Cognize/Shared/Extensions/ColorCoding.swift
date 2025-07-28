//
//  ColorCoding.swift
//  Cognize
//
//  Created by Matvii Ustich on 28/07/2025.
//

import Foundation
import SwiftUI

#if os(iOS)
typealias PlatformColor = UIColor
extension Color {
    init(platformColor: PlatformColor) {
        self.init(uiColor: platformColor)
    }
}
#elseif os(macOS)
typealias PlatformColor = NSColor
extension Color {
    init(platformColor: PlatformColor) {
        self.init(nsColor: platformColor)
    }
}
#endif

func encodeColor(_ color: Color) throws -> Data {
    let platformColor = PlatformColor(color)
    return try NSKeyedArchiver.archivedData(withRootObject: platformColor, requiringSecureCoding: true)
}

func decodeColor(from data: Data) throws -> Color {
    let platformColor: PlatformColor? = try NSKeyedUnarchiver.unarchivedObject(ofClass: PlatformColor.self, from: data)
    
    guard let platformColor else {
        throw DecodingError.wrongType
    }
    
    return Color(platformColor: platformColor)
}

enum DecodingError: Error {
    case wrongType
}
