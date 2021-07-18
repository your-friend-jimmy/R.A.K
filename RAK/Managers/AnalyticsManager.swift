//
//  AnalyticsManager.swift
//  instagram
//
//  Created by James Phillips on 7/17/21.
//

import FirebaseAnalytics
import Foundation

final class AnalyticsManager {
    static var shared = AnalyticsManager()
    
    private init() {}
    
    func logEvent() {
        Analytics.logEvent("", parameters: [:])
    }
    
}
