////
////  ContextManager.swift
////  NotesEvo
////
////  Created by Artem on 5/12/19.
////  Copyright © 2019 Artem. All rights reserved.
////
//
//import CoreData
//
//class ContextManager {
//
//    static var sharedInstance: ContextManager {
//        return ContextManager()
//    }
//
//    func getNotes(with request: NSFetchRequest<Note> = Note.fetchRequest()) -> [Note] {
//
//        var notes = [Note]()
//
//        do {
//            notes = try Constants.context.fetch(request)
//        } catch {
//            print("Loading error \(error.localizedDescription)")
//        }
//
//        return notes
//    }
//
//    func saveNote(_ text: String) {
//        let newNote = Note(context: Constants.context)
//        newNote.text = text
//
//        do {
//            try Constants.context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
////    func deleteNote(_ note: Note) {
////
////        do {
////
////        } catch {
////            print(error.localizedDescription)
////        }
////
////    }
//
//    func updateNote(_ note: Note) {
//
//    }
//}
