//
//  SelectInfoTableViewController.swift
//  someThing
//
//  Created by Расул Караев on 6/30/20.
//  Copyright © 2020 Расул Караев. All rights reserved.
//

import UIKit

class SelectInfoTableViewController: UITableViewController {
    let scheduleModel = AddScheduleModel(),
        tableLabels = ["Факультет", "Курс", "Учебный год", "Группа"]
        
    var facultyData = [Int: [String: Any]](),
        courseData = [Int: [String: Any]](),
        studyYearData = [Int: [String: Any]](),
        groupData = [Int: [String: Any]](),
        selectedResult = [String: Int](),
        selectedLabels = [String: String](),
        id: Int = 0,
        mainCollection: SettingsCollectionViewController?
    
    override func viewDidLoad() {
        title = self.tableLabels[id]
        if self.id != 3 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Далее", style: .plain, target: self, action: #selector(nextStepButtonPushed(sender:)))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addStudentInfo(sender:)))
        }
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.systemGroupedBackground
        if facultyData.count == 0 { initState() }
        if selectedResult["studyYear"] != nil {
            scheduleModel.getGroupData(selectedData: selectedResult)
            self.groupData = scheduleModel.groupData
        }
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.8979069591, blue: 0.7852694988, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func addStudentInfo(sender: UIBarButtonItem) {
        let settingsModel = SettingsModel(),
            scheduleModel = ScheduleModel()
        
        settingsModel.saveStudentInfo(studentInfo: selectedResult, studentInfoLabels: selectedLabels)
        scheduleModel.studentInfo = UserDefaults.standard.object(forKey: "studentInfoValues") as? [String: Int]
        guard let collection = mainCollection else { return }
        collection.loadData()
        navigationController?.dismiss(animated: true, completion: nil)
        mainCollection = nil
    }
    
    @objc func nextStepButtonPushed(sender: UIBarButtonItem) {
        guard let collection = mainCollection else { return }
        let nextVC = SelectInfoTableViewController(collection: collection)
        
        nextVC.selectedResult = self.selectedResult
        nextVC.selectedLabels = self.selectedLabels
        nextVC.facultyData = self.facultyData
        nextVC.courseData = self.courseData
        nextVC.studyYearData = self.studyYearData
        nextVC.id = self.view.tag + 1
        nextVC.view.tag = self.view.tag + 1
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func initState() {
        scheduleModel.getMainData()
        self.facultyData = scheduleModel.facultyData
        self.courseData = scheduleModel.courseData
        self.studyYearData = scheduleModel.studyYearData
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
  
        switch tableView.tag {
        case 0:
            return self.facultyData.count
        case 1:
            return self.courseData.count
        case 2:
            return self.studyYearData.count
        case 3:
            return self.groupData.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch tableView.tag {
        case 0:
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "facultyCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "facultyCell", for: indexPath)
            cell.textLabel!.text = self.facultyData[indexPath.row]!["name"] as? String
            cell.tag = self.facultyData[indexPath.row]!["value"] as! Int
            return cell
        case 1:
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "courseCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
            cell.textLabel!.text = self.courseData[indexPath.row]!["name"] as? String
            cell.tag = self.courseData[indexPath.row]!["value"] as! Int
            return cell
        case 2:
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "studyYearCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "studyYearCell", for: indexPath)
            cell.textLabel!.text = self.studyYearData[indexPath.row]!["name"] as? String
            cell.tag = self.studyYearData[indexPath.row]!["value"] as! Int
            return cell
        case 3:
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
            cell.textLabel!.text = self.groupData[indexPath.row]!["name"] as? String
            cell.tag = self.groupData[indexPath.row]!["value"] as! Int
            return cell
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath),
            cellValue = cell!.tag,
            cellLabel = cell?.textLabel?.text
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        switch tableView.tag {
        case 0:
            self.selectedLabels["faculty"] = cellLabel
            self.selectedResult["faculty"] = cellValue
        case 1:
            self.selectedLabels["course"] = cellLabel
            self.selectedResult["course"] = cellValue
        case 2:
            self.selectedLabels["studyYear"] = cellLabel
            self.selectedResult["studyYear"] = cellValue
        case 3:
            self.selectedLabels["group"] = cellLabel
            self.selectedResult["group"] = cellValue
        default:
            break
        }
    }
    
    init(collection: SettingsCollectionViewController) {
        super.init(nibName: nil, bundle: nil)
        mainCollection = collection
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
