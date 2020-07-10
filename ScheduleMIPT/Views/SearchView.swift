//
//  SearchView.swift
//  ScheduleMIPT
//
//  Created by Admin on 05.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI
import Fuzzy

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    
    var placeholder: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct SearchView: View {
    
    @State private var query: String = ""
    
    @EnvironmentObject var userInfo: UserInfo
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            SearchBar(text: $query, placeholder: NSLocalizedString("search_hint", comment: ""))
            List {
                ForEach(getData().filter { search(needle: query, haystack: $0) }, id: \.self) { text in
                    Button(action: {
                        DataUtils.modifyMainKey(key: text)
                        self.userInfo.isEmpty = false
                        self.userInfo.groupNumber = text
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Text(text)
                    }
                }
            }
        }
        .navigationBarTitle("search_title")
    }
    
    private func getData() -> [String] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return Array(appDelegate.schedule.timetable.keys)
    }
}

struct SearchView_Previews: PreviewProvider {
    
    static let userInfo = UserInfo()
    
    static var previews: some View {
        SearchView().environmentObject(userInfo)
        .environment(\.locale, .init(identifier: "ru"))
    }
}
