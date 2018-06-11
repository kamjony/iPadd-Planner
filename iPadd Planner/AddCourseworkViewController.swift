//
//  AddCourseworkViewController.swift
//  iPadd Planner
//
//  Created by Md Kamrul Amin on 09/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit

class AddCourseworkViewController: UIViewController {

    @IBOutlet weak var textCWName: UITextField!
    @IBOutlet weak var textModuleName: UITextField!
    @IBOutlet weak var textLevel: UITextField!
    @IBOutlet weak var textDueDate: UITextField!
    @IBOutlet weak var textWeight: UITextField!
    @IBOutlet weak var lblMarks: UILabel!
    @IBOutlet weak var textNotes: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textCWName.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sliderMarksChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        lblMarks.text = "\(currentValue)"
    }
    @IBAction func saveCoursework(_ sender: UIButton) {
        let newCoursework = Coursework(context: context)
        let levelInt: Int16? = Int16(textLevel.text!)
        
        if textCWName.text != "" {
            newCoursework.courseworkName = textCWName.text
            newCoursework.moduleName = textModuleName.text
            newCoursework.level = levelInt!
            newCoursework.dueDate = textDueDate.text
            newCoursework.weight = Double(textWeight.text!)!
            newCoursework.actualmark = Double(lblMarks.text!)!
            newCoursework.notes = textNotes.text
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }else{
            //Alert
            let alert = UIAlertController(title: "Missing Information", message: "Please fill every fields", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}
