//
//  NoteDetailsViewController.swift
//  NotesEvo
//
//  Created by Artem on 5/9/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class NoteDetailsViewController: UIViewController {

    @IBOutlet weak var noteDetailOutlet: UITextView!

    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!

    private let dataManager = DataManager.sharedInstance

    var callback: (()->())?

    var note: Note!

    override func viewDidLoad() {
        super.viewDidLoad()

        noteDetailOutlet.becomeFirstResponder()
        noteDetailOutlet.text = note.text
        checkDoneButtonIsEnabled()
    }

    @IBAction func doneButtonAction(_ sender: Any) {
        note.text = noteDetailOutlet.text
        dataManager.saveNotes()
        navigationController?.popViewController(animated: true)
        callback?()
    }

    func checkDoneButtonIsEnabled() {
        if noteDetailOutlet.text != note.text &&
            !noteDetailOutlet.text.isEmpty &&
            !noteDetailOutlet.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {

            doneButtonOutlet.isEnabled = true
        } else {
            doneButtonOutlet.isEnabled = false
        }
    }

    @IBAction func shareButtonAction(_ sender: UIBarButtonItem) {
        guard let sharedNote = noteDetailOutlet.text else { return }
        present(UIActivityViewController(activityItems: [sharedNote], applicationActivities: nil),
                animated: true,
                completion: nil)
    }
}

extension NoteDetailsViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        checkDoneButtonIsEnabled()
    }
}
