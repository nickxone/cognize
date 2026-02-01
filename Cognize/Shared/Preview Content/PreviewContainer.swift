//
//  PreviewContainer.swift
//  Cognize
//
//  Created by Matvii Ustich on 20/01/2026.
//

import Foundation
import SwiftData
import SwiftUI

struct IntentionLogSampleData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: IntentionLog.self, configurations: .init(isStoredInMemoryOnly: true))
        IntentionLog.sampleData.forEach { log in
            container.mainContext.insert(log)
        }
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

struct IntentionLogActiveSampleData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: IntentionLog.self, configurations: .init(isStoredInMemoryOnly: true))
        IntentionLog.sampleActiveData.forEach { log in
            container.mainContext.insert(log)
        }
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}


extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var intentionLogSampleData: Self = .modifier(IntentionLogSampleData())
    @MainActor static var intentionLogActiveSampleData: Self = .modifier(IntentionLogActiveSampleData())
}
