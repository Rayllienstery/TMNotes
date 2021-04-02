//
//  EditorProvider.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

extension EditorViewController {
    func initProvider() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundClick(_:)))
        self.containerScrollView.addGestureRecognizer(tap)

//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//            self.titleTextView.becomeFirstResponder()
//        }
    }

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

    @objc func backgroundClick(_ sender: UITapGestureRecognizer? = nil) {
        self.contentTextView.becomeFirstResponder()
    }
}

extension EditorViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.last == " " {
            guard let tag = textField.text?.replacingOccurrences(of: " ", with: "") else { return }
            if !tags.contains(tag) {
                DispatchQueue.main.async {
                    self.tags.append(tag)
                    self.tags.sort(by: {$0 < $1})
                }
            }

            textField.text?.removeAll()
        }
    }
}
