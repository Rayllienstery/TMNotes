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

enum NotesSortType: String, CaseIterable {
    case title = "Title"
    case titleReversed = "Title reversed"
    case changeDate = "Change date"
    case changeDateReversed = "Change date reversed"
}

class NotesProvider {
    public static let shared = NotesProvider()
    private let sorterKey = "Default_Sorter"
    private var sorter: NotesSortType = .changeDate

    // MARK: - Init
    init() {
        if UserDefaults.standard.object(forKey: sorterKey) == nil {
            print("Empty")
            UserDefaults.standard.setValue(NotesSortType.changeDate.rawValue, forKey: sorterKey)
            UserDefaults.standard.synchronize()
        } else {
            self.sorter = NotesSortType(rawValue: UserDefaults.standard.value(forKey: sorterKey)
                                            as? String ?? NotesSortType.changeDate.rawValue) ?? .changeDate
        }
    }

    // MARK: - Get
    func getNotes(folder: Folder?) -> [Note]? {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return nil }
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        switch folder?.title {
        case "Trash":
            request.predicate = NSPredicate(format: "trashed == %d", true)
            do {
                let notes = try context.fetch(request)
                return sortNotes(notes: notes)
            } catch {
                return nil
            }
        case "Starred":
            request.predicate = NSPredicate(format: "starred == %d", true)
            do {
                let notes = try context.fetch(request)
                return sortNotes(notes: notes)
            } catch {
                return nil
            }
        default:
            guard let notes = try? context.fetch(request) else { return nil }
            if folder == nil {
                return sortNotes(notes: notes.filter({$0.trashed == false}))
            } else {
                guard let notesData = folder?.notes else { return nil }
                guard let notesList = (try? JSONSerialization.jsonObject(with: notesData,
                                                                     options: [])) as? [Int64] else { return nil }
                return sortNotes(notes: notes.filter({
                                                        notesList.contains($0.id)
                                                            && $0.trashed == false}))
            }
        }
    }

    func sortNotes(notes: [Note]) -> [Note] {
        switch sorter {
        case .changeDate:
            return notes.sorted(by: {$0.editedTimestamp > $1.editedTimestamp})
        case .changeDateReversed:
            return notes.sorted(by: {$0.editedTimestamp < $1.editedTimestamp})
        case .title:
            return notes.sorted(by: {($0.title ?? "") < ($1.title ?? "")})
        case .titleReversed:
            return notes.sorted(by: {($0.title ?? "") > ($1.title ?? "")})
        }
    }

    // MARK: - Set
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
        note.editedTimestamp = Date().timeIntervalSince1970
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

    func sync(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func setDefaultSorter(sorter: NotesSortType) {
        self.sorter = sorter
        UserDefaults.standard.setValue(sorter.rawValue, forKey: sorterKey)
        UserDefaults.standard.synchronize()
    }
}
