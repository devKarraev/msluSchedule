//
//  MainScheduleCollectionViewController.swift
//  someThing
//
//  Created by Расул Караев on 6/30/20.
//  Copyright © 2020 Расул Караев. All rights reserved.
//

import UIKit

class MainScheduleCollectionViewController: UICollectionViewController {

    var schedule = [Int : [String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return schedule.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleCell", for: indexPath) as! MainScheduleCollectionViewCell
        cell.subject.text = String("\(self.schedule[indexPath.row]!["Subject"]!)")
        cell.date.text = String("\(self.schedule[indexPath.row]!["Date"]!)")
        cell.teacher.text = String("\(self.schedule[indexPath.row]!["Teacher"]!)")
        cell.cabinet.text = String("\(self.schedule[indexPath.row]!["Cabinet"]!)")
        configureCell(cell: cell)
        
        return cell
    }
    
    func configureCell(cell: MainScheduleCollectionViewCell) {
        cell.backgroundColor = #colorLiteral(red: 0.8033416867, green: 0.9591512084, blue: 1, alpha: 1)
        cell.layer.cornerRadius = CGFloat(15)
        cell.subject.addInterlineSpacing(spacingValue: 7)
        cell.subject.sizeToFit()
    }
}

extension MainScheduleCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: self.view.frame.width/1.1, height: 0)
     }

     func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20)
    }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return CGFloat(20)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return CGFloat(20)
     }
}

private extension UILabel {

    // MARK: - spacingValue is spacing that you need
    func addInterlineSpacing(spacingValue: CGFloat = 2) {

        // MARK: - Check if there's any text
        guard let textString = text else { return }

        // MARK: - Create "NSMutableAttributedString" with your text
        let attributedString = NSMutableAttributedString(string: textString)

        // MARK: - Create instance of "NSMutableParagraphStyle"
        let paragraphStyle = NSMutableParagraphStyle()

        // MARK: - Actually adding spacing we need to ParagraphStyle
        paragraphStyle.lineSpacing = spacingValue

        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        // MARK: - Assign string that you've modified to current attributed Text
        attributedText = attributedString
    }

}

