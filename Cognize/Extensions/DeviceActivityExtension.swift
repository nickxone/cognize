//
//  DeviceActivityNameExtension.swift
//  Cognize
//
//  Created by Matvii Ustich on 19/07/2025.
//

import DeviceActivity

extension DeviceActivityName {
    static let allow = Self("allow")
    
    static let productivityFirst = Self("productivityFirst")
    static let productivitySecond = Self("productivitySecond")
}

extension DeviceActivityEvent.Name {
    static let productivityUsageThresholdEvent = Self("productivityFirstEvent")
}
