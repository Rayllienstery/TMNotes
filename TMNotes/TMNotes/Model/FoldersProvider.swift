//
//  FoldersProvider.swift
//  TMNotes
//
//  Created by Raylee on 03.04.2021.
//

import UIKit
import CoreData

class FoldersProvider {
    public static let shared = FoldersProvider()
    
    init() {
        initBasicFoldersIfNecessary()
    }
    func getFolders() -> [Folder] {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return [] }
        let folders = try? context.fetch(Folder.fetchRequest()) as? [Folder]
        return folders ?? []
    }

    func initBasicFoldersIfNecessary() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        do {
            guard let folders = try context.fetch(Folder.fetchRequest()) as? [Folder] else { return }
            if (folders.contains(where: { folder -> Bool in
                folder.title == "Trash"
            }) && folders.contains(where: { folder -> Bool in
                folder.title == "Starred"
            })) == false {
                let trashFolder = Folder(context: context)
                trashFolder.title = "Trash"
                trashFolder.imagePath = "trash.fill"

                let starredFolder = Folder(context: context)
                starredFolder.title = "Starred"
                starredFolder.imagePath = "star.fill"

                sync(context)
            }
        } catch {
            print(error)
        }
    }

    func createFolder(title: String, firstNoteId: Int?) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        let folder = Folder(context: context)
        folder.title = title

        do {
            try context.save()
            NotificationCenter.default.post(name: .foldersUpdated, object: nil)
        } catch {
            print(error)
        }
    }

    func createFolderAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Create new folder", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Folder name"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let folderTitle = textField?.text, folderTitle.count > 0 {
                self.createFolder(title: folderTitle, firstNoteId: nil)
            }
        }))

        return alert
    }

    func delete(folder: Folder) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }

        context.delete(folder)
        sync(context)
    }

    func sync(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
