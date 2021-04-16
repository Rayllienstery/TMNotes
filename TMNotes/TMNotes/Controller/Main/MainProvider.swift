//
//  MainProvider.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

extension MainViewController {
    func initProvider() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateUI), name: .foldersUpdated, object: nil)
    }

     func fetchNotes() {
        self.notes = NotesProvider.shared.getNotes(folder: folder) ?? []
        self.notes.sort(by: {$0.pinned && !$1.pinned})
        self.folders = FoldersProvider.shared.getFolders()
    }

    func viewWillAppearCompletion() {
        DispatchQueue.main.async {
            self.fetchNotes()
            self.notesListTableView.reloadData()
            self.notesCounterLabel.text = "\(self.notes.count) notes"
        }
    }

    func trashNote(indexPath: IndexPath) {
        guard let note = getNoteFromCell(indexPath: indexPath) else { return }
        NotesProvider.shared.markAsTrashed(note, status: true) {
            self.notesListTableView.beginUpdates()
            self.notes.remove(at: indexPath.row)
            self.notesListTableView.deleteRows(at: [indexPath], with: .automatic)
            self.notesListTableView.endUpdates()
        }
    }

    func restoreNote(indexPath: IndexPath) {
        guard let note = getNoteFromCell(indexPath: indexPath) else { return }
        NotesProvider.shared.markAsTrashed(note, status: false) {
            self.fetchNotes()
            self.notesListTableView.reloadData()
        }
    }

    func pinNote(indexPath: IndexPath) {
        guard let note = getNoteFromCell(indexPath: indexPath) else { return }
        NotesProvider.shared.markAsPinned(note) {
            self.fetchNotes()
            self.notesListTableView.reloadData()
        }
    }

    func starNote(indexPath: IndexPath) {
        guard let note = getNoteFromCell(indexPath: indexPath) else { return }
        NotesProvider.shared.markAsStarred(note) {
            self.fetchNotes()
            self.notesListTableView.reloadData()
        }
    }

    func getNoteFromCell(indexPath: IndexPath) -> Note? {
        guard let cell = notesListTableView.cellForRow(at: indexPath) as? NoteTableViewCell else { return nil }
        guard let note = cell.note else { return nil }
        return note
    }

    func openAddToFolderScene(note: Note) {
        guard let view = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "SelectFolder")
                as? SelectFolderViewController else { return }
        view.completion = { folder in
            if let folder = folder {
                folder.add(note: note)
            }
        }
        self.present(view, animated: true, completion: nil)
    }
}
