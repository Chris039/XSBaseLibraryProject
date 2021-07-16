//
//  UIButton+Extension.swift
//  XSBaseLibraryProject
//
//  Created by chris lee on 2021/7/13.
//  Copyright © 2021年 chris lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

var disabledBackgroundColorKey: String = "disabledBackgroundColorKey"
var enabledBackgroundColorKey: String = "enabledBackgroundColorKey"
var disabledTextColorKey: String = "disabledTextColorKey"
var enabledTextColorKey: String = "enabledTextColorKey"
var bgColorChangeAnimationKey: String = "bgColorChangeAnimationKey"
var disabledBackgroundImageKey: String = "disabledBackgroundImageKey"
var enabledBackgroundImageKey: String = "enabledBackgroundImageKey"
var jwEnabledKey: String = "jwEnabledKey"
var disabledBorderColorKey: String = "disabledBorderColorKey"
var enabledBorderColorKey: String = "enabledBorderColorKey"

var animateDuration = 0.3
 
//extension JWButton {
//    public var jwIsEnabled:Binder<Bool>{
//        return Binder(self) { button, jwIsEnabled in
//            button.jwEnabled = jwIsEnabled
//        }
//    }
//}

// MARK: 拓展属性
@IBDesignable
public extension UIButton  {
    
    /// 改变背景色动画
    @IBInspectable var bgColorChangeAnimation : Bool {
        
        get {
            return objc_getAssociatedObject(self, &bgColorChangeAnimationKey) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &bgColorChangeAnimationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            animateDuration = 0.0
        }
    }
    
