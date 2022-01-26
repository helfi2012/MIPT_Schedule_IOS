//
//  OnboardingVIew.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 02.03.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI
import SmartText

struct OnboardingView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    
    @State private var navigateForward: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("onboarding_title")
                    .font(.system(size: 32, weight: .heavy, design: .default))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                
                self.featuresList
                
                Rectangle()
                    .fill(Color(UIColor.separator))
                    .frame(height: 1)
                
                self.warningSection
                
                self.continueButton
                
                self.likeButton
                
            }
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 16, trailing: 8))
            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 500 : 1000)
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    var warningSection: some View {
        HStack {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 38, weight: .medium, design: .default))
                .foregroundColor(Color(UIColor.systemRed))
                .padding(8)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("onboarding_warning_subtitle")
                    .font(.callout)
                    .bold()
                
                SmartText(attributedString)
                    .useInbuiltBrowser(false)
            }
            
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }
    
    var continueButton: some View {
        VStack(spacing: 0) {
            Button(action: {
                OnboardingView.updateAppVersion()
                navigateForward.toggle()
            }) {
                Text("onboarding_button")
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
            }
            .background(Color.blue)
            .cornerRadius(12)
            
            NavigationLink(
                destination: SearchView().environmentObject(userInfo),
                isActive: $navigateForward
            ) {}
        }
    }
    
    var likeButton: some View {
        Link("onboarding_download_button", destination: URL(string: Constants.MIPT_APP_LINK)!)
            .font(.footnote)
            .padding(.top, 12)
    }
    
    
    private let feautresImages: [String] = ["magnifyingglass",
                                            "square.and.pencil",
                                            "bell",
                                            "note.text"]
    
    private let feautresImagesColor: [UIColor] = [UIColor.systemPink,
                                                  UIColor.systemTeal,
                                                  UIColor.systemOrange,
                                                  UIColor.systemIndigo]
    
    var featuresList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(0..<feautresImages.count, id: \.self) { i in
                
                let subtitle = NSLocalizedString("onboarding_subtitle" + String(i + 1), comment: "")
                let text = NSLocalizedString("onboarding_text" + String(i + 1), comment: "")
                
                HStack {
                    Image(systemName: feautresImages[i])
                        .font(.system(size: 38, weight: .medium, design: .default))
                        .foregroundColor(Color(feautresImagesColor[i]))
                        .padding(8)
                    
                    VStack(alignment: .leading) {
                        Text(subtitle)
                            .font(.callout)
                            .bold()
                        
                        Text(text)
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            }
        }
    }
    
    /**
        MIPT App disclaimer
     */
    var attributedString: NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] =
            [.font: UIFont.systemFont(ofSize: 13),
             .foregroundColor: UIColor.label,]
        
        let string = NSLocalizedString("onboarding_warning_text", comment: "")
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        
        attributedString.addAttribute(.link, value: Constants.MIPT_APP_LINK, range: NSString(string: string).range(of: "MIPT"))
        
        return attributedString
    }
    
    // MARK: Static methods
    
    static let VERSION_KEY: String = "savedVersion"
    
    // Get current Version of the App
    static func getCurrentAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let version = (appVersion as! String)
        return version
    }
    
    static func updateAppVersion() {
        let version = OnboardingView.getCurrentAppVersion()
        UserDefaults.standard.set(version, forKey: OnboardingView.VERSION_KEY)
        UserDefaults.standard.synchronize()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    
    static var previews: some View {
        OnboardingView()
            .environmentObject(UserInfo())
            .environment(\.locale, .init(identifier: "ru"))
            .preferredColorScheme(.light)
    }
}
