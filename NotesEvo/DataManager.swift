//
//  DataManager.swift
//  NotesEvo
//
//  Created by Artem on 5/12/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import CoreData

class DataManager {
    static var sharedInstance: DataManager {
                return DataManager()
            }

//    func getNotes(with request: NSFetchRequest<Note> = Note.fetchRequest()) -> [Note] {
//                var notes = [Note]()
//
//                do {
//                    notes = try Constants.context.fetch(request)
//                } catch {
//                    print("Loading error \(error.localizedDescription)")
//                }
//
//                return notes
//            }


    func saveNote() {
                do {
                    try Constants.context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
    
}

