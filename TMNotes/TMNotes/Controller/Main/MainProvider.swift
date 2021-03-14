//
//  MainProvider.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import Foundation

extension MainViewController {
    func fetchNotes() {
        self.notes = NotesProvider.shared.getNotes() ?? []
        self.notes.sort(by: {$0.pinned && !$1.pinned})
        self.folders = NotesProvider.shared.getFolders()
    }

    func viewWillAppearCompletion() {
        DispatchQueue.main.async {
            self.fetchNotes()
            self.notesListTableView.reloadData()
        }
    }

    func trashNote(indexPath: IndexPath) {
        guard let note = getNoteFromCell(indexPath: indexPath) else { return }
        NotesProvider.shared.markAsTrashed(note) {
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

    func getNoteFromCell(indexPath: IndexPath) -> Note? {
        guard let cell = notesListTableView.cellForRow(at: indexPath) as? NoteTableViewCell else { return nil }
        guard let note = cell.note else { return nil }
        return note
    }
}
