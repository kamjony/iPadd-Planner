//
//  AddToCalendarViewController.swift
//  iPadd Planner
//
//  Created by Md Bin Amin on 15/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit
import EventKit

class AddToCalendarViewController: UIViewController {
    
    
    @IBOutlet weak var reminderText: UILabel!
    @IBOutlet weak var reminderDate: UITextField!
    var dateStart: Date?
    var dateEnd: Date?
    var cwTitle:String?
    var cwDueDate: String?
    let store = EKEventStore()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderText.text = cwTitle
        reminderDate.text = cwDueDate
        dateStart = Date()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dateChanged(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddToCalendarViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    @objc func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        reminderDate.text = dateFormatter.string(from: sender.date)
    
    }
    
    @IBAction func saveToCalendar(_ sender: UIButton) {
        let title = reminderText.text
        let dateString = reminderDate.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd,yyyy" //Your date format
        let date = dateFormatter.date(from: dateString!)
        
        createEventinTheCalendar(with: title!, forDate: (date ?? nil)!, toDate: (date ?? nil)!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelReminder(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func createEventinTheCalendar(with title:String, forDate eventStartDate:Date, toDate eventEndDate:Date)
    
    //http://www.iostutorialjunction.com/2017/09/add-event-to-device-calendar-ios-swift.html
    
    func createEventinTheCalendar(with title:String, forDate eventStartDate:Date, toDate eventEndDate:Date) {
        
        store.requestAccess(to: .event) { (success, error) in
            if  error == nil {
                let event = EKEvent.init(eventStore: self.store)
                event.isAllDay = true
                event.title = title
                event.calendar = self.store.defaultCalendarForNewEvents // this will //return deafult calendar from device calendars
                event.startDate = eventStartDate
                event.endDate = eventEndDate
//
//                let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -3600, since: event.startDate))
//                event.addAlarm(alarm)
                
                do {
                    try self.store.save(event, span: .thisEvent, commit: true)
                    //event created successfullt to default calendar
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                
            } else {
                //we have error in getting access to device calnedar
                print("error = \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
}
