//
//  SettingsCollectionViewController.swift
//  someThing
//
//  Created by Расул Караев on 6/30/20.
//  Copyright © 2020 Расул Караев. All rights reserved.
//

import UIKit

class SettingsCollectionViewController: UICollectionViewController {

    var studentInfo: [String: Int]?,
        studentInfoLabels: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentInfo = UserDefaults.standard.object(forKey: "studentInfoValues") as? [String: Int]
        studentInfoLabels = UserDefaults.standard.object(forKey: "studentInfoLabels") as? [String: String]
        
        self.collectionView.backgroundColor = .white
        title = "Настройки"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStudentInfo(sender: )))
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.8979069591, blue: 0.7852694988, alpha: 1)
    }
    
    @objc func addStudentInfo(sender: UIBarButtonItem) {
        let navController = UINavigationController(rootViewController: SelectInfoTableViewController(collection: self))
        navController.view.backgroundColor = .white
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsCell", for: indexPath) as! SettingsCollectionViewCell
        if studentInfoLabels != nil {
            cell.settingsFacultyLabel.text = String("\(studentInfoLabels!["faculty"]!)")
            cell.settingsGroupLabel.text = String("\(studentInfoLabels!["group"]!)")
            cell.settingsCourseLabel.text = String("\(studentInfoLabels!["course"]!)")
            cell.settingsStudyYearLabel.text = String("\(studentInfoLabels!["studyYear"]!)")
        }
        
        cell.backgroundColor = #colorLiteral(red: 0.8033416867, green: 0.9591512084, blue: 1, alpha: 1)
    
        return cell
    }
    
    func loadData() {
        studentInfoLabels = UserDefaults.standard.object(forKey: "studentInfoLabels") as? [String: String]
        self.collectionView.reloadData()
    }
}

extension SettingsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: self.view.frame.width/1.3, height: 200)
     }

     func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
    }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return CGFloat(20)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return CGFloat(20)
     }
}
