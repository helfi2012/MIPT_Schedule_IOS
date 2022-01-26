//
//  NewGroupView.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 26.02.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI


struct NewGroupView: View {
    
    @Binding var showSheet: Bool
    
    @Binding var groupNumber: String
    
    @State private var text: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("newgroup_placeholder", text: $text)

                    Text("newgroup_description")
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
                
                Spacer()
            }
            .navigationBarTitle(Text("newgroup_bartitle"), displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    showSheet = false
                }) {
                    Text("dialog_cancel_button").bold()
                },
                                trailing:
                Button(action: {
                    groupNumber = text
                }) {
                    Text("newgroup_button").bold()
                }.disabled(text.isEmpty)
            )
            .ignoresSafeArea(.all, edges: .bottom)
        }
        
    }
}

struct NewGroupView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewGroupView(showSheet: .constant(true), groupNumber: .constant(""))
    }
}
