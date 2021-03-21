//
//  SettingsView.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 20.02.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI
import UIKit
import EventKit
import UserNotifications


struct SettingsView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    
    @EnvironmentObject var schedule: Schedule
    
    @ObservedObject var observableShowBreaks: ObservableBool
    
    @State var showBreaks: Bool = UserDefaults.standard.bool(forKey: SettingsView.BREAKS_KEY)
    
    @State var notificationsEnabled: Bool = UserDefaults.standard.bool(forKey: SettingsView.NOTIFICATIONS_KEY)
    
    @State private var notifyOption = UserDefaults.standard.integer(forKey: SettingsView.NOTIFY_MINUTES_KEY)
    
    // List of notification options
    var notifyOptions = StringUtils.getMinutesLabels()
    
    // Responsible for toggling alert window
    @State private var showNotificationsAccessDeniedAlert = false
    
    @State private var showDeleteAlert = false
    
    @State private var showExportAlert = false
    
    @State private var showCalendarAccessDeniedAlert = false
    
    @State private var showProgress = false
    
    @State private var showShareSheet = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            NavigationView {
                
                Form {
                    
                    Section(header: Text("settings_general")) {
                        // Group number picker
                        HStack {
                            NavigationLink(destination: SearchView().environmentObject(userInfo)) {
                                HStack {
                                    Text("settings_group")
                                    Spacer()
                                    Text(userInfo.groupNumber)
                                        .foregroundColor(Color(UIColor.systemGray))
                                }
                            }
                        }
                        
                        // Break toggle
                        HStack {
                            Toggle(isOn: $showBreaks) {
                                Text("settings_breaks")
                            }.onChange(of: showBreaks) { value in
                                
                                observableShowBreaks.value = value
                                
                                UserDefaults.standard.set(value, forKey: SettingsView.BREAKS_KEY)
                            }
                        }
                    }
                    
                    Section() {
                        // Import button
                        HStack {
                            Button(action: {
                                showExportAlert.toggle()
                            }) {
                                Text("settings_export_button")
                                    .foregroundColor(Color.blue)
                            }.alert(isPresented: $showExportAlert) {
                                exportAlert()
                            }
                            
                            Text("")
                                .alert(isPresented: $showCalendarAccessDeniedAlert) {
                                    calendarAccessDeniedAlert()
                                }
                        }
                        
                        // Reset button
                        Button(action: {
                            self.showDeleteAlert = true
                        }) {
                            Text("settings_reset_button")
                                .foregroundColor(Color.red)
                        }.alert(isPresented: $showDeleteAlert) {
                            deleteAlert()
                        }
                        
                        // Reset text
                        Text("settings_reset_description")
                            .font(.footnote)
                            .foregroundColor(Color(UIColor.systemGray))
                        
                    }
                    
                    Section(header: Text("settings_notifications")) {
                        
                        // Notification toggle
                        Toggle(isOn: $notificationsEnabled) {
                            Text("settings_notifications_enabled")
                        }.onChange(of: notificationsEnabled) { value in
                            UserDefaults.standard.set(value, forKey: SettingsView.NOTIFICATIONS_KEY)
                            if value {
                                requestNotificationPermission()
                            } else {
                                NotificationUtils.cancelNotifications()
                            }
                        }.alert(isPresented: $showNotificationsAccessDeniedAlert) {
                            notificationsAccessDeniedAlert()
                        }
                        
                        // Minutes picker
                        Picker(selection: $notifyOption, label: Text("settings_notifications_time")) {
                            ForEach(0 ..< notifyOptions.count) {
                                Text(self.notifyOptions[$0])
                            }
                        }
                        .onChange(of: notifyOption) { value in
                            // Update preferences
                            UserDefaults.standard.set(value, forKey: SettingsView.NOTIFY_MINUTES_KEY)
                            
                            // Update notifications
                            NotificationUtils.scheduleNotifications(key: userInfo.groupNumber, schedule: schedule)
                        }.disabled(notificationsEnabled == false)
                        
                        
                        Text("settings_notifications_description")
                            .font(.footnote)
                            .foregroundColor(Color(UIColor.systemGray))
                    }
                    
                    Section(header: Text("settings_communication")) {
                        
                        // Share button
                        Button(action: {
                            showShareSheet = true
                        }) {
                            Text("settings_share")
                        }
                        
                        // Write to developer button
                        Button(action: {
                            if let url = URL(string: Constants.DEVELOPER_LINK) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("settings_developer")
                        }
                        
                        // Rate button
                        Button(action: {
                            if let url = URL(string: Constants.RATE_LINK) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("settings_rate")
                        }
                    }
                    
                    // About section
                    Section(header: Text("settings_about")) {
                        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                        
                        // Version info
                        HStack {
                            Text("settings_version")
                            Spacer()
                            Text(version)
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        
                        // Thanks info
                        
                        // Attributed text (link was not appropriate to Apple Guidlines
                        /*
                        AttributedTextView(getAttributedText())
                            .padding(EdgeInsets(top: 0, leading: -4, bottom: 0, trailing: 0))
                            .frame(height: UIDevice.current.userInterfaceIdiom == .phone ? 45 : 20)
                        */
                        
                        Text("settings_thanks")
                            .foregroundColor(Color(UIColor.systemGray))
                            .font(.footnote)
                    }
                    
                }.navigationBarTitle("settings_title")
                .sheet(isPresented: $showShareSheet, content: {
                    let items = [NSLocalizedString("settings_share_text", comment: ""), URL(string: Constants.SHARE_LINK)!]
                    ShareSheet(activityItems: items)
                })
            }.navigationViewStyle(StackNavigationViewStyle())
            .padding(UIDevice.current.userInterfaceIdiom == .pad ? 16 : 0)
            .background(Color(UIColor.systemGroupedBackground))
            .blur(radius: showProgress ? 5.0 : 0.0)
            
            if showProgress {
                ProgressView("settings_upload_title")
                    .progressViewStyle(CircularProgressViewStyle())
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color(UIColor.systemGray4))
                                .frame(width: 150,
                                       height: 80,
                                       alignment: .center)
                        }
                    )
                    .transition(.opacity)
                    .zIndex(1)
            }
            
        }
    }
    
    // MARK: Permissions
    
    /**
        Tries to request notification permission, if succesful enable notifications, otherwise shows `notificationsAccessDeniedAlert`
     */
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                NotificationUtils.scheduleNotifications(key: userInfo.groupNumber, schedule: schedule)
            } else {
                center.getNotificationSettings { settings in
                    if settings.authorizationStatus != .authorized {
                        self.notificationsEnabled = false
                        self.showNotificationsAccessDeniedAlert = true
                        UserDefaults.standard.set(self.notificationsEnabled, forKey: SettingsView.NOTIFICATIONS_KEY)
                    }
                }
            }
        }
        
    }
    
    /**
        Tries to request calendar permission, if succesful export schedule to Calendar, otherwise shows `calendarAccessDeniedAlert`
     */
    func requestCalendarPermission() {
        let eventStore : EKEventStore = EKEventStore()

        eventStore.requestAccess(to: .event) { (granted, error) in
          
            if (granted) && (error == nil) {
                withAnimation {
                    showProgress.toggle()
                }
                
                let _ = EventUtils.exportToCalendar(lessons: schedule.timetable[userInfo.groupNumber]!)
                
                withAnimation {
                    showProgress.toggle()
                }
            } else {
                self.showCalendarAccessDeniedAlert.toggle()
            }
        }
    }
    
    // MARK: Alerts
    
    // Alerts about reseting schedule
    func deleteAlert() -> Alert {
        return Alert(title: Text("dialog_title"),
              message: Text("settings_reset_dialog"),
              primaryButton: .default(Text("dialog_ok_button")) {
                self.resetSchedule()
                self.mode.wrappedValue.dismiss()
            },
              secondaryButton: .default(Text("dialog_cancel_button"))
        )
    }
    
    
    // Alerts about exporting schedule to Calendar
    func exportAlert() -> Alert {
        return Alert(title: Text("dialog_title"),
              message: Text("settings_export_dialog"),
              primaryButton: .default(Text("dialog_ok_button")) {
                self.requestCalendarPermission()
                self.mode.wrappedValue.dismiss()
            },
              secondaryButton: .default(Text("dialog_cancel_button"))
        )
    }
    
    
    // Shows access-denied alert that says that user should turn on notifications in the settings
    func notificationsAccessDeniedAlert() -> Alert {
        return Alert(title: Text("settings_notifications_permission_title"),
              message: Text("settings_notifications_permission_description"),
              primaryButton: .default(Text("settings_notifications_permission_ok_button")) {
                if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings as URL)
                }
                self.mode.wrappedValue.dismiss()
            },
              secondaryButton: .default(Text("dialog_cancel_button"))
        )
    }
    
    // Shows access-denied alert that says that user should turn on notifications in the settings
    func calendarAccessDeniedAlert() -> Alert {
        return Alert(title: Text("settings_notifications_permission_title"),
              message: Text("settings_export_permission_description"),
              primaryButton: .default(Text("settings_notifications_permission_ok_button")) {
                if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings as URL)
                }
                self.mode.wrappedValue.dismiss()
            },
              secondaryButton: .default(Text("dialog_cancel_button"))
        )
    }
    
    // Returns 'thanks text' with a link to fund.mipt
    func getAttributedText() -> NSMutableAttributedString {
        let string = NSLocalizedString("settings_thanks", comment: "")
        let link_key = NSLocalizedString("settings_thanks_key", comment: "")
        let attributedString = NSMutableAttributedString(string: string)
        return attributedString.setAsLink(textToFind: link_key, linkURL: Constants.FUND_LINK)
    }
    
    // MARK: Working with data
    
    static let BREAKS_KEY = "breaks_key"
    
    static let NOTIFICATIONS_KEY = "notifications_key"
    
    static let NOTIFY_MINUTES_KEY = "notify_minutes_key"
    
    static func getMinutesBefore(option: Int) -> Int {
        switch option {
            case 0: return 1
            case 1: return 5
            default: return 10
        }
    }
    
    /**
        Creating keys and setting up default parameters
     */
    static func registerDefaults() {
        UserDefaults.standard.register(
            defaults: [
                BREAKS_KEY: false,
                NOTIFICATIONS_KEY: false,
                NOTIFY_MINUTES_KEY: 1
            ]
        )
    }
    
    // Reseting all changes in schedule
    func resetSchedule() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let schedule = app.schedule!
        schedule.timetable = DataUtils.loadScheduleFromAssets().timetable
        app.updateTimeTable(updatedSchedule: schedule)
    }
}


struct SettingsView_Previews: PreviewProvider {
    
    static let userInfo = UserInfo(groupNumber: "Б02-824")
    
    static var previews: some View {
        SettingsView(observableShowBreaks: ObservableBool(value: false))
            .environmentObject(userInfo)
            .environmentObject((UIApplication.shared.delegate as! AppDelegate).schedule)
            .environment(\.locale, .init(identifier: "ru"))
            .preferredColorScheme(.dark)
    }
}
