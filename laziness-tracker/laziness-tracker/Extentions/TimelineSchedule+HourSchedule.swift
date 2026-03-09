//
//  TimelineSchedule+HourSchedule.swift
//  laziness-tracker
//
//  Created by Reilan Sagun on 2026-03-05.
//

import SwiftUI

struct HourSchedule: TimelineSchedule {
    func entries(from start: Date, mode: TimelineScheduleMode) -> some Sequence<Date> { // returns a sequence of dates
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: start) // current hour
        let startOfCurrentHour = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: start) ?? start // round down to current hour
        let startOfNextHour = calendar.date(byAdding: .hour, value: 1, to: startOfCurrentHour) ?? start // find next hour
        let useLowFrequency = (mode == .lowFrequency) // fewer updates when app is backgrounded or low power
        var count = 0

        return sequence(first: start) { last in
            count += 1
            if useLowFrequency, count >= 3 { return nil } // only now + 2 more hour boundaries
            return last == start ? startOfNextHour : calendar.date(byAdding: .hour, value: 1, to: last)
        }
    }
}

extension TimelineSchedule where Self == HourSchedule {
    static var atHourBoundaries: HourSchedule { HourSchedule() } // use as timelineView(.atHourBoundaries)
}
