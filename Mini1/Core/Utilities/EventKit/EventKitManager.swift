//
//  EventKitManager.swift
//  Mini1
//
//  Created by Nadya Tyandra on 29/04/23.
//

import Foundation
import SwiftUI
import EventKit

class EventKitManager: ObservableObject {
    let eventStore = EKEventStore()
    @Published var emptyReminderList: Bool = false
    
    func requestAccess() {
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            if granted {
                print("Access granted")
            } else {
                print("Access to reminders not granted")
            }
        }
    }
    
    func addReminder(name: String, hour: Int, minute: Int) {
        if eventStore.defaultCalendarForNewReminders() != nil {
            emptyReminderList = false
            
            let reminder = EKReminder(eventStore: eventStore)

            reminder.title = "\(name)'s Bedtime"
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            
            let recurrenceRule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)
            reminder.addRecurrenceRule(recurrenceRule)
            
            let dueDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
            reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            
            do {
                try eventStore.save(reminder, commit: true)
                print("Reminder created successfully")
            } catch {
                print("Error creating reminder: \(error.localizedDescription)")
            }
        } else {
            emptyReminderList = true
        }
    }
    
    func editReminder(oldName: String, newName: String, hour: Int, minute: Int) {
        let predicate: NSPredicate? = eventStore.predicateForReminders(in: nil)
        if let aPredicate = predicate {
            eventStore.fetchReminders(matching: aPredicate, completion: { [self](_ reminders: [Any]?) -> Void in
                for reminder: EKReminder? in reminders as? [EKReminder?] ?? [EKReminder?]() {
                    if reminder?.title == "\(oldName)'s Bedtime" {
                        do {
                            try eventStore.remove(reminder!, commit: true)
                            addReminder(name: newName, hour: hour, minute: minute)
                        } catch {
                            print("error")
                        }
                    }
                }
            })
        }
    }
}
