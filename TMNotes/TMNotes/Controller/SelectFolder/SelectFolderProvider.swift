//
//  SelectFolderProvider.swift
//  TMNotes
//
//  Created by Raylee on 14.03.2021.
//

import Foundation

extension SelectFolderViewController {
    func updateFoldersList() {
        self.folders = NotesProvider.shared.getFolders()
        self.foldersTableView.reloadData()
    }
}
