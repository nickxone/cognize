//
//  DailyShieldUsage.swift
//  Cognize
//
//  Created by Matvii Ustich on 11/08/2025.
//

import Foundation

struct DailyShieldUsage: Codable {
    var dayStart: Date
    var usage: Usage
    
    enum Usage: Codable, Equatable {
        case timeLimit(minutesUsed: Int)
        case openLimit(opensUsed: Int)
    }
}

final class ShieldUsageStore {
    private let defaults: UserDefaults
    private let keyPrefix = "shield-usage-"
    private let calendar = Calendar.current
    
    init(suiteName: String? = nil) {
        self.defaults = suiteName.flatMap { UserDefaults(suiteName: $0) } ?? .standard
    }
    
    private func key(for categoryId: UUID) -> String {
        "\(keyPrefix)\(categoryId.uuidString)"
    }
    
    private func todayStart() -> Date {
        calendar.startOfDay(for: Date())
    }
    
    private func freshUsage(for config: ShieldConfig) -> DailyShieldUsage {
        let day = todayStart()
        switch config.limit {
        case .timeLimit:
            return DailyShieldUsage(dayStart: day, usage: .timeLimit(minutesUsed: 0))
        case .openLimit:
            return DailyShieldUsage(dayStart: day, usage: .openLimit(opensUsed: 0))
        }
    }
    
    
    func load(for categoryId: UUID, config: ShieldConfig) -> DailyShieldUsage {
        let k = key(for: categoryId)
        
        if let data = defaults.data(forKey: k),
           let saved = try? JSONDecoder().decode(DailyShieldUsage.self, from: data) {
            
            let isToday = calendar.isDate(saved.dayStart, inSameDayAs: todayStart())
            let matchesKind: Bool = {
                switch (config.limit, saved.usage) {
                case (.timeLimit, .timeLimit), (.openLimit, .openLimit): return true
                default: return false
                }
            }()
            
            if isToday && matchesKind {
                return saved
            }
        }
        
        // Rollover or mismatch → reset to a fresh state for today and persist it.
        let fresh = freshUsage(for: config)
        save(fresh, for: categoryId)
        return fresh
    }
    
    func save(_ state: DailyShieldUsage, for categoryId: UUID) {
        let k = key(for: categoryId)
        if let data = try? JSONEncoder().encode(state) {
            defaults.set(data, forKey: k)
        }
    }
    
    func remaining(for categoryId: UUID, config: ShieldConfig) -> Int {
        let s = load(for: categoryId, config: config)
        
        switch (config.limit, s.usage) {
        case let (.timeLimit(allowed), .timeLimit(used)):
            return max(0, allowed - used)
        case let (.openLimit(allowedOpens, _), .openLimit(usedOpens)):
            return max(0, allowedOpens - usedOpens)
        default:
            return 0
        }
    }
    
    // MARK: - Mutations
    func addMinutes(_ minutes: Int, for categoryId: UUID, config: ShieldConfig) {
        var s = load(for: categoryId, config: config)
        if case .timeLimit(let used) = s.usage {
            s.usage = .timeLimit(minutesUsed: used + minutes)
            save(s, for: categoryId)
        }
    }
    
    func addOpen(for categoryId: UUID, config: ShieldConfig) {
        var s = load(for: categoryId, config: config)
        if case .openLimit(let used) = s.usage {
            s.usage = .openLimit(opensUsed: used + 1)
            save(s, for: categoryId)
        }
    }
}
