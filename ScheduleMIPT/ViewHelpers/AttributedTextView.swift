//
//  AttributedTextView.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 10.03.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI
import UIKit


struct AttributedTextView: UIViewRepresentable {
    var attributedText: NSAttributedString

    init(_ attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }

    func makeUIView(context: Context) -> UITextView {
        return UITextView()
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.attributedText = attributedText
        textView.isEditable = false
        textView.textColor = UIColor.systemGray
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.backgroundColor = UIColor.secondarySystemGroupedBackground
        
        textView.textContainerInset = .zero
        textView.textContainer.maximumNumberOfLines = 2
        textView.textContainer.lineBreakMode = .byTruncatingTail
    }
}

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> NSMutableAttributedString {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
            return self
            
        }
        return self
    }
}
