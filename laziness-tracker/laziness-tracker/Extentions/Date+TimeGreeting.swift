//
//  Date+TimeGreeting.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-03-05.
//

import Foundation

extension Date {
    var timeGreeting: String {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<21: return "Good afternoon"
        default: return "Good night"
        }
    }
}
