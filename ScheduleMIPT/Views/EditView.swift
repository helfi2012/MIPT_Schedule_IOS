//
//  EditView.swift
//  ScheduleMIPT
//
//  Created by Admin on 04.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var schedule: Schedule
    
    var groupNumber: String
    var isCreatingMode = false
    var item: ScheduleItem! = nil
    
    private let weekLabels = StringUtils.getWeekLabels()
    private let typeLabels = StringUtils.getTypeLabels()
    
    @State private var lessonText: String = ""
    @State private var placeText: String = ""
    @State private var profText: String = ""
    
    @State private var selectedTypeIndex: Int = 0
    @State private var selectedDayIndex: Int = 0
    
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(TimeInterval(3600))
    
    @State private var notesText: String = ""
    
    @State private var showingAlert = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        Form {
            Section(header: Text("lesson_information_header")) {
                TextField("lesson_text", text: $lessonText)
                TextField("place_text", text: $placeText)
                TextField("prof_text", text: $profText)
            }
            Section(header: Text("date_time_header")) {
            
                Picker("day_text", selection: $selectedDayIndex) {
                    ForEach(0..<weekLabels.count) {
                        Text(self.weekLabels[$0])
                    }
                }
                
                DatePicker(selection: $startTime, in: ...Date(), displayedComponents: .hourAndMinute) {
                    Text("start_time_text")
                }
                
                DatePicker(selection: $endTime, in: ...Date(), displayedComponents: .hourAndMinute) {
                    Text("end_time_text")
                }
            }
            Section(header: Text("extra_header")) {
                Picker("type_text", selection: $selectedTypeIndex) {
                    ForEach(0..<typeLabels.count) {
                        Text(self.typeLabels[$0])
                    }
                }
                TextField("notes_text", text: $notesText)
            }
            Section() {
                Button(action: {
                    self.showingAlert = true
                }) {
                    Text("delete_button_text").foregroundColor(Color.red)
                }
            }
        }.onAppear {
            if (self.isCreatingMode) {
                
            } else {
                self.bindInitialData()
            }
        }.onDisappear {
            print("ContentView disappeared!")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("dialog_title"),
                  message: Text("dialog_message"),
                  primaryButton: .default(Text("dialog_ok_button")) {
                    self.deleteItem()
                    self.mode.wrappedValue.dismiss()
                },
                  secondaryButton: .default(Text("dialog_cancel_button"))
            )
        }
            
        .navigationBarTitle(isCreatingMode ? "creating_text" : "editing_text")
        .navigationBarItems(trailing:
            HStack(alignment: .center, spacing: 16) {
                Button(action: {
                    if (self.isCreatingMode) {
                        self.saveNewData()
                    } else {
                        self.overwriteData()
                    }
                    self.mode.wrappedValue.dismiss()
                }) {
                    Text("save_button_text")
                }
            })
    }
    
    // MARK: Data work
    
    private func bindInitialData() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.lessonText = self.item.name
        self.placeText = self.item.place
        self.profText = self.item.prof
        self.notesText = self.item.notes
        self.selectedTypeIndex = StringUtils.TYPE_KEYS.firstIndex(of: self.item.type)!
        self.selectedDayIndex = self.item.day - 1
        self.startTime = dateFormatter.date(from: self.item.startTime)!
        self.endTime = dateFormatter.date(from: self.item.endTime)!
    }
    
    private func deleteItem() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let schedule = app.schedule!
        var lessons = schedule.timetable[groupNumber]!
        lessons.remove(at: lessons.firstIndex(of: item)!)
        schedule.timetable[groupNumber] = lessons
        app.updateTimeTable(updatedSchedule: schedule)
    }
    
    private func newItem() -> ScheduleItem {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return ScheduleItem(name: self.lessonText,
                                prof: self.profText,
                                place: self.placeText,
                                day: self.selectedDayIndex + 1,
                                type: StringUtils.TYPE_KEYS[self.selectedTypeIndex],
                                startTime: dateFormatter.string(from: self.startTime),
                                endTime: dateFormatter.string(from: self.endTime),
                                notes: self.notesText)
    }
    
    private func saveNewData() {
        let newItem = self.newItem()
        var lessons = schedule.timetable[groupNumber]!
        lessons.append(newItem)
        lessons.sort(by: {
            if ($0.day != $1.day) {
                return $0.day > $1.day
            } else {
                return TimeUtils.compareTime(t1: $0.startTime, t2: $1.startTime)
            }
        })
        schedule.timetable[groupNumber] = lessons
        let app = UIApplication.shared.delegate as! AppDelegate
        app.updateTimeTable(updatedSchedule: schedule)
    }
    
    private func overwriteData() {
        let newItem = self.newItem()
        var lessons = schedule.timetable[groupNumber]!
        let pos = lessons.firstIndex(of: item)!
        lessons[pos] = newItem
        lessons.sort(by: {
            if ($0.day != $1.day) {
                return $0.day > $1.day
            } else {
                return TimeUtils.compareTime(t1: $0.startTime, t2: $1.startTime)
            }
        })
        schedule.timetable[groupNumber] = lessons
        let app = UIApplication.shared.delegate as! AppDelegate
        app.updateTimeTable(updatedSchedule: schedule)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(groupNumber: "Б02-824", isCreatingMode: false, item: ScheduleItem.example)
            .environmentObject((UIApplication.shared.delegate as! AppDelegate).schedule)
            .environment(\.locale, .init(identifier: "ru"))
    }
}
