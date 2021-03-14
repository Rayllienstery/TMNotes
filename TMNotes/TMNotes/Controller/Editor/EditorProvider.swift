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
            if let note = note {
                note.title = self.titleTextView.text
                note.content = self.contentTextView.text
                guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                        .persistentContainer.viewContext else {
                    self.showErrorSyncAlert()
                    return
                }
                NotesProvider.shared.sync(context)
            } else {
                NotesProvider.shared.addNote(
                    title: titleTextView.text,
                    content: contentTextView.text)
            }
        } else {
            deleteNoteIfNecessary()
        }
        //TODO: IMAGES checker, VOICE checker if will be implemented
    }

    func deleteNoteIfNecessary() {
        if let note = note {
            NotesProvider.shared.deleteNote(note, nil)
        }
    }
}
