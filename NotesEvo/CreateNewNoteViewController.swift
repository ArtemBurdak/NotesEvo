//
//  CreateNewNoteViewController.swift
//  NotesEvo
//
//  Created by Artem on 5/9/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class CreateNewNoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextOutlet: UITextView!
    @IBOutlet weak var saveBtnOutlet: UIBarButtonItem!

    private let dataManager = DataManager.sharedInstance
    
    var callback: (()->())?

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

        let newNote = Note(context: Constants.context)
        newNote.text = noteTextOutlet.text
        dataManager.saveNotes()
        navigationController?.popViewController(animated: true)
        callback?()
    }

}

extension CreateNewNoteViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        checkSaveButtonEnabled()
    }
}
