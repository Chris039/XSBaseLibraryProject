//
//  JTCalendarView.swift
//  JTStationSingapore
//
//  Created by chris lee on 2021/6/29.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenProportion = kScreenWidth / 375
let IS_IPHONE_X: Bool = kScreenHeight == 812 || kScreenHeight == 896 ? true : false
let STATUS_NAV_BAR_Y:CGFloat = IS_IPHONE_X == true ? 88.0 : 64.0

/// 日历显示的类型 可选过去/可选将来
enum JTSenctionScalendarType{
    case JTSenctionScalendarPastType
    case JTSenctionScalendarMidType
    case JTSenctionScalendarFutureType
}

/// 日历选择的类型 可选一天日期/可选一个日期区间
enum JTSenctionSelectType{
    case JTSenctionSelectTypeOneDate
    case JTSenctionSelectTypeAreaDate
}

public let defaultTextColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)//默认字体颜色
public let selectDateBackGroundColor = UIColor(red: 0.84, green: 0, blue: 0.14, alpha: 1)//选中日期背景色
public let failureDateTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)//过期日期字体颜色

class JTCalendarView: UIView {
    
    /// header高度
    let cellHeaderViewHight = 50
    /// 可选择的月份数量
    var limitMonth: NSInteger = 6
    /// 可选范围过去或者将来
    var type : JTSenctionScalendarType = JTSenctionScalendarType.JTSenctionScalendarPastType
    /// 单选时间或者时间区域
    var selectType : JTSenctionSelectType = JTSenctionSelectType.JTSenctionSelectTypeAreaDate
    /// 今日之后是否可点击
    var afterTodayCanTouch : Bool = false
    /// 今日之前是否可点击
    var BeforeTodayCanTouch: Bool = true
    /// 显示中国节假日
    var showChineseHoliday : Bool = false
    /// 显示农历
    var ShowChineseCalendar: Bool = false
    /// 显示节假日颜色
    var ShowHolidayColor   : Bool = true
    /// 开始时间
    var startDate : Int? = 0 {
        didSet {
            if startDate == 0 {
                let currentDate: Int = Int(Date.getNowTimeInterval())
                self.startTimeLabel.text = Date.timeStampToString(timeStamp: String(currentDate), dateFormat: "yyyy-MM-dd")
            } else {
                self.startTimeLabel.text = Date.timeStampToString(timeStamp: String(startDate!), dateFormat: "yyyy-MM-dd")
            }
            
        }
    }
    /// 结束时间
    var endDate : Int? = 0 {
        didSet {
            if endDate == 0{
                self.endTimeLabel.text = ""
            } else {
                self.endTimeLabel.text = Date.timeStampToString(timeStamp: String(endDate!), dateFormat: "yyyy-MM-dd")
            }
        }
    }
    var showAlertView      : Bool = true
    
    /// 单选返回
    var signleDateBlock: ((_ selectTime: Int) -> ())?
    /// 复选返回
    var areaDateBlock: ((_ beginTime: Int, _ endTime: Int) -> ())?
    
    private var tempMaskView : UIView = UIView()
    private lazy var titleLabel: UILabel =  {
        let label = UILabel()
//        titleLabel.textColor = .titleColor
        label.textColor = .darkText
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "请选择时间段"
        return label
    }()
    
    private lazy var startTitleLabel: UILabel =  {
        let label = UILabel()
//        titleLabel.textColor = .titleColor
        label.textColor = .darkText
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "开始时间"
        return label
    }()
    
    private lazy var endTitleLabel: UILabel =  {
        let label = UILabel()
//        titleLabel.textColor = .titleColor
        label.textColor = .darkText
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "截止时间"
        return label
    }()
    
    private lazy var startTimeLabel: UILabel =  {
        let label = UILabel()
//        titleLabel.textColor = .titleColor
        label.textColor = .darkText
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
//        label.text = Date.timeStampToString(timeStamp: String(startDate!), dateFormat: "yyyy-MM-dd")
        return label
    }()
    
    private lazy var endTimeLabel: UILabel =  {
        let label = UILabel()
//        titleLabel.textColor = .titleColor
        label.textColor = .darkText
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
//        label.text = Date.timeStampToString(timeStamp: String(endDate!), dateFormat: "yyyy-MM-dd")
        return label
    }()
    
    private lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.hidden()
        }).disposed(by: disposeBag)
        return button
    }()
    
    private lazy var confirmBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            
            if let block = self.signleDateBlock {
                block(self.startDate!)
            }
            
            if let block = self.areaDateBlock {
                self.checkBeginDate()
                block(self.startDate!, self.endDate!)
            }
            
            self.hidden()
        }).disposed(by: disposeBag)
        return button
    }()
    
    func checkBeginDate() {
        if startDate == 0 {
            startDate = Int(Date.getNowTimeInterval())
        }
    }
    
    var dataArray=[Any]()
    var collectionView : UICollectionView!
    let weekArray = ["日","一","二","三","四","五","六"]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayout()
    }
    
    /// 显示动画
    func show(inView: UIView = UIApplication.shared.keyWindow!) {
        
        let supview = inView
        let subview = self
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        addMaskView(supview: supview)
        subview.backgroundColor = .white
        supview.addSubview(subview)

        subview.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(kScreenWidth)
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            
            self.tempMaskView.alpha = 0.2
            subview.alpha = 1.0
            
        }, completion: { (bool) in
 
        })
    }
    
    /// 隐藏动画
    func hidden(view: UIView? = nil) {
        let subview = self
        var maskView = view
        if view == nil {
            maskView = tempMaskView
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            
            maskView!.alpha = 0.0
            subview.alpha = 0.0
            
        }, completion: {(bool) in
            
            subview.removeFromSuperview()
            maskView!.removeFromSuperview()
        })
    }
    
}

