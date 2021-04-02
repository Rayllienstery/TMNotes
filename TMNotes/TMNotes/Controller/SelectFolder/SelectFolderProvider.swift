//
//  SelectFolderProvider.swift
//  TMNotes
//
//  Created by Raylee on 14.03.2021.
//

import Foundation

extension SelectFolderViewController {
    func initProvider() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateFolders), name: .foldersUpdated, object: nil)

        updateFoldersList()
    }

    func updateFoldersList() {
        self.folders = FoldersProvider.shared.getFolders()
        self.foldersTableView.reloadData()
    }
}
