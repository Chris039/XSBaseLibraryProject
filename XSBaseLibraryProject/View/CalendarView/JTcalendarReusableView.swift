//
//  JTScalendarReusableView.swift
//  松鼠Demo
//
//  Created by 管理员 on 2021/7/1.
//

import UIKit

class JTcalendarReusableView: UICollectionReusableView {
    var headerLabel :UILabel!
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatReusableView()
    }
    
    
    func creatReusableView() {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(headerView)
        
        headerLabel = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: self.frame.size.width - 20, height: self.frame.size.height))
        headerLabel.textAlignment = .center
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        headerLabel.font = UIFont.systemFont(ofSize: 18)
        headerView.addSubview(headerLabel)
    }
}
