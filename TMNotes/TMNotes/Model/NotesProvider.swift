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

    func getNotes(folder: Folder?) -> [Note]? {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return nil }
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        switch folder?.title {
        case "Trash":
            request.predicate = NSPredicate(format: "trashed == %d", true)
            return try? context.fetch(request)
        case "Starred":
            request.predicate = NSPredicate(format: "starred == %d", true)
            return try? context.fetch(request)
        default:
            guard let notes = try? context.fetch(request) else { return nil }
            if folder == nil {
                return notes
            } else {
                guard let notesData = folder?.notes else { return nil }
                guard let notesList = (try? JSONSerialization.jsonObject(with: notesData,
                                                                     options: [])) as? [Int64] else { return nil }
                return notes.filter { note -> Bool in
                    notesList.contains(note.id)
                }
            }
        }
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

    func markAsTrashed(_ note: Note, status: Bool, completion: @escaping () -> Void) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        note.trashed = status
        note.starred = false
        note.pinned = false
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

    func markAsStarred(_ note: Note, completion: @escaping () -> Void) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        note.starred = !note.starred
        sync(context)
        completion()
    }
}
