//
//  ScrollManagerView.swift
//  ScheduleMIPT
//
//  Created by Admin on 08.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI

struct ScrollManagerView: UIViewRepresentable {
    
    @Binding var indexPathToSetVisible: IndexPath?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let indexPath = indexPathToSetVisible else { return }
        let superview = uiView.findViewController()?.view
        
        if let tableView = superview?.subview(of: UITableView.self) {
            if tableView.numberOfSections > indexPath.section &&
                tableView.numberOfRows(inSection: indexPath.section) > indexPath.row {
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
        DispatchQueue.main.async {
            self.indexPathToSetVisible = nil
        }
    }
}

extension UIView {
    
    func subview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(of: type) }.first
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
