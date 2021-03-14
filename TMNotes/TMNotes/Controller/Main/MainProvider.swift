//
//  MainProvider.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import Foundation

extension MainViewController {
    func fetchNotes() {
        self.notes = NotesProvider.shared.getNotes(folder: folder) ?? []
        self.notes.sort(by: {$0.pinned && !$1.pinned})
        self.folders = NotesProvider.shared.getFolders()
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
            self.fetchNotes()
            self.notesListTableView.reloadData()
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
}
