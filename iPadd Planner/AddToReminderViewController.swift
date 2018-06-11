//
//  AddToReminderViewController.swift
//  iPadd Planner
//
//  Created by Md Bin Amin on 17/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

class AddToReminderViewController: UIViewController {
    
    var eventStore = EKEventStore()
    var dateReminder = Date()
   
    @IBOutlet weak var reminderTitle: UITextField!
    @IBOutlet weak var reminderDate: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reminderTitle.becomeFirstResponder()
        
        let calendars =
            eventStore.calendars(for: EKEntityType.reminder)
        
        for calendar in calendars as [EKCalendar] {
            print("Calendar = \(calendar.title)")
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessful")
            } else {
                print("Authorization Successful")
            }
        }

        // Do any additional setup after loading the view.
    }

    
    @IBAction func dateChanged(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddCourseworkViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        reminderDate.text = dateFormatter.string(from: sender.date)
        dateReminder = sender.date
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        if appDelegate.eventStore == nil {
            appDelegate.eventStore = EKEventStore()
            
            appDelegate.eventStore?.requestAccess(
                to: EKEntityType.reminder, completion: {(granted, error) in
                    if !granted {
                        print("Access to store not granted")
                        print(error?.localizedDescription)
                    } else {
                        print("Access granted")
                    }
            })
        }
        if (appDelegate.eventStore != nil) {
            self.createReminder()
        }
        
        // for notification
        let contents = UNMutableNotificationContent()
        contents.title = reminderTitle.text!
        contents.body = "Missed a task"
        contents.sound = UNNotificationSound.default()
        let date = dateReminder
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: contents, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            (error) in
            if error != nil {
                print("Error: \(error)")
            }
        })
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //https://www.techotopia.com/index.php/Using_iOS_8_Event_Kit_and_Swift_to_Create_Date_and_Location_Based_Reminders
    
    func createReminder() {
        
        let reminder = EKReminder(eventStore: appDelegate.eventStore!)
        
        
        reminder.title = reminderTitle.text!
        reminder.calendar =
            appDelegate.eventStore!.defaultCalendarForNewReminders()
        let date = dateReminder
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let time = "\(hour):\(min)"
//        let alarm = EKAlarm(absoluteDate: date)
        let relativeAlarm = EKAlarm(relativeOffset: TimeInterval(time) ?? 0)
        
//        reminder.addAlarm(alarm)
        reminder.addAlarm(relativeAlarm)
        
        do {
            try appDelegate.eventStore?.save(reminder,
                                             commit: true)
        } catch let error {
            print("Reminder failed with error \(error.localizedDescription)")
        }
    }
    
    
}
