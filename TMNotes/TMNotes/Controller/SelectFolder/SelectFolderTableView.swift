//
//  SelectFolderTableView.swift
//  TMNotes
//
//  Created by Raylee on 14.03.2021.
//

import UIKit

extension SelectFolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.folders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "SelectFolderCell") as? SelectFolderTableViewCell else { fatalError() }
        cell.setFolder(folders[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectFolderTableViewCell else { return }
        guard let folder = cell.folder else { return }
        self.selectedFolder = folder.title
        self.completion?(selectedFolder)
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectFolderTableViewCell,
              cell.folder?.title != "Trash",
              cell.folder?.title != "Starred"
              else {
            return nil
        }

        let removeFolderAction = UIContextualAction(style: .normal, title: "Delete") { (_, _, _) in
            guard let folder = cell.folder else { return }
            self.present(FoldersProvider.shared.deleteFolderAlert(folder: folder), animated: true, completion: nil)
        }
        removeFolderAction.backgroundColor = .systemRed
        removeFolderAction.image = UIImage(systemName: "folder.badge.minus")?.withTintColor(.black)

        return .init(actions: [removeFolderAction])
    }
}
