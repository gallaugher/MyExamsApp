//
//  ViewController.swift
//  MyExamsApp
//
//  Created by John Gallaugher on 5/8/17.
//  Copyright © 2017 Gallaugher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var exams = [Exam]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        loadFromUserDefaults()
    }
    
    func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        
        let courses = defaults.stringArray(forKey: "courses")
        let dates = defaults.stringArray(forKey: "dates")
        let times = defaults.stringArray(forKey: "times")
        let locations = defaults.stringArray(forKey: "locations")
        let notes = defaults.stringArray(forKey: "notes")
        
        if let courses = courses, let dates = dates, let times = times, let locations = locations, let notes = notes {
            exams = []
            for index in 0..<courses.count {
                exams.append(Exam(course: courses[index], date: dates[index], time: times[index], location: locations[index], notes: notes[index]))
            }
        }
    }
    
    func saveToUserDefaults() {
        var courses = [String]()
        var dates = [String]()
        var times = [String]()
        var locations = [String]()
        var notes = [String]()
        
        for exam in exams {
            courses.append(exam.course)
            dates.append(exam.date)
            times.append(exam.time)
            locations.append(exam.location)
            notes.append(exam.notes)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(courses, forKey: "courses")
        defaults.set(dates, forKey: "dates")
        defaults.set(times, forKey: "times")
        defaults.set(locations, forKey: "locations")
        defaults.set(notes, forKey: "notes")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEdit" {
            let destination = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            destination.exam = exams[indexPath.row]
        } else {
            if let selectedRow = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedRow, animated: true)
            }
        }
    }
    
    @IBAction func unwindoFromDetail(sender: UIStoryboardSegue) {
        if let source = sender.source as? DetailViewController, let newExam = source.exam {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Edit the indexPathForSelectedRow
                let index = selectedIndexPath.row
                exams[index] = newExam
                tableView.reloadData()
            } else {
                // This happens when we add a new record
                exams.append(newExam)
                let newIndexPath = IndexPath(item: exams.count-1, section: 0)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            saveToUserDefaults()
        } else {
            print("Error: Couldn't identify that we are coming from DetailViewController")
        }
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exams.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = exams[indexPath.row].course
        cell?.detailTextLabel?.text = exams[indexPath.row].date
        return cell!
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = exams[sourceIndexPath.row]
        exams.remove(at: sourceIndexPath.row)
        exams.insert(itemToMove, at: destinationIndexPath.row)
        saveToUserDefaults()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            exams.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveToUserDefaults()
        }
    }
}

