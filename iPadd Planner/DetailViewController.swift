//
//  DetailViewController.swift
//  iPadd Planner
//
//  Created by Md Kamrul Amin on 09/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit
import CoreData


class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchRequest: NSFetchRequest<Task>!
    var task: [Task]!
    
    var tasksComplete = NSSet()

//    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseworkTopView"{
            if let topVC = segue.destination as? TopCourseworkViewController{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeStyle = DateFormatter.Style.none
                
                if courseWork != nil{
                    
                topVC.cwTitle = courseWork?.courseTitle
                topVC.cwDueDate = dateFormatter.string(from: (courseWork?.dueDate)!)
                topVC.moduleName = courseWork?.moduleName
                topVC.mark = "\(courseWork?.actualMark ?? 0)"
                topVC.level = "\(courseWork?.level ?? 0)"
                topVC.weight = "\(courseWork?.weight ?? 0)"
                topVC.notes = courseWork?.notes
                topVC.current = self.courseWork
                topVC.endDate = courseWork?.dueDate
//                    topVC.progressCounter = 0.5
                
                //for tasks percentage completed
                let numberOfTasks = courseWork?.taskRelation?.count
                tasksComplete = courseWork?.taskRelation?.value(forKey: "percentageComplete") as! NSSet
                let arr = tasksComplete.allObjects
                let array = arr as NSArray

                var total:Int = 0;
                for task in (array as? [Int])! {
                    total = total + task
                }
                    
                    if numberOfTasks != 0 {
                let percentageCourse = total / numberOfTasks!
                topVC.complete = percentageCourse
                topVC.progress = percentageCourse
                    
                    }
                
                        
                    
                }
                
            }
        }
        if segue.identifier == "addTask"{
            if let addTaskVC = segue.destination as? AddTaskViewController{
                addTaskVC.currentCoursework = courseWork
            }
        }
            if let indexPath = tableView.indexPathForSelectedRow {
                let object:Task? = fetchedResultsController.object(at: indexPath)
                let controller = segue.destination as? EditTaskViewController
                controller?.currTask = object
                controller?.name = object?.taskName
                controller?.complete = object?.percentageComplete
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeStyle = DateFormatter.Style.none
                let dateOne = object?.startDate
                let dateTwo = object?.endDate
                controller?.dateStart = dateFormatter.string(from: dateOne!)
                controller?.dateEnd = dateFormatter.string(from: dateTwo!)
            }
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //CoreData


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var courseWork: Coursework? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    var ct: Task? {
        didSet{

        }
    }
    
    // Table View delegate functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if courseWork == nil{
           return 0
        }
        else{
            return self.fetchedResultsController.sections?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! CustomTaskTableViewCell
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: CustomTaskTableViewCell, indexPath: IndexPath){
        let title = self.fetchedResultsController.fetchedObjects?[indexPath.row].taskName
        cell.lblTaskTitle.text = title
        if let noteText = self._fetchedResultsController?.fetchedObjects?[indexPath.row].notes{
            cell.lblNotes?.text = noteText
        }else{
            cell.lblNotes!.text = ""
        }
        
        let completePercentage = self.fetchedResultsController.fetchedObjects?[indexPath.row].percentageComplete
        cell.lblPerComplete.text = "\(completePercentage!)% complete"
        cell.customProgbar.progress = CGFloat(completePercentage!) / 100.0
//        cell.progressView.progress = Float(completePercentage!) / 100.0
        
        let endDate = self.fetchedResultsController.fetchedObjects?[indexPath.row].endDate
//        let startDate = self.fetchedResultsController.fetchedObjects?[indexPath.row].startDate
        
        let days = daysAndHoursLeft(date1: Date(), date2: endDate!)
        if days == "0 hours" && completePercentage != 100 {
            cell.lblDaysRemaining.text = "Task Expired"
        }else if days == "0 hours" && completePercentage == 100{
            cell.lblDaysRemaining.text = "Task Completed"
        }else {
            cell.lblDaysRemaining.text = days
        }
        

        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editTask", sender: nil)
    }
    
    // for due date calcualtion
    func daysAndHoursLeft(date1:Date, date2:Date) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour]
        formatter.unitsStyle = .full
        let numberOfWeakAndDays = formatter.string(from: date1, to: date2)!
        return numberOfWeakAndDays
    }

    //Fetch results
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Task> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let currentCw = self.courseWork
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "taskName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        //all tasks for the related coursework
        if(self.courseWork != nil){
            let predicate = NSPredicate(format: "courseRelation = %@", currentCw!)
            fetchRequest.predicate = predicate
        }
//        else{
//            let predicate = NSPredicate(format: "taskRelation = %@","asdasd")
//            fetchRequest.predicate = predicate
//        }
        
        let frc = NSFetchedResultsController<Task>(fetchRequest: fetchRequest,
                                                 managedObjectContext: managedObjectContext,
                                                 sectionNameKeyPath: #keyPath(Task.coursework), cacheName: nil)
        frc.delegate = self
        _fetchedResultsController = frc
        
        do{
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return frc as! NSFetchedResultsController<NSFetchRequestResult> as! NSFetchedResultsController<Task>
    }
    
    //fetch results table view functions
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    //must have a NSFetchedResultsController to work
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType(rawValue: 0)!:
            // iOS 8 bug - Do nothing if we get an invalid change type.
            break
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)! as! CustomTaskTableViewCell, indexPath: newIndexPath!)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            //    default: break
            
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
        // self.tableView.reloadData()
    }
    
    

}

