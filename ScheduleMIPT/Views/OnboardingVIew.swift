//
//  OnboardingVIew.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 02.03.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    
    @State private var isLinkActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Text("onboarding_title")
                    .font(.system(size: 32, weight: .heavy, design: .default))
                    .padding()
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 38, weight: .medium, design: .default))
                        .foregroundColor(Color(UIColor.systemPink))
                        .padding(8)
                    
                    VStack(alignment: .leading) {
                        Text("onboarding_search_title")
                            .font(.callout)
                            .bold()
                        
                        Text("onboarding_search_description")
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                }.padding(12)
                
                HStack {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 38, weight: .medium, design: .default))
                        .foregroundColor(Color(UIColor.systemTeal))
                        .padding(8)
                    
                    VStack(alignment: .leading) {
                        Text("onboarding_edit_title")
                            .font(.callout)
                            .bold()
                        
                        Text("onboarding_edit_description")
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                }.padding(12)
                
                HStack {
                    Image(systemName: "bell")
                        .font(.system(size: 38, weight: .medium, design: .default))
                        .foregroundColor(Color(UIColor.systemOrange))
                        .padding(8)
                    
                    VStack(alignment: .leading) {
                        Text("onboarding_notification_title")
                            .font(.callout)
                            .bold()
                        
                        Text("onboarding_notification_description")
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                }.padding(12)
                
                HStack {
                    Image(systemName: "note.text")
                        .font(.system(size: 38, weight: .medium, design: .default))
                        .foregroundColor(Color(UIColor.systemIndigo))
                        .padding(8)
                    
                    VStack(alignment: .leading) {
                        Text("onboarding_widget_title")
                            .font(.callout)
                            .bold()
                        
                        Text("onboarding_widget_description")
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                }.padding(12)
                
                Spacer()
                
                Button(action: {}) {
                    NavigationLink(destination: SearchView().environmentObject(userInfo)) {
                        Text("onboarding_button")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                    .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
                    .background(Color.blue)
                    .cornerRadius(10)

                
                
            }.padding(EdgeInsets(top: 8, leading: 8, bottom: 16, trailing: 8))
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 500 : 1000)
            .navigationBarHidden(true)
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}


struct OnboardingView_Previews: PreviewProvider {
    
    static var previews: some View {
        OnboardingView()
            .environmentObject(UserInfo())
            .environment(\.locale, .init(identifier: "ru"))
            .preferredColorScheme(.dark)
    }
}
