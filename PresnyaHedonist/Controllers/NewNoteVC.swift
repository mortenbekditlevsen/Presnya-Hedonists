//
//  NewNoteVC.swift
//  PresnyaHedonist
//
//  Created by Alexandr L. on 7/13/21.
//

import UIKit
import CoreData

protocol NewNoteDelegate {
    func noteAdded()
}

class NewNoteVC: UIViewController {

    var place: Place?
    
    var delegate: NewNoteDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var close: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        designSettings()
    }
    
    
    func designSettings() {
        noteView.layer.cornerRadius = UISettings.cornerRadius
        noteView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        noteView.layer.shadowOpacity = 1
        noteView.layer.shadowOffset = .zero
        noteView.layer.shadowRadius = 5
        
        textView.font = Fonts.bodyText
        
        save.titleLabel?.font = Fonts.buttons
        close.titleLabel?.font = Fonts.buttons
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func saveButton(_ sender: Any) {
        
        let note = Note(context: context)
        
        note.date = Date()
        note.text = textView.text
        note.place = place
        
        appDelegate.saveContext()
        delegate?.noteAdded()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
