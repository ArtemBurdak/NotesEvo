//
//  CreateNewNoteViewController.swift
//  NotesEvo
//
//  Created by Artem on 5/9/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class CreateNewNoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var NoteTextOutlet: UITextView!

    @IBOutlet weak var SaveBtnOutlet: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        NoteTextOutlet.delegate = self
        NoteTextOutlet.text = "Что вы хотите добавить в заметки?"
        NoteTextOutlet.textColor = UIColor.lightGray

    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if NoteTextOutlet.textColor == UIColor.lightGray {
            NoteTextOutlet.text = nil
            NoteTextOutlet.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if NoteTextOutlet.text.isEmpty {
            NoteTextOutlet.text = "Что вы хотите добавить в заметки?"
            NoteTextOutlet.textColor = UIColor.lightGray
        }
    }

    @IBAction func SaveBtnAction(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        vc.notes.append(NoteTextOutlet.text)
        self.show(vc, sender: self)
    }
}
