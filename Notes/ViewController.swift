//
//  ViewController.swift
//  Lumen
//
//  Created by Mark Gerard G. Gamboa on 11/14/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!

    var models: [Note] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            table.delegate = self
            table.dataSource = self
            title = "Lumen"

            loadNotes()

            if models.isEmpty {
                label.isHidden = false
                table.isHidden = true
            } else {
                label.isHidden = true
                table.isHidden = false
            }
        }

        @IBAction func didTapNewNote() {
            guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
                return
            }
            vc.title = "New Note"
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.completion = { noteTitle, note in
                self.navigationController?.popToRootViewController(animated: true)

                self.models.append(Note(title: noteTitle, note: note))
                self.saveNotes()

                self.label.isHidden = true
                self.table.isHidden = false
                self.table.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        }

        // MARK: TABLE

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return models.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = models[indexPath.row].title
            cell.detailTextLabel?.text = models[indexPath.row].note
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)

            let model = models[indexPath.row]

            guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else {
                return
            }

            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = "Note"
            vc.noteTitle = model.title
            vc.note = model.note

            vc.onUpdate = { updatedTitle, updatedNote in
                self.models[indexPath.row].title = updatedTitle
                self.models[indexPath.row].note = updatedNote
                self.saveNotes()
                self.table.reloadData()
            }

            navigationController?.pushViewController(vc, animated: true)
        }

        // MARK: Delete

        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                models.remove(at: indexPath.row)
                saveNotes()
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }

        // MARK: Persistence

        func saveNotes() {
            let data = try? JSONEncoder().encode(models)
            UserDefaults.standard.set(data, forKey: "notes")
        }

        func loadNotes() {
            guard let data = UserDefaults.standard.data(forKey: "notes"),
                  let saved = try? JSONDecoder().decode([Note].self, from: data) else { return }
            models = saved
        }
    }
