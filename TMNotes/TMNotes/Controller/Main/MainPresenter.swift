//
//  MainPresenter.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import Foundation

extension MainViewController {
    func initUI() {
        self.title = folder?.title ?? "Notes"
    }

    @objc func updateUI() {
        DispatchQueue.main.async {
            self.fetchNotes()
            self.notesListTableView.reloadData()
        }
    }
}
