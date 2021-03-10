//
//  MainTableView.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "NoteCell") as? NoteTableViewCell
        else { fatalError("Missing NoteTableViewCell") }
        cell.setNote(notes[indexPath.row])

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .normal, title: "Trash") { (_, _, _) in
            self.trashNote(indexPath: indexPath)
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.black)

        return .init(actions: [deleteAction])
    }
}
