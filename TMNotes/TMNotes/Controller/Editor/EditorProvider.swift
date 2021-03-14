//
//  EditorProvider.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

extension EditorViewController {
    func saveNoteIfNecessary() {
        if self.titleTextView.text.count > 0 || self.contentTextView.text.count > 0 {
            NotesProvider.shared.addNote(
                title: titleTextView.text,
                content: contentTextView.text)
        }
    }
}
