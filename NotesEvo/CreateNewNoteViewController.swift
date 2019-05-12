//
//  CreateNewNoteViewController.swift
//  NotesEvo
//
//  Created by Artem on 5/9/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import CoreData

class CreateNewNoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextOutlet: UITextView!
    @IBOutlet weak var saveBtnOutlet: UIBarButtonItem!

//    private let placeholder = "Что вы хотите добавить в заметки?"
//    private let contextManager = ContextManager.sharedInstance
    private let dataManager = DataManager.sharedInstance
    var callback: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()

//        noteTextOutlet.text = placeholder
//        noteTextOutlet.textColor = UIColor.lightGray
//        navigationItem.title = "Create new note"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noteTextOutlet.becomeFirstResponder()
        checkSaveButtonEnabled()
    }

    private func checkSaveButtonEnabled() {

        let isEnabled = !noteTextOutlet.text.isEmpty && !noteTextOutlet.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
        saveBtnOutlet.isEnabled = isEnabled
    }

    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {

//        contextManager.saveNote(noteTextOutlet.text)
        let newNote = Note(context: Constants.context)
        newNote.text = noteTextOutlet.text
        dataManager.saveNote()
        navigationController?.popViewController(animated: true)
        callback?()
    }

}

extension CreateNewNoteViewController: UITextViewDelegate {

//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if noteTextOutlet.textColor == UIColor.lightGray {
//            noteTextOutlet.text = nil
//            noteTextOutlet.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if noteTextOutlet.text.isEmpty {
//            noteTextOutlet.text = placeholder
//            noteTextOutlet.textColor = UIColor.lightGray
//        }
//    }

    func textViewDidChange(_ textView: UITextView) {
        checkSaveButtonEnabled()
    }
}
