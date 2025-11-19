//
//  Note.swift
//  Notes
//
//  Created by Mark Gerard G. Gamboa on 11/14/25.
//

import Foundation

class Note: NSObject, Codable {
    var title: String
    var note: String

    init(title: String, note: String) {
        self.title = title
        self.note = note
    }
}
