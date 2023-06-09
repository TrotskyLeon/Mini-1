//
//  CalendarView.swift
//  Mini1
//
//  Created by Randy Julian on 29/04/23.
//
import SwiftUI
import UIKit
import FSCalendar

struct CalendarView: View {
    @State var showError: Bool = false
    @Binding var selectedDate: Date
    @Binding var isFilled: Bool
    @Binding var showSheet: Bool
    @Binding var formFilled: Bool
    @ObservedObject var entryViewModel: EntryViewModel
    @State var showCalendar = true
    
    var body: some View {
        VStack {
            if showCalendar {
                CalendarViewRepresentable(selectedDate: $selectedDate, isFilled: $isFilled, showSheet: $showSheet, entryViewModel: entryViewModel, showError: $showError)
                    .padding(.bottom)
                    .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
                    .frame(maxWidth:350, maxHeight: 400)
            }
            
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Wait"),
                message: Text("It is not time yet"),
                dismissButton: .default(Text("Come back next time"))
            )
        }
        .onChange(of: formFilled, perform: {_ in
            showCalendar = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                showCalendar = true
            }
        })
    }
}

struct CalendarViewRepresentable: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    
    fileprivate var calendar: FSCalendar = FSCalendar()
    @Binding var selectedDate: Date
    @Binding var isFilled: Bool
    @Binding var showSheet: Bool
    @ObservedObject var entryViewModel: EntryViewModel
    @Binding var showError: Bool
    
    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.appearance.todayColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        calendar.appearance.titleTodayColor = UIColor(red: 0.322, green: 0.451, blue: 0.737, alpha: 1)
        calendar.appearance.weekdayTextColor = UIColor(red: 0.322, green: 0.451, blue: 0.737, alpha: 1)
        calendar.appearance.selectionColor = UIColor(red: 0.322, green: 0.451, blue: 0.737, alpha: 1)
        calendar.appearance.eventDefaultColor = UIColor(red: 0.875, green: 0.408, blue: 0.18, alpha: 1)
        calendar.appearance.titleFont = .systemFont(ofSize: 20)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.12
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 30, weight: .black)
        calendar.appearance.headerTitleColor = UIColor(red: 0.875, green: 0.408, blue: 0.18, alpha: 1)
        calendar.appearance.headerDateFormat = "MMMM"
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        calendar.clipsToBounds = false
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarViewRepresentable
        
        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            let todayDate = Date()
            parent.selectedDate = date
            parent.entryViewModel.selectedDateEntry.removeAll()
            calendar.reloadData()
            
            if date <= todayDate {
                parent.showSheet = true
            } else {
                parent.showError = true
            }
            
            guard let sleepRoutine = parent.entryViewModel.getOneEntry(date: parent.selectedDate)
            else {
                parent.isFilled = false
                return
            }
            parent.entryViewModel.selectedDateEntry.append(sleepRoutine)
            parent.isFilled = true
        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let eventDates: [FilledDate] = parent.entryViewModel.filledDate
            var eventCount = 0
            
            eventDates.forEach { eventDate in
                if let filledDate = eventDate.date {
                    if filledDate.formatted(date: .complete, time: .omitted) == date.formatted(date: .complete, time: .omitted){
                        eventCount += 1;
                    }
                }
            }
            return eventCount
        }
    }
}
