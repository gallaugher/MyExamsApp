//
//  DetailViewController.swift
//  MyExamsApp
//
//  Created by John Gallaugher on 5/8/17.
//  Copyright © 2017 Gallaugher. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    var exam: Exam!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if exam == nil {
            exam = Exam()
        } else {
            // update our user interface
            updateUserInterface()
        }
    }
    
    func updateUserInterface() {
        courseNameTextField.text! = exam.course
        dateTextField.text! = exam.date
        timeTextField.text! = exam.time
        locationTextField.text! = exam.location
        notesTextView.text = exam.notes
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        exam.course = courseNameTextField.text!
        exam.date = dateTextField.text!
        exam.time = timeTextField.text!
        exam.location = locationTextField.text!
        exam.notes = notesTextView.text
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil) // from Present Modally segue
        } else {
            navigationController!.popViewController(animated: true) // from Show segue
        }
        
    }

}
