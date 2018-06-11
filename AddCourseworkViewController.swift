//
//  AddCourseworkViewController.swift
//  iPadd Planner
//
//  Created by Md Kamrul Amin on 09/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit
import CoreData

class AddCourseworkViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textCwTitle: UITextField!
    @IBOutlet weak var textModuleName: UITextField!
    @IBOutlet weak var textLevel: UITextField!
    @IBOutlet weak var textDueDate: UITextField!
    @IBOutlet weak var textWeight: UITextField!
    @IBOutlet weak var lblMarks: UILabel!
    @IBOutlet weak var textNotes: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dateEnd: Date?
    var dateStart: Date?
    var currentValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textCwTitle.becomeFirstResponder()
        
        dateStart = Date()
        textLevel.delegate = self
        textWeight.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dateChanged(_ sender: UITextField) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
//        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddCourseworkViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        textDueDate.text = dateFormatter.string(from: sender.date)
        dateEnd = sender.date
        
        
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        currentValue = Int(sender.value)
        lblMarks.text = "\(currentValue)/100"
    }
    
    
    @IBAction func saveCoursework(_ sender: UIButton) {
        let newCoursework = Coursework(context: context)
        
        if (textCwTitle.text!.isEmpty) || (textDueDate.text!.isEmpty) || (textWeight.text!.isEmpty) || (textModuleName.text!.isEmpty) || (textLevel.text!.isEmpty){
            
            let alert = UIAlertController(title: "Missing Information", message: "Please fill every fields", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
            //Alert
            newCoursework.courseTitle = textCwTitle.text
            newCoursework.moduleName = textModuleName.text
            newCoursework.level = Int16(textLevel.text!) ?? 0
            newCoursework.dueDate = dateEnd
            newCoursework.weight = Int16(textWeight.text!) ?? 0
            newCoursework.actualMark = Int16(currentValue)
            newCoursework.notes = textNotes.text
            
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTask(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //https://stackoverflow.com/questions/30973044/how-to-restrict-uitextfield-to-take-only-numbers-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    

}
