//
//  EditCourseworkViewController.swift
//  iPadd Planner
//
//  Created by Md Bin Amin on 18/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit
import CoreData

class EditCourseworkViewController: UIViewController {
    
    @IBOutlet weak var cwTitle: UITextField!
    @IBOutlet weak var moduleName: UITextField!
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var dueDate: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var marks: UILabel!
    @IBOutlet weak var notes: UITextView!
    
    
    var courseName: String?
    var cwModule: String?
    var cwLevel: String?
    var cwDueDate: String?
    var cwWeight: String?
    var cwNotes: String?
    var mark: String?
    
    var endDate: Date?
    var currentValue: Int = 0
    
    
    var course = [NSManagedObject]()
    
    var cw: Coursework? {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cwTitle.text = courseName
        moduleName.text = cwModule
        level.text = cwLevel
        dueDate.text = cwDueDate
        weight.text = cwWeight
        marks.text = mark
        notes.text = cwNotes

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func dateChanged(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        //        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(EditCourseworkViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    @objc func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dueDate.text = dateFormatter.string(from: sender.date)
        endDate = sender.date
        
    }
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        currentValue = Int(sender.value)
        marks.text = "\(currentValue)/100"
    }
    
    @IBAction func updateCourse(_ sender: UIButton) {
        let currentCw = self.cw
        let title = cwTitle.text
        let mName = moduleName.text
        let courseLevel = level.text
        let date = dueDate.text
        let courseWeight = weight.text
        let courseMarks = currentValue
        let courseNotes = notes.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd,yyyy" //Your date format
        let dateOne = dateFormatter.date(from: date!)
        
            
            let object = currentCw
            
                object?.setValue(title, forKey: "courseTitle")
                object?.setValue(mName, forKey: "moduleName")
                object?.setValue(Int16(courseLevel!) ?? 0, forKey: "level")
                if endDate != nil {
                    object?.setValue(endDate, forKey: "dueDate")
                }else{
                    object?.setValue(dateOne, forKey: "dueDate")
                }
                object?.setValue(Int16(courseWeight!) ?? 0, forKey: "weight")
                object?.setValue(Int16(courseMarks), forKey: "actualMark")
                object?.setValue(courseNotes, forKey: "notes")
                

                (UIApplication.shared.delegate as! AppDelegate).saveContext()

        
        self.dismiss(animated: true, completion: nil)
    
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
