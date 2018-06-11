//
//  TopCourseworkViewController.swift
//  iPadd Planner
//
//  Created by Md Kamrul Amin on 09/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit
import CoreData
import MBCircularProgressBar

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}
class TopCourseworkViewController: UIViewController {
    
    @IBOutlet weak var lblModuleTitle: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblMark: UILabel!
    @IBOutlet weak var lblNotes: UITextView!
    @IBOutlet weak var lblComplete: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var customProgBar: CustomProgressView!
    
    @IBOutlet weak var circularProgress: MBCircularProgressBarView!
    
    
    
    var moduleName: String?
    var level: String?
    var weight: String?
    var mark: String?
    var notes: String?
    var complete: Int?
    var cwTitle: String?
    var cwDueDate: String?
    var progress: Int?
    var current: Coursework?
    var endDate: Date?
//    var customProgVar: Float?
    var progressCounter:Float = 0
    
    //for custom progress bar
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addToCalendar"{
            if let calendarVC = segue.destination as? AddToCalendarViewController{
                calendarVC.cwTitle = cwTitle
                calendarVC.cwDueDate = cwDueDate
                
            }
        }
        if segue.identifier == "editCourse"{
            if let editCourseVC = segue.destination as? EditCourseworkViewController{
                editCourseVC.courseName = cwTitle
                editCourseVC.cwModule = moduleName
                editCourseVC.cwLevel = level
                editCourseVC.cwDueDate = cwDueDate
                editCourseVC.cwWeight = weight
                editCourseVC.cwNotes = notes
                editCourseVC.mark = mark
                editCourseVC.cw = current
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblModuleTitle.text = moduleName
        if level != nil && weight != nil && mark != nil{
        lblLevel.text = "Level: \(level!)"
        lblWeight.text = "Weight: \(weight!)%"
        lblMark.text = "Mark: \(mark!)/100"
        }
        lblNotes.text = notes
        lblComplete.text = "\(complete ?? 0)% complete"
        if progress != nil {
            customProgBar.progress = CGFloat(progress!) / 100
        }

        if endDate != nil{
        let yesterday = Date(timeInterval: -86400, since: Date())
        let tomorrow = Date(timeInterval: 86400, since: endDate!)
        
        let diff = tomorrow.interval(ofComponent: .day, fromDate: yesterday)
        self.circularProgress.value = CGFloat(diff)

        }
        

        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 10.0){
//            self.circularProgress.value = 80
            self.circularProgress.maxValue = 100//value to be displayed in center
        }
    }
        
    
}


