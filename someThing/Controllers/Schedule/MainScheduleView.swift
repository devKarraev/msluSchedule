//
//  MainScheduleView.swift
//  someThing
//
//  Created by Расул Караев on 6/29/20.
//  Copyright © 2020 Расул Караев. All rights reserved.
//

import Pageboy
import Tabman
import UIKit

class MainScheduleView: TabmanViewController {
    
    let mainColor = #colorLiteral(red: 0, green: 0.8979069591, blue: 0.7852694988, alpha: 1)
    let secondaryColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
        dispatchGroup = DispatchGroup()
    
    var vSpinner : UIView?

    @IBOutlet weak var pickerButton: UIButton!
    private var viewControllers = [MainScheduleCollectionViewController]()
    
    let weekDay = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"]
    
    let semaphore = DispatchSemaphore(value: 0),
        scheduleModel = ScheduleModel(),
        weekDays: [Int: Int] = [1: 0, 2: 0, 3: 1, 4: 2, 5: 3, 6: 4, 7: 5]
    
    var schedule: [String: [Int: [String: Any]]]?,
        currentDay = Int(),
        selectedDate = Int(),
        toolBar = UIToolbar(),
        picker  = UIPickerView(),
        pickerData = [Int: [String: Any]](),
        rangeStudyDate = [Int: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = self.mainColor
        let calendar = Calendar.current,
        date = Date()
        self.currentDay = calendar.component(.weekday, from: date)
        self.currentDay = weekDays[self.currentDay]!
        UserDefaults.standard.set(nil, forKey: "studyWeekDate")
        
        self.scheduleModel.getCalendarData()
        self.schedule = self.scheduleModel.xlsResultSchedule
        self.rangeStudyDate = self.scheduleModel.currentRangeDate
        
        self.setDataIntoViewControllers()
        
        self.dataSource = self
        view.backgroundColor = .white
        self.pickerData = self.scheduleModel.studyWeeksData

        configurePickerButton()
        setNavigationBar()
    }
    
    func configurePickerButton() {
        self.pickerButton.setTitle(self.rangeStudyDate.first!.value, for: .normal)
        self.pickerButton.titleLabel?.numberOfLines = 1
        self.pickerButton.titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        self.pickerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.pickerButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        self.pickerButton.layer.cornerRadius = 15
        self.pickerButton.backgroundColor = self.mainColor
        self.pickerButton.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "isInfoChanged") {
            UserDefaults.standard.set(false, forKey: "isInfoChanged")
            scheduleModel.studentInfo = UserDefaults.standard.object(forKey: "studentInfoValues") as? [String: Int]
            self.scheduleModel.xlsResultSchedule.removeAll()
            self.scheduleModel.getCalendarData()
            self.schedule = self.scheduleModel.xlsResultSchedule
            self.viewControllers.removeAll()
            self.setDataIntoViewControllers()
            self.reloadData()
        }
    }
    
    func setDataIntoViewControllers() {
        for item in weekDay {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "mainSchedule") as! MainScheduleCollectionViewController
            if self.schedule?.count == 0 { viewControllers.append(controller); continue }
            guard let schedule = self.schedule?[item] else { viewControllers.append(controller); continue }
            controller.schedule = schedule
            viewControllers.append(controller)
        }
    }

    func setNavigationBar() {
        // Create bar
        let bar = TMBar.ButtonBar(),
            systemBar = bar.systemBar()
        
        systemBar.backgroundStyle = .flat(color: .secondarySystemBackground)
        systemBar.separatorColor = .clear
        addBar(systemBar, dataSource: self, at: .top)
        
        bar.layout.transitionStyle = .snap // Customize
        bar.buttons.customize { (button) in
            button.tintColor = self.secondaryColor
            button.selectedTintColor = self.mainColor
            button.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        bar.layout.contentMode = .fit
        bar.indicator.weight = .light
        bar.indicator.tintColor = self.mainColor
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12)
        bar.backgroundView.style = .flat(color: .secondarySystemBackground)
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
    
    @IBAction func pushPickerButton(_ sender: UIButton) {
        createPickerView()
    }
    
    func createPickerView() {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 250)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerViewDoneButton(sender:)))
        doneButton.tintColor = self.mainColor
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.items = [spaceButton, doneButton]
        
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
        
        if selectedDate != 0 {
            picker.selectRow(selectedDate, inComponent: 0, animated: false)
        }
    }
    
    @objc func pickerViewDoneButton(sender: UIBarButtonItem) {
        self.dispatchGroup.enter()
        self.toolBar.removeFromSuperview()
        self.picker.removeFromSuperview()
        self.showSpinner(onView: self.view)
        dispatchGroup.notify(queue: .main) {
            self.pickerButton.setTitle(String("\(self.pickerData[self.selectedDate]!["name"]!)"), for: .normal)
            UserDefaults.standard.set(self.pickerData[self.selectedDate]!["value"]!, forKey: "studyWeekDate")
            self.scheduleModel.xlsResultSchedule.removeAll()
            self.scheduleModel.getCalendarData()
            self.schedule = self.scheduleModel.xlsResultSchedule
            self.viewControllers.removeAll()
            self.setDataIntoViewControllers()
            self.reloadData()
            
            self.removeSpinner()
        }
    }
}

extension MainScheduleView: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = "\(weekDay[index])"
        return TMBarItem(title: title)
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: self.currentDay)
    }
}

extension MainScheduleView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDate = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]!["name"] as? String
    }
}


extension MainScheduleView {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.color = self.mainColor
        ai.startAnimating()
        ai.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
            self.vSpinner = spinnerView
            self.dispatchGroup.leave()
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
