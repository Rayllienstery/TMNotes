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
        NotificationCenter.default.post(name: .foldersUpdated, object: nil)
    }

    func deleteFolderAlert(folder: Folder) -> UIAlertController {
        let alert = UIAlertController(title: "Are you sure?",
                                      message: """
Folder \(folder.title ?? "will be removed").
\nNotes that were in this folder will not be deleted.
""",
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "Yes", style: .destructive, handler: { _ in
            self.delete(folder: folder)
        }))
        alert.addAction(.init(title: "No", style: .cancel, handler: nil))

        return alert
    }

    func sync(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func getFolder(noteId: Int64) -> Folder? {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return nil }
        guard let folders = (try? context.fetch(Folder.fetchRequest()) as? [Folder])?.filter({
            if let notes = $0.notes {
                let parsedNotes = (try? JSONSerialization.jsonObject(with: notes, options: [])) as? [Int64]
                return parsedNotes?.contains(noteId) ?? false
            } else {
                return false
            }
        }) else { return nil }

        if folders.count > 0 {
            return folders.first
        } else {
            return nil
        }
    }

    func removeNoteFromFolder(noteId: Int64) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        guard let folders = (try? context.fetch(Folder.fetchRequest()) as? [Folder]) else { return }
        folders.forEach({
            if let notes = $0.notes {
                do {
                    var parsedNotes = (try JSONSerialization.jsonObject(with: notes, options: [])) as? [Int64]
                    parsedNotes?.removeAll(where: {$0 == noteId})
                    let noteIdToData = try JSONSerialization.data(withJSONObject: parsedNotes ?? [], options: [])
                    $0.notes = noteIdToData
                } catch {
                    print(error)
                }
            }
        })
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
