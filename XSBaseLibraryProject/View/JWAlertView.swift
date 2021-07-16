//
//  JWAlertView.swift
//  JWAlertViewDemo
//
//  Created by WuQiaoqiao on 2020/11/4.
//

import UIKit
import SnapKit

public typealias ButtonActionBlock = (_ button: UIButton, _ idx : Int)->()
public enum JWAlertViewStyle : Int {
	case `default`,custom
}

@objcMembers public class JWBaseAlertView : UIView {
	private let offset = 16
	private var titleOffset : Int { return title.count > 0 ? 25 : 5 }
	private var messageOffset : Int { return message.count > 0 ? offset : 0 }
	private var buttonActionBlock : ButtonActionBlock?
	
	open var doneButtonColor : UIColor = .red
	open var cancelButtonColor : UIColor = .gray
	
	private var buttons : [UIButton] = []
	
	public var title : String = "title" {
		didSet{ titleLabel.text = title }
	}
	
	public var message : String = "message" {
		didSet { subTitleLabel.text = message }
	}
	 
	lazy var titleLabel : UILabel = {
		
		let titleLabel = UILabel()
		titleLabel.textAlignment = .center
		titleLabel.textColor = .darkText
		titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
		titleLabel.numberOfLines = 0
		self.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { (make) in
			make.top.equalTo(titleOffset)
			make.left.right.equalToSuperview().inset(offset)
		}
		return titleLabel
	}()
	
	lazy var subTitleLabel : UILabel = {
		let subTitleLabel = UILabel()
		subTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
		subTitleLabel.textColor = .darkText
		subTitleLabel.textAlignment = .center
		subTitleLabel.numberOfLines = 0
		self.addSubview(subTitleLabel)
		subTitleLabel.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(offset)
			make.top.equalTo(titleLabel.snp.bottom).offset(messageOffset)
			make.bottom.equalToSuperview().inset(20)
		}
		return subTitleLabel
	}()
	
	lazy var lineView : UIView = {
		let lineView = UIView()
		lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
		self.addSubview(lineView)
		lineView.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(subTitleLabel.snp.bottom).offset(messageOffset)
			make.height.equalTo(0.5)
		}
		return lineView
	}()
	  
	func setButtons(itemNames: [String], actionBlock:@escaping ButtonActionBlock) {
		
		for button in buttons {
			button.removeFromSuperview()
		}
		
		buttonActionBlock = actionBlock
		
		subTitleLabel.snp.remakeConstraints { (make) in
			make.left.right.equalToSuperview().inset(offset)
			make.top.equalTo(titleLabel.snp.bottom).offset(offset)
		}
		
		var tempButton : UIButton?
		var idx = 0
		for name in itemNames {
			
			let button = UIButton()
			button.tag = idx
			button.setTitle(name, for: .normal)
			button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
			button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
			
			var titleColor : UIColor = .black
			if name == itemNames.first { titleColor = cancelButtonColor }
			if name == itemNames.last { titleColor = doneButtonColor }
			button.titleLabel?.textColor = titleColor
			button.setTitleColor(titleColor, for: .normal)
			
			self.addSubview(button)
			
			buttons.append(button)
			 
			if tempButton == nil {
				button.snp.makeConstraints { (make) in
					make.top.equalTo(lineView.snp.bottom)
					make.height.equalTo(45)
					make.left.equalToSuperview().inset(0)
					make.bottom.equalToSuperview()
					if name == itemNames.last {
						make.right.equalToSuperview()
					}
				}
			} else {
				let lineView = UIView()
				lineView.backgroundColor = .black
				lineView.alpha = 0.1
				self.addSubview(lineView)
				lineView.snp.makeConstraints { (make) in
					make.right.top.bottom.equalTo(tempButton!)
					make.width.equalTo(0.5)
				}
					button.snp.makeConstraints { (make) in
						make.left.equalTo(tempButton!.snp.right)
						make.top.equalTo(tempButton!.snp.top)
						make.width.equalTo(tempButton!.snp.width)
						make.height.equalTo(tempButton!.snp.height)
						if name == itemNames.last {
							make.right.equalToSuperview()
						}
					}
			}
			
			tempButton = button
			idx += 1
		}
	}
	
	@objc func buttonAction(button: UIButton) {
		
		if let block = buttonActionBlock {
			block(button,button.tag)
		}
	}
}

@objcMembers public class JWAlertView: JWBaseAlertView {
	
	public var animateDuration: TimeInterval = 0.35
	
	private var alertView = JWBaseAlertView()
	
	lazy var backgroundView: UIView = {
		let view = UIView()
		view.frame = UIScreen.main.bounds
		view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
		view.alpha = 0.0
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(tapBgAction))
		view.addGestureRecognizer(tap)
		
		return view
	}()
	
	lazy var baseAlertView : JWBaseAlertView = {
		let baseAlertView = JWBaseAlertView()
		return baseAlertView
	}()
	 
	public init(style: JWAlertViewStyle, title: String, messase: String) {
		
		let frame = UIScreen.main.bounds
		super.init(frame: frame)
		  
		baseAlertView.title = title
		baseAlertView.message = messase
  
		self.addSubview(backgroundView)
		
		baseAlertView.backgroundColor = .white
		baseAlertView.layer.cornerRadius = 10
		self.addSubview(baseAlertView)
		baseAlertView.snp.makeConstraints { (make) in
			make.width.equalToSuperview().multipliedBy(0.7)
			make.center.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		 
	}
	
	@objc public func show(view: UIView?, items: [String], actionBlock: @escaping ButtonActionBlock) {
		 
		var superView : UIView = UIApplication.shared.windows.filter{$0.isKeyWindow}.first!
		 
		if let supview = view {
			superView = supview
		}
		superView.addSubview(self)
		self.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		  
		baseAlertView.setButtons(itemNames: items) {[weak self] (button, idx) in
			
			guard let `self` = self else { return }
			
			self.dismiss()
			 
			actionBlock(button, idx)
		}
		
		baseAlertView.alpha = 0
		baseAlertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
		
		UIView.animate(withDuration: animateDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [self] in
			self.backgroundView.alpha = 1
			self.baseAlertView.alpha = 1
			baseAlertView.transform = CGAffineTransform(scaleX: 1, y: 1)
		}, completion: nil)
	}
	
	@objc func dismiss() {
		
		guard Thread.isMainThread else { return }
		
		UIView.animate(withDuration: animateDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			self.backgroundView.alpha = 0
			self.baseAlertView.alpha = 0
		}) { (bool) in
			self.removeFromSuperview()
		}
  
	}
	
	@objc func tapBgAction() {
		
//		dismiss()
	}

}
