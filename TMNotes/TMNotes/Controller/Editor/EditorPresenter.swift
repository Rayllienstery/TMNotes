//
//  EditorPresenter.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

extension EditorViewController {
    func initUI() {
        self.titleTextView.contentInset = .init(top: 4, left: 8, bottom: 4, right: 8)
        self.contentTextView.contentInset = .init(top: 4, left: 8, bottom: 4, right: 8)

        if let note = note {
            self.titleTextView.text = note.title
            self.contentTextView.text = note.content

            if let folder = FoldersProvider.shared.getFolder(noteId: note.id) {
                self.folder = folder
                setFolderUI(folder: folder)
            }
        }
    }

    func showErrorSyncAlert() {
        let alert = UIAlertController(title: "Oops",
                                      message: "Comething was wrong with note save", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func becomeEdit() {
        self.contentTextView.becomeFirstResponder()
    }

    func setFolderUI(folder: Folder?) {
        if let folder = folder {
            self.removeFolderButton.isHidden = false
            self.folderTitle.text = folder.title
            if let folderImage = folder.imagePath {
                self.folderImageView.image = UIImage(systemName: folderImage)
            } else {
                folderImageView.image = UIImage(systemName: "folder")
            }
        } else {
            self.folderTitle.text = "Without folder"
            self.folderImageView.image = UIImage(systemName: "questionmark.folder")
            self.removeFolderButton.isHidden = true
        }
    }
}
