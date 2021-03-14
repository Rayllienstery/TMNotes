//
//  MainTableView.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.folder == nil ? 1 : 0
        case 1:
            return self.notes.count
        default:
            return 0
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "FoldersCell") as? FoldersTableViewCell
            else { fatalError("Missing FoldersTableViewCell") }
            cell.setFolders(self.folders)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "NoteCell") as? NoteTableViewCell
            else { fatalError("Missing NoteTableViewCell") }
            cell.setNote(notes[indexPath.row])

            return cell

        default:
            return UITableViewCell()
        }
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 else { return nil }

        let pinAction = UIContextualAction(style: .normal, title: "Pin") { (_, _, _) in
            self.pinNote(indexPath: indexPath)
        }
        pinAction.backgroundColor = .systemGreen
        pinAction.image = UIImage(systemName: "pin.fill")?.withTintColor(.black)

        if self.folder != "Trash" {
            let deleteAction = UIContextualAction(style: .normal, title: "Trash") { (_, _, _) in
                self.trashNote(indexPath: indexPath)
            }
            deleteAction.backgroundColor = .systemRed
            deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.black)
            return .init(actions: [deleteAction, pinAction])
        } else {
            let restoreAction = UIContextualAction(style: .normal, title: "Trash") { (_, _, _) in
                self.restoreNote(indexPath: indexPath)
            }
            restoreAction.backgroundColor = .orange
            restoreAction.image = UIImage(systemName: "tray.and.arrow.up")?.withTintColor(.black)
            return .init(actions: [restoreAction])
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            if let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell, let note = cell.note {
                EditorRouter.call(to: self.navigationController!, note: note, true)
            }
        default:
            return
        }
    }
}
