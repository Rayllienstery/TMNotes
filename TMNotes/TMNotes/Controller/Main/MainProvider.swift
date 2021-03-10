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
    }

    func viewDidAppearCompletion() {
        self.fetchNotes()
        self.notesListTableView.reloadData()
    }

    func trashNote(indexPath: IndexPath) {
        guard let cell = notesListTableView.cellForRow(at: indexPath) as? NoteTableViewCell else { return }
        guard let note = cell.note else { return }
        NotesProvider.shared.markAsTrashed(note) {
            self.fetchNotes()
            self.notesListTableView.reloadData()
        }
    }
}
