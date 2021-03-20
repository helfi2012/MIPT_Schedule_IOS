//
//  EditView.swift
//  ScheduleMIPT
//
//  Created by Admin on 04.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI


/**
 `EditView` allows the user to change information about the lesson or create new lesson
 */
struct EditView: View {
    @EnvironmentObject var schedule: Schedule
    
    // User's group name
    var groupNumber: String
    
    // `false` means editing mode, `true` means creating mode
    var isCreatingMode = false
    
    // Item to edit if not nil
    var item: ScheduleItem! = nil
    
    // Array containing localized names of days of the week
    private let weekLabels = StringUtils.getWeekLabels()
    
    // Array containing localized names of lesson types
    private let typeLabels = StringUtils.getTypeLabels()
    
    @State private var lessonText: String = ""
    @State private var placeText: String = ""
    @State private var profText: String = ""
    
    @State private var selectedType: String = "SEM"
    @State private var selectedDayIndex: Int = 0
    
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(TimeInterval(3600))
    
    @State private var notesText: String = ""
    
    @State private var showingAlert = false
    
    @State private var pickerVisible = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        Form {
            // General section
            Section(header: Text("lesson_information_header")) {
                TextField("lesson_text", text: $lessonText)
                TextField("place_text", text: $placeText)
                TextField("prof_text", text: $profText)
            }
            
            // Time & date section
            Section(header: Text("date_time_header")) {
            
                HStack {
                    Text("day_text")
                    
                    Spacer()
                    
                    Button(action: {
                        self.pickerVisible.toggle()
                    }) {
                        Text(self.weekLabels[selectedDayIndex])
                            .foregroundColor(Color(UIColor.systemGray))
                    }
                }
                if pickerVisible {
                    Picker("day_text", selection: $selectedDayIndex) {
                        ForEach(0..<weekLabels.count, id: \.self) { i in
                            Text(self.weekLabels[i])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxHeight: 150)
                    .onTapGesture(perform: {
                        self.pickerVisible.toggle()
                    })
                }
                
                DatePicker(selection: $startTime, in: ...Date(), displayedComponents: .hourAndMinute) {
                    Text("start_time_text")
                }.onChange(of: startTime, perform: { value in
                    if (startTime.distance(to: endTime) < 0) {
                        endTime = Calendar.current.date(byAdding: .minute, value: 1, to: startTime)!
                    }
                })
                
                DatePicker(selection: $endTime, in: ...Date(), displayedComponents: .hourAndMinute) {
                    Text("end_time_text")
                }.onChange(of: endTime, perform: { value in
                    if (startTime.distance(to: endTime) < 0) {
                        startTime = Calendar.current.date(byAdding: .minute, value: -1, to: endTime)!
                    }
                })
            }
            
            // Extra section
            Section(header: Text("extra_header")) {
                
                HStack {
                    Spacer()
                    ColorSwatchView(selection: $selectedType)
                    Spacer()
                }
                
                TextField("notes_text", text: $notesText)
                
            }
            
            // Delete section
            Section() {
                Button(action: {
                    self.showingAlert = true
                }) {
                    Text("delete_button_text").foregroundColor(Color.red)
                }
            }
        }.onAppear {
            if (self.isCreatingMode) {
                self.prepareCreatingMode()
            } else {
                self.bindInitialData()
            }
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
                }.disabled(lessonText.isEmpty)
            })

    }
    
    // MARK: Data work
    
    /**
        Setting default values to pickers for the first launch
     */
    private func prepareCreatingMode() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        self.startTime = dateFormatter.date(from: "10:45")!
        self.endTime = dateFormatter.date(from: "12:10")!
        
//        if self.selectedDayIndex == -1 {
//            self.selectedDayIndex = 0
//        }
        self.selectedDayIndex = 0
    }
    /**
        Loading initial information to the views from ItemView (Editing mode)
     */
    private func bindInitialData() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.lessonText = self.item.name
        self.placeText = self.item.place
        self.profText = self.item.prof
        self.notesText = self.item.notes
        self.selectedType = self.item.type
//        if self.selectedDayIndex == -1 {
//            self.selectedDayIndex = self.item.day - 1
//        }
        self.selectedDayIndex = self.item.day - 1
        self.startTime = dateFormatter.date(from: self.item.startTime)!
        self.endTime = dateFormatter.date(from: self.item.endTime)!
    }
    
    /**
        Deleting current lesson and updating the schedule
     */
    private func deleteItem() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let schedule = app.schedule!
        var lessons = schedule.timetable[groupNumber]!
        lessons.remove(at: lessons.firstIndex(of: item)!)
        schedule.timetable[groupNumber] = lessons
        app.updateTimeTable(updatedSchedule: schedule)
    }
    
    /**
        Creating new ScheduleItem from user's input
     */
    private func newItem() -> ScheduleItem {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return ScheduleItem(name: self.lessonText,
                                prof: self.profText,
                                place: self.placeText,
                                day: self.selectedDayIndex + 1,
                                type: self.selectedType,
                                startTime: dateFormatter.string(from: self.startTime),
                                endTime: dateFormatter.string(from: self.endTime),
                                notes: self.notesText)
    }
    
    /**
        Creating new lesson and updating the schedule (Creating mode)
     */
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
    
    /**
        Saving changes in the existing lesson (Editing mode)
     */
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