    /// 是否启用
    @IBInspectable var jwEnabled : Bool {
    
        get {
                return objc_getAssociatedObject(self, &jwEnabledKey) as? Bool ?? true
        }
        
        set {
        
            objc_setAssociatedObject(self, &jwEnabledKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        
            self.isEnabled = jwEnabled
            
            let bgColor = jwEnabled ? self.enabledBackgroundColor : self.disabledBackgroundColor
            let textColor = jwEnabled ? self.enabledTextColor : self.disabledTextColor
            let bgImage = jwEnabled ? self.enabledBackgroundImage : self.disabledBackgroundImage
            let borderColor = jwEnabled ? self.enabledBorderColor : self.disabledBorderColor
             
//                UIView.animate(withDuration: animateDuration) {
                    
                    self.setTitleColor(textColor, for: .normal)
                    self.layer.borderColor = borderColor.cgColor
//                    guard let _ = self.enabledBackgroundImage, let _ = self.disabledBackgroundImage else {
                    self.backgroundColor = bgColor
//                        return
//                    }
                    self.setBackgroundImage(bgImage, for: .normal)
//                }
        }
    
    }
    
    /// 设置禁用状态下背景色
    @IBInspectable  var disabledBackgroundColor : UIColor {
    
        get {
            
            return objc_getAssociatedObject(self, &disabledBackgroundColorKey) as? UIColor ?? UIColor.white
        }
    
        set {
            
            if newValue != self.disabledBackgroundColor {
                
                objc_setAssociatedObject(self, &disabledBackgroundColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
             
            if !self.jwEnabled {
            
                UIView.animate(withDuration: animateDuration){
                    
                    self.backgroundColor = self.disabledBackgroundColor
                }
            }
        }
    }
    
    /// 设置启用状态下背景色
    @IBInspectable var enabledBackgroundColor : UIColor {
    
        get {
            return objc_getAssociatedObject(self, &enabledBackgroundColorKey) as? UIColor ?? UIColor.white
        }
        
        set {
           
            if newValue != self.enabledBackgroundColor {
                            
               objc_setAssociatedObject(self, &enabledBackgroundColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
             
            if self.jwEnabled {
            
                UIView.animate(withDuration: animateDuration){
                    
                    self.backgroundColor = self.enabledBackgroundColor
                }
            }
        }
    
    }
    
    /// 设置禁用状态下边框色
    @IBInspectable var disabledBorderColor : UIColor {
        get {
            
            return objc_getAssociatedObject(self, &disabledBorderColorKey) as? UIColor ?? UIColor.clear
        }
        set {
            
            if newValue != self.disabledBorderColor {
                            
               objc_setAssociatedObject(self, &disabledBorderColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            if !self.jwEnabled {
            
                UIView.animate(withDuration: animateDuration){
                    
                    self.layer.borderColor = self.disabledBorderColor.cgColor
                }
            }
        }
    }
    
    /// 设置启用状态下边框色
    @IBInspectable var enabledBorderColor : UIColor {
     
         get {
            return objc_getAssociatedObject(self, &enabledBorderColorKey) as? UIColor ?? UIColor.clear
         }
         
         set {
            
            if newValue != self.enabledBorderColor {
                             
                objc_setAssociatedObject(self, &enabledBorderColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
              
            if self.jwEnabled {
             
                UIView.animate(withDuration: animateDuration){
                     
                    self.layer.borderColor = self.enabledBorderColor.cgColor
                }
            }
        }
     
    }
    
    /// 设置启用状态下文字颜色
    @IBInspectable var enabledTextColor : UIColor {
        
        get {
            
            return objc_getAssociatedObject(self, &enabledTextColorKey) as? UIColor ?? UIColor.black
        }
        
        set {
           
            if newValue != self.enabledTextColor {
                            
               objc_setAssociatedObject(self, &enabledTextColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            if self.jwEnabled {
            
                UIView.animate(withDuration: animateDuration){
                    
                    self.titleLabel?.textColor = self.enabledTextColor
                    self.setTitleColor(self.enabledTextColor, for: .normal)
                }
            }
        }
    }
    
    /// 设置禁用状态下文字颜色
    @IBInspectable var disabledTextColor : UIColor {
        
        get {
            
            return objc_getAssociatedObject(self, &disabledTextColorKey) as? UIColor ?? UIColor.black
        }
        
        set {
           
            if newValue != self.disabledTextColor {
                            
               objc_setAssociatedObject(self, &disabledTextColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            if !self.jwEnabled {
            
                UIView.animate(withDuration: animateDuration){
                    
                    self.titleLabel?.textColor = self.disabledTextColor
                    self.setTitleColor(self.disabledTextColor, for: .normal)
                }
            }
        }
    }
    
    /// 设置启用状态下背景图
    var enabledBackgroundImage : UIImage? {
        set{
            if newValue != self.enabledBackgroundImage {
                            
               objc_setAssociatedObject(self, &enabledBackgroundImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            if !self.jwEnabled {
            
                UIView.animate(withDuration: animateDuration){
                    
                    self.setBackgroundImage(self.enabledBackgroundImage, for: .normal)
                }
            }
        }
        get{
            return objc_getAssociatedObject(self, &enabledBackgroundColor) as? UIImage ?? UIImage()
        }
    }
    
    /// 设置禁用状态下背景图
    var disabledBackgroundImage : UIImage? {
        set{
            if newValue != self.enabledBackgroundImage {
                            
               objc_setAssociatedObject(self, &disabledBackgroundImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            if !self.jwEnabled {
            
                UIView.animate(withDuration: animateDuration){
                    
                    self.setBackgroundImage(self.disabledBackgroundImage, for: .normal)
                }
            }
        }
        get{
            return objc_getAssociatedObject(self, &disabledBackgroundImageKey) as? UIImage ?? UIImage()
        }
    }
    
}

// MARK: 拓展函数
public extension UIButton  {

    /// 设置Title
    ///
    /// - Parameters:
    ///     - title: 设置文字
    ///     - state: 按钮状态
    func setTitleText(title: String, for state: UIControl.State) {
        
        self.titleLabel?.text = title
        self.setTitle(title, for: state)
    }
    
    /// 倒计时文字
    ///
    /// - Parameters:
    ///     - countDownSeconds: 倒计时时长
    ///     - normalTitle: 默认文案
    ///     - countdownTitle: 重发文案
    func sendCodeCountdown(countDownSeconds: Int = 60, normalTitle: String = "发送", countdownTitle: String = "重发") {
        
        let button = self
        let titleName = "\(countDownSeconds)s"
        button.setTitle(titleName, for: .normal)
        button.jwEnabled = false
         
        let timer = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        let countDownStopped = BehaviorRelay(value: false)
        let leftTime = BehaviorRelay(value:Int(countDownSeconds))
        
        timer.take(until: countDownStopped.asObservable().filter{$0})
            .subscribe { (_) in
                
                if (leftTime.value <= 0) {
                    
                    countDownStopped.accept(true)
                    leftTime.accept(countDownSeconds)
                    button.jwEnabled = true
                    countDownStopped.accept(true)
                    button.setTitleText(title: normalTitle, for: .normal)
                    
                }else{
                    button.jwEnabled = false
                    let sum = leftTime.value
                    leftTime.accept(sum - 1)
                    button.setTitleText(title: "\(leftTime.value)s", for: .normal)
                }
                  
        }.disposed(by: disposeBag)
          
    }
    
    /// 设置文字颜色和字号大小
    ///
    /// - Parameters:
    ///     - textColor: 设置文字颜色
    ///     - textFont: 设置文字字号大小
    convenience init(textColor: UIColor, textFont: UIFont) {
        self.init()
        self.titleLabel?.font = textFont
        self.setTitleColor(textColor, for: .normal)
    }
    
    /// 设置按钮图片
    ///
    /// - Parameters:
    ///     - normalImage: 默认状态图片
    ///     - selectedImage: 选中状态图片
    convenience init(normalImage: UIImage, selectedImage:UIImage? = nil)  {
        self.init()
        self.setImage(normalImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
    }
    
    /// 设置文字颜色和字号大小
    ///
    /// - Parameters:
    ///     - textColor: 设置文字颜色
    ///     - textFont: 设置文字字号大小
    func setColorAndFont(textColor: UIColor, textFont: UIFont) {
        self.titleLabel?.font = textFont
        self.setTitleColor(textColor, for: .normal)
    }
    
    /// 设置按钮图片
    ///
    /// - Parameters:
    ///     - normalImage: 默认状态图片
    ///     - selectedImage: 选中状态图片
    func setImage(normalImage: UIImage, selectedImage:UIImage? = nil)  {
        self.setImage(normalImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
    }
}
