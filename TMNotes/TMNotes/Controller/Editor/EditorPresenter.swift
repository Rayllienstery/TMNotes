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
            DispatchQueue.main.async {
                self.titleTextView.becomeFirstResponder()
            }
        }
    }
}
