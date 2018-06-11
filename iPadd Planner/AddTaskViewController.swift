//
//  AddTaskViewController.swift
//  iPadd Planner
//
//  Created by Md Kamrul Amin on 11/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var percentageComplete: UILabel!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var cwTitle: UILabel!
    
    var currentCoursework:Coursework?
    
    var dateStart: Date?
    var dateEnd: Date?
    var currentValue: Int = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskName.becomeFirstResponder()
        cwTitle.text = currentCoursework?.courseTitle

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        currentValue = Int(sender.value)
        percentageComplete.text = "\(currentValue)% complete"
        
    }
    
    @IBAction func startDateChange(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddTaskViewController.startDatePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func endDateChange(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddTaskViewController.endDatePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    @objc func startDatePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        startDate.text = dateFormatter.string(from: sender.date)
        dateStart = sender.date
    }
    
    @objc func endDatePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        endDate.text = dateFormatter.string(from: sender.date)
        dateEnd = sender.date
        
    }
    
    
    @IBAction func saveTask(_ sender: UIButton) {
        if currentCoursework != nil{
            
            let task = Task(context: context)
            task.taskName = taskName.text
            task.percentageComplete = Int16(currentValue)
            task.notes = notes.text
            task.startDate = dateStart
            task.endDate = dateEnd
        
        currentCoursework?.addToTaskRelation(task)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
    }
    
    @IBAction func cancelTask(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
