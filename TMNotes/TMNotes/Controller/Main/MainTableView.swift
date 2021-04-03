//
//  MainTableView.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.folder == nil ? 1 : 0
        case 1:
            return self.folder == nil ? 1 : 0
        case 2:
            emptyLabel.isHidden = notes.count > 0
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagsListCell")!
            return cell
        case 2:
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
        guard indexPath.section == 2 else { return nil }

        let pinAction = UIContextualAction(style: .normal, title: "Pin") { (_, _, _) in
            self.pinNote(indexPath: indexPath)
        }
        pinAction.backgroundColor = .systemGreen
        pinAction.image = UIImage(systemName: "pin.fill")?.withTintColor(.black)

        let starAction = UIContextualAction(style: .normal, title: "Star") { _, _, _ in
            self.starNote(indexPath: indexPath)
        }
        starAction.backgroundColor = .systemOrange
        starAction.image = UIImage(systemName: "star.fill")

        if self.folder?.title != "Trash" {
            let deleteAction = UIContextualAction(style: .normal, title: "Trash") { (_, _, _) in
                self.trashNote(indexPath: indexPath)
            }
            deleteAction.backgroundColor = .systemRed
            deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.black)
            return .init(actions: [deleteAction, pinAction, starAction])
        } else {
            let restoreAction = UIContextualAction(style: .normal, title: "Trash") { (_, _, _) in
                self.restoreNote(indexPath: indexPath)
            }
            restoreAction.backgroundColor = .orange
            restoreAction.image = UIImage(systemName: "tray.and.arrow.up")?.withTintColor(.black)
            return .init(actions: [restoreAction])
        }
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard self.folder?.title != "Trash" else { return nil }
        let folderAction = UIContextualAction(style: .normal, title: "Add to folder") { _, _, _ in
            guard let note = self.getNoteFromCell(indexPath: indexPath) else { return }
            self.openAddToFolderScene(note: note)
        }
        folderAction.backgroundColor = .systemBlue
        folderAction.image = UIImage(systemName: "folder.fill.badge.plus")

        return .init(actions: [folderAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 2:
            if let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell, let note = cell.note {
                EditorRouter.call(to: self.navigationController!, note: note, true)
            }
        default:
            return
        }
    }
}
