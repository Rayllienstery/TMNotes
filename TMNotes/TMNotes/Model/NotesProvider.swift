//
//  NotesProvider.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit
import CoreData

enum NotesProviderValues: String {
    case latestNoteId = "LatestNoteId"
}

class NotesProvider {
    public static let shared = NotesProvider()

    func getNotes(folder: String?) -> [Note]? {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return nil }
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        switch folder {
        case "Trash":
            request.predicate = NSPredicate(format: "trashed == %d", true)
        default:
            request.predicate = NSPredicate(format: "trashed == %d", false)
        }
            
        return try? context.fetch(request)
    }

    func getFolders() -> [NotesFolder] {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return [] }

        //Trash folder
        let trash = NotesFolder()
        trash.title = "Trash"
        trash.imagePath = "trash.fill"

        let trashRequest: NSFetchRequest<Note> = Note.fetchRequest()
        trashRequest.predicate = NSPredicate(format: "trashed == %d", true)
        trash.notesCount = (try? context.fetch(trashRequest).count) ?? 0

        //StarredFolder
        let starred = NotesFolder()
        starred.title = "Starred"
        starred.imagePath = "star.fill"

        let starredRequest: NSFetchRequest<Note> = Note.fetchRequest()
        starredRequest.predicate = NSPredicate(format: "starred = %d", true)
        starred.notesCount = (try? context.fetch(starredRequest).count) ?? 0

        return [trash, starred]
    }

    func addNote(title: String, content: String? = "") {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        let note = Note(context: context)
        note.title = title
        note.content = content
        note.trashed = false
        note.starred = false
        note.pinned = false
        note.id = Int64(updateLatestIdWithGet())
        self.sync(context)
    }

    func deleteNote(_ note: Note?, _ noteId: Int64?) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        if let note = note {
            context.delete(note)
            self.sync(context)
            return
        } else if let noteId = noteId,
                  let notes = getNotes(folder: nil),
                  let note = notes.first(where: { $0.id == noteId }) {
            context.delete(note)
            self.sync(context)
            return
        }
    }

    func updateLatestIdWithGet() -> Int {
        var noteId = UserDefaults.standard.integer(forKey: NotesProviderValues.latestNoteId.rawValue)
        noteId += 1
        UserDefaults.standard.setValue(noteId, forKey: NotesProviderValues.latestNoteId.rawValue)
        return noteId
    }

    func sync(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func markAsTrashed(_ note: Note, completion: @escaping () -> Void) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        note.trashed = true
        sync(context)
        completion()
    }

    func markAsPinned(_ note: Note, completion: @escaping () -> Void) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        note.pinned = !note.pinned
        sync(context)
        completion()
    }
    
}
