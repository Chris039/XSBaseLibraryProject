//
//  ViewController.swift
//  XSBaseLibraryProject
//
//  Created by chris lee on 2021/7/13.
//

import UIKit

class ViewController: UIViewController {
    var startDate:Int? = 0
    var endDate:Int? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        showAlert()
    }
    
    // MARK: AlertView
    func showAlert() {
        
        let alertView = JWAlertView.init(style: .custom, title: "Tips", messase: "Are you sure to delete?")
        
        alertView.show(view: self.navigationController?.view, items: ["Cancel", "Done"]) { [weak self] (button, idx) in
//            guard let `self` = self else { return }
            
        }
    }
    
    // MARK: 日历选择器
    func showCalenderView() {
        let view = JTCalendarView()
        view.limitMonth = 6
        view.BeforeTodayCanTouch = true
        view.afterTodayCanTouch = false
        view.startDate = startDate
        view.endDate = endDate
        view.type = JTSenctionScalendarType.JTSenctionScalendarPastType
        view.selectType = JTSenctionSelectType.JTSenctionSelectTypeAreaDate
        view.areaDateBlock = { [weak self] (beginDate, endDate) in
            guard let `self` = self else { return }
            
            self.startDate = beginDate
            self.endDate = endDate
        }
        view.show()
    }
}

