//
//  EditTaskViewController.swift
//  iPadd Planner
//
//  Created by Md Bin Amin on 18/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController {
    @IBOutlet weak var taskText: UITextField!
    @IBOutlet weak var taskStartDate: UITextField!
    @IBOutlet weak var taskEndDate: UITextField!
    @IBOutlet weak var taskComplete: UILabel!
    @IBOutlet weak var taskNotes: UITextView!
    
    var name: String?
    var dateStart: String?
    var dateEnd: String?
    var notes: String?
    var complete: Int16?
    var currentValue: Int = 0
    var task = [NSManagedObject]()
    
    var currTask: Task?
    var startDate: Date?
    var endDate: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskText.text = name
        taskStartDate.text = dateStart
        taskEndDate.text = dateEnd
        taskNotes.text = notes
        taskComplete.text = "\(complete ?? 0)% Complete"
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func startDateChanged(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddTaskViewController.startDatePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func endDateChanged(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddTaskViewController.endDatePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func startDatePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        taskStartDate.text = dateFormatter.string(from: sender.date)
        startDate = sender.date
    }
    
    @objc func endDatePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        taskEndDate.text = dateFormatter.string(from: sender.date)
        endDate = sender.date
        
    }
    @IBAction func sliderChanged(_ sender: UISlider) {
        currentValue = Int(sender.value)
        taskComplete.text = "\(currentValue)% complete"
    }
    @IBAction func updateTask(_ sender: UIButton) {
        
        let title = taskText.text
        let textDateStart = taskStartDate.text
        let textDateEnd = taskEndDate.text
        let textNotes = taskNotes.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd,yyyy" //Your date format
        let dateOne = dateFormatter.date(from: textDateStart!)
        let dateTwo = dateFormatter.date(from: textDateEnd!)
        let object = self.currTask

        object?.setValue(title, forKey: "taskName")
        if startDate != nil{
            object?.setValue(startDate, forKey: "startDate")
        }else{
            object?.setValue(dateOne, forKey: "startDate")
        }
        if endDate != nil{
            object?.setValue(endDate, forKey: "endDate")
        }else{
            object?.setValue(dateTwo, forKey: "endDate")
        }
        object?.setValue(Int16(currentValue), forKey: "percentageComplete")
        object?.setValue(textNotes, forKey: "notes")
    
    
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
