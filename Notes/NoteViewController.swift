//
//  NoteViewController.swift
//  Lumen
//
//  Created by Mark Gerard G. Gamboa on 11/14/25.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var noteLabel: UITextView!

    public var noteTitle: String = ""
    public var note: String = ""
    public var onUpdate: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = noteTitle
        noteLabel.text = note

        titleLabel.isUserInteractionEnabled = true
        noteLabel.isEditable = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let updatedTitle = titleLabel.text ?? ""
        let updatedNote = noteLabel.text ?? ""
        onUpdate?(updatedTitle, updatedNote)
    }
}
