//
//  WeeklyView.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/17/24.
//

import SwiftUI

// Mock event model
struct tempEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

struct WeeklyCalendarView: View {
    let events: [tempEvent]
    
    // Date formatting for day of the week
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // Day of the week
        return formatter
    }()
    
    private var weekDates: [Date] {
        var startOfWeek = calendar.startOfDay(for: Date())
        var weekDates: [Date] = []
        
        // Get all days of the current week (7 days)
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                weekDates.append(date)
            }
        }
        return weekDates
    }
    
    var body: some View {
        VStack {
            // Header with day names (Mon, Tue, etc.)
            HStack(spacing: 0) {
                ForEach(weekDates, id: \.self) { date in
                    Text(dateFormatter.string(from: date))
                        .frame(width: 40)
                        .padding(5)
                        .foregroundColor(.black)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .font(.caption)
                }
            }
            .padding(.top)
            
            // Events row
            HStack(spacing: 16) {
                ForEach(weekDates, id: \.self) { date in
                    VStack {
                        // Event indicators for the specific day
                        ForEach(events.filter { isSameDay($0.date, date) }, id: \.id) { event in
                            Text(event.title)
                                .font(.caption)
                                .padding(6)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .frame(maxWidth: 60)
                        }
                    }
                    .frame(width: 60) // Ensuring each day cell has a fixed width
                }
            }
            .padding(.bottom)
        }
        .padding()
    }
    
    private func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        return calendar.isDate(lhs, inSameDayAs: rhs)
    }
}

// MARK: - Preview
struct WeeklyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyCalendarView(events: [
            tempEvent(title: "Event 1", date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!),
            tempEvent(title: "Event 2", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
            tempEvent(title: "Event 3", date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!),
            tempEvent(title: "Event 4", date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
            tempEvent(title: "Event 5", date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!),
            tempEvent(title: "Event 6", date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!)
        ])
    }
}