private extension JTCalendarView {
    // MARK: set up
    func setupSubViews() {
        
        initDataSource()
        
        self.addSubview(titleLabel)
        self.addSubview(startTitleLabel)
        self.addSubview(endTitleLabel)
        self.addSubview(startTimeLabel)
        self.addSubview(endTimeLabel)
        self.addSubview(cancelBtn)
        self.addSubview(confirmBtn)
        
        addWeakView()
        creatCollectionView()
    }
    
    func setupLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
        startTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(20)
        }
        
        endTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(startTitleLabel.snp.right)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(20)
        }
        
        startTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(startTitleLabel.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(20)
        }
        
        endTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(endTitleLabel.snp.bottom)
            make.left.equalTo(startTimeLabel.snp.right)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(20)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(40)
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(40)
        }
    }
    
    /// 添加顶部周title
    func addWeakView() {
        let weekView = UIView()
        weekView.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        self.addSubview(weekView)
        
        weekView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(startTimeLabel.snp.bottom)
            make.height.equalTo(40)
        }
        
        let weekWidth = (kScreenWidth - 40) / 7
        for i in 0 ..< 7 {
            let weekLabel = UILabel.init(frame: CGRect.init(x: Int(Float(i)*Float(weekWidth)) , y: 0, width: Int(weekWidth), height: 40))
            weekLabel.backgroundColor = UIColor.clear
            weekLabel.text = weekArray[i]
            weekLabel.font = UIFont.systemFont(ofSize: 15)
            weekLabel.textAlignment = .center
            weekLabel.textColor = defaultTextColor
            weekView.addSubview(weekLabel)
        }
    }
    
    /// 创建CollectionView
    func creatCollectionView()  {
        addWeakView()
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: (kScreenWidth - 40) / 7, height: 60)
        flowLayout.headerReferenceSize = CGSize.init(width: (kScreenWidth - 40), height: CGFloat(cellHeaderViewHight))
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0

        collectionView=UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor=UIColor.white
        collectionView.register(JTScalendarViewCell.self, forCellWithReuseIdentifier: "JTScalendarViewCell")
        collectionView.register(JTcalendarReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTScalendarReusableView")
        self.addSubview(self.collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(startTimeLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    func initDataSource() {
        DispatchQueue.global().async {
            let manager = JTScalendarManager.init(showChineseHoliday: self.showChineseHoliday, showChineseCalendar: self.ShowChineseCalendar, startDate: self.startDate!)
            let tempDataArray = manager.getCalendarDataSoruce(limitMonth: self.limitMonth, type: self.type)
            
            DispatchQueue.main.async {
                self.dataArray += tempDataArray
                self.showCollectionViewWithStartIndexPath(startIndexPath: manager.startIndexpath ?? NSIndexPath.init(row: 0, section: 0))
            }
        }
    }
    
    func showCollectionViewWithStartIndexPath(startIndexPath:NSIndexPath) {

        collectionView.reloadData()
        if startIndexPath.row != 99 {
            collectionView.scrollToItem(at: startIndexPath as IndexPath, at: .top, animated: false)
            collectionView.contentOffset = CGPoint.init(x: 0, y: collectionView.contentOffset.y - 50)
        } else {
            if type == JTSenctionScalendarType.JTSenctionScalendarPastType {
                if dataArray.count > 0 {
                    collectionView.scrollToItem(at: IndexPath.init(row: 0, section: dataArray.count - 1), at: .top, animated: false)
                    collectionView.contentOffset = CGPoint.init(x: 0, y: collectionView.contentOffset.y - 50)
                }
            }else if type == JTSenctionScalendarType.JTSenctionScalendarMidType{
                if dataArray.count > 0 {
                    collectionView.scrollToItem(at: IndexPath.init(row: 0, section: (dataArray.count - 1)/2), at: .top, animated: false)
                    collectionView.contentOffset = CGPoint.init(x: 0, y: collectionView.contentOffset.y - 50)
                }
            }
            
        }
    }
    
    func addMaskView(supview: UIView) {

        let maskView = UIView()
        tempMaskView = maskView
        maskView.backgroundColor = .black
        maskView.alpha = 0.0
        supview.addSubview(maskView)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let click = UITapGestureRecognizer()
        click.rx.event.asObservable().subscribe {[weak self] (_) in
            guard let `self` = self else { return }
            self.hidden()
        }.disposed(by: disposeBag)
        maskView.addGestureRecognizer(click)
    }
}

extension JTCalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let headerItem = dataArray[section] as! JTSectionCalendarHeaderModel
        return headerItem.calendarItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTScalendarViewCell", for: indexPath) as? JTScalendarViewCell
        let headerItem = dataArray[indexPath.section] as! JTSectionCalendarHeaderModel
        let calendarItem = headerItem.calendarItemArray[indexPath.row] as! JTSectionCalendarModel
        dataCell!.dataLabel.text = ""
        dataCell!.dataLabel.textColor = defaultTextColor
        dataCell!.subLabel.text = ""
        dataCell!.subLabel.textColor = defaultTextColor
        dataCell!.backgroundColor = UIColor.white
        dataCell!.isSelected = false
        dataCell!.isUserInteractionEnabled = false
        dataCell!.lineView.isHidden = true
        if calendarItem.day! > 0 {
            dataCell!.lineView.isHidden = false
            dataCell!.dataLabel.text = (calendarItem.day! as NSNumber).stringValue
            dataCell!.isUserInteractionEnabled = true
        }
        dataCell!.subLabel.text = ShowChineseCalendar == true ? calendarItem.chineseCalendar : ""
        if calendarItem.holiday != "" && calendarItem.holiday?.isEmpty != true && calendarItem.holiday != nil{
            dataCell!.subLabel.text = calendarItem.holiday
            if calendarItem.holiday == "今天" {
                dataCell!.backgroundColor = .lightGray
            }
            if ShowHolidayColor {
                dataCell!.subLabel.textColor = selectDateBackGroundColor
            }
        }
        
        if self.selectType == JTSenctionSelectType.JTSenctionSelectTypeOneDate{
            if calendarItem.dateInterval == startDate{//开始日期
                dataCell!.isSelected = true
                dataCell!.dataLabel.textColor = UIColor.white
                dataCell!.subLabel.textColor = UIColor.white
                dataCell!.backgroundColor = selectDateBackGroundColor
            }
        } else {
            if calendarItem.dateInterval == startDate{//开始日期
                dataCell!.isSelected = true
                dataCell!.dataLabel.textColor = UIColor.white
                dataCell!.subLabel.textColor = UIColor.white
                dataCell!.backgroundColor = selectDateBackGroundColor
            } else if calendarItem.dateInterval == endDate {//结束日期
                dataCell!.isSelected = true
                dataCell!.dataLabel.textColor = UIColor.white
                dataCell!.subLabel.textColor = UIColor.white
                dataCell!.backgroundColor = selectDateBackGroundColor
            } else if calendarItem.dateInterval! > startDate! && calendarItem.dateInterval!  < endDate! {//中间日期
                dataCell!.isSelected = true
                dataCell!.dataLabel.textColor = defaultTextColor
                dataCell!.subLabel.textColor = defaultTextColor
                dataCell!.backgroundColor = UIColor(red: 0.84, green: 0, blue: 0.14, alpha: 0.1)
            } else { }
        }
        if afterTodayCanTouch == false {
            if calendarItem.type == JTSectionScalendType.JTNextType {
                dataCell!.dataLabel.textColor = failureDateTextColor
                dataCell!.subLabel.textColor = failureDateTextColor
                dataCell!.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
                dataCell!.isUserInteractionEnabled = false
            }
        }
        if BeforeTodayCanTouch == false {
            if calendarItem.type == JTSectionScalendType.JTLastType {
                dataCell!.dataLabel.textColor = failureDateTextColor
                dataCell!.subLabel.textColor = failureDateTextColor
                dataCell!.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
                dataCell!.isUserInteractionEnabled = false
            }
        }
        return dataCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTScalendarReusableView", for: indexPath) as! JTcalendarReusableView
            let headerItem = dataArray[indexPath.section] as! JTSectionCalendarHeaderModel
            headerView.headerLabel.text = headerItem.headerText
            return headerView
        }
        return UICollectionReusableView.init(frame: CGRect.zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let headerItem = dataArray[indexPath.section] as! JTSectionCalendarHeaderModel
        let calendarItem = headerItem.calendarItemArray[indexPath.row] as! JTSectionCalendarModel
        
        if self.selectType == JTSenctionSelectType.JTSenctionSelectTypeOneDate {
                startDate = calendarItem.dateInterval
                self.startTimeLabel.text = Date.timeStampToString(timeStamp: String(startDate!), dateFormat: "yyyy-MM-dd")
            return
        }
        
        if startDate == 0 {
            startDate = calendarItem.dateInterval
            endDate = 0
        } else if startDate! > 0 && endDate! < 0 {
            startDate = calendarItem.dateInterval
            endDate = 0
        } else if startDate! > 0 && endDate! > 0 {
            startDate = calendarItem.dateInterval
            endDate = 0
        } else {
            if startDate! < calendarItem.dateInterval! {
                endDate = calendarItem.dateInterval
            } else {
                startDate = calendarItem.dateInterval
            }
        }
        collectionView.reloadData()
    }
}
