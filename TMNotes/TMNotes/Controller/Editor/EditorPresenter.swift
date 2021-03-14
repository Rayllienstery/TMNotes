//
//  EditorPresenter.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

extension EditorViewController {
    func initUI() {
        if let note = note {
            self.titleTextView.text = note.title
            self.contentTextView.text = note.content
        } else {
//            DispatchQueue.main.async {
//                self.titleTextView.becomeFirstResponder()
//            }
        }
    }

    func showErrorSyncAlert() {
        let alert = UIAlertController(title: "Oops",
                                      message: "Comething was wrong with note save", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
