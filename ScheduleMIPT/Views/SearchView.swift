//
//  SearchView.swift
//  ScheduleMIPT
//
//  Created by Admin on 05.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI
import WidgetKit
import Fuzzy


/**
    This view allows the user to find its group and choose it. Implements fast fuzzy search engine.
 */

struct SearchView: View {
    
    @State private var query: String = ""
    
    @State private var newGroup: String = ""
    
    @State private var showSheet: Bool = false
    
    @EnvironmentObject var userInfo: UserInfo
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            SearchBar(text: $query,
                      placeholder: NSLocalizedString("search_hint", comment: "")
            )
                .padding(EdgeInsets(top: 4, leading: 10, bottom: -10, trailing: 10))
            
            // List
            listView()
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("search_newgroup") {
                showSheet = true
            }
        )
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $showSheet) {
            NewGroupView(showSheet: $showSheet, groupNumber: $newGroup)
                .onChange(of: newGroup, perform: { value in
                    showSheet = false
                    let app = UIApplication.shared.delegate as! AppDelegate
                    app.addNewGroup(groupNumber: newGroup)
                    chooseGroup(text: newGroup)
                })
        }
    }
    
    
    /**
        This complicated `List` includes search results (fuzzy search) and recent groups
     */
    private func listView() -> some View {
        let recentGroups = DataUtils.loadRecentGroups() ?? []
        
        return List {
            if recentGroups.count != 0 {
                Section(header: Text("search_recent").font(.callout)) {
                    ForEach(recentGroups, id: \.self) { text in
                        Button(action: {
                            chooseGroup(text: text)
                        }) {
                            HStack {
                                Image(systemName: "star.fill")
                                Text(text)
                                    .foregroundColor(Color(UIColor.label))
                                Spacer()
                            }
                        }
                    }
                }
                
                Section() {
                    let filteredGroups = getFilteredGroups()
                    if filteredGroups.count == 0 {
                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                Text("😔")
                                    .font(.system(size: 40))
                                    .padding(4)
                                Text("search_empty")
                            }
                            Spacer()
                        }.padding(16)
                        
                    } else {
                        ForEach(filteredGroups, id: \.self) { text in
                            Button(action: {
                                chooseGroup(text: text)
                            }) {
                                Text(text)
                                    .foregroundColor(Color(UIColor.label))
                            }
                        }
                    }
                }
            } else {
                let filteredGroups = getFilteredGroups()
                if filteredGroups.count == 0 {
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Text("😔")
                                .font(.system(size: 40))
                                .padding(4)
                            Text("search_empty")
                        }
                        Spacer()
                    }.padding(16)
                    
                } else {
                    ForEach(filteredGroups, id: \.self) { text in
                        Button(action: {
                            chooseGroup(text: text)
                        }) {
                            Text(text)
                                .foregroundColor(Color(UIColor.label))
                        }
                    }
                }
            }
        }.listStyle(InsetGroupedListStyle())
    }
    
    
    private func chooseGroup(text: String) {
        // Update userInfo
        DataUtils.modifyGroupNumber(key: text)
        self.userInfo.isEmpty = false
        self.userInfo.groupNumber = text
        
        // Update notifications
        let app = UIApplication.shared.delegate as! AppDelegate
        app.updateNotifications(updatedUserInfo: self.userInfo)
        
        // Update recent groups
        updateRecentGroups(newGroup: text)
        
        // Update widgets
        WidgetCenter.shared.reloadTimelines(ofKind: Constants.WIDGET_KIND)
        
        // Cancel this view & go back to previous one
        self.mode.wrappedValue.dismiss()
    }
    
    /**
        This function allows to get all group names:
        - Returns list of group names
     */
    private func getAllGroups() -> [String] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return Array(appDelegate.schedule.timetable.keys)
    }
    
    private func getFilteredGroups() -> [String] {
        return getAllGroups().filter { search(needle: query.lowercased(), haystack: $0.lowercased()) }
    }
    
    private static let MAX_RECENT_COUNT: Int = 3
    
    private func updateRecentGroups(newGroup: String) {
        let oldGroups = DataUtils.loadRecentGroups() ?? []
        if oldGroups.contains(newGroup) {
            return
        }
        var newGroups = oldGroups + [newGroup]
        if (newGroups.count > SearchView.MAX_RECENT_COUNT) {
            newGroups.removeFirst()
        }
        DataUtils.modifyRecentGroups(groups: newGroups)
    }
}

struct SearchView_Previews: PreviewProvider {
    
    static let userInfo = UserInfo()
    
    static var previews: some View {
        SearchView()
            .environmentObject(userInfo)
            .environment(\.locale, .init(identifier: "ru"))
            .preferredColorScheme(.light)
    }
}
