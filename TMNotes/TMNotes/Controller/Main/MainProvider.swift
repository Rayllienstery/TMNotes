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
}
