//
//  TSActionSheet.swift
//  ThreeStone
//
//  Created by 王磊 on 17/2/10.
//  Copyright © 2017年 ThreeStone. All rights reserved.
//
#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

fileprivate let debug: Bool = true

func printLog<T>(message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    
    if debug {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message): \(NSDate().timeIntervalSince1970 * 1000)")
    }
}


enum TSActionSheetDismissType: Int {
    case TapDarkShadow
    case Item
}
enum TSAlertActionType: Int {
    case Confirm
    
    case Cancle
}

/*
 if dismissType ==  .TapDarkShadow buttonIndex = nil
 if dismissType ==  .Button buttonIndex = button.tag
 */
typealias TSActionSheetBlock = (_ dismissType: TSActionSheetDismissType,_ buttonIndex: Int) -> ()

private let Screen_Width: CGFloat = UIScreen.main.bounds.width

private let Screen_Height: CGFloat = UIScreen.main.bounds.height

private let ActionSheet_Title_Height: CGFloat = 60

private let ActionSheet_Button_Height: CGFloat = 60

private let ActionSheet_Show_Animated_Duration: TimeInterval = 0.3

private let ActionSheet_Dismiss_Animated_Duration: TimeInterval = 0.2

private func RGBColor(r: CGFloat,g: CGFloat ,b: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0,green: g / 255.0,blue: b / 255.0,alpha: 1)
}

private let Clear_Color: UIColor = UIColor.clear

private let White_Color: UIColor = UIColor.white

private extension String {
    
    var length: Int {
        return lengthOfBytes(using: String.Encoding.utf8)
    }
    
}

private extension UIImage {
    
    class func imageWithColor(color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            
            return nil
        }
        
        context.setFillColor(color.cgColor)
        
        context.fill(rect)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        return image
    }
}


class TSActionSheet: UIView {
    /*
     * actionSheetBlock 点击的哪里 如果点击的是按钮 回调按钮下标
     */
    fileprivate var actionSheetBlock: TSActionSheetBlock?
    
    /*
     * 透明背景 view
     */
    fileprivate lazy var darkShadowView: UIView = UIView()
    /*
     * 透明背景的透明度
     */
    internal var darkShadowAlpha: CGFloat = 0.3
    /*
     * 按钮背景 view
     */
    fileprivate lazy var buttonBackgroundView: UIView = UIView()
    
    /*
     * 标题
     */
    fileprivate var title: String = ""
    /*
     * 取消按钮标题
     */
    fileprivate var cancleButtonTitle: String = ""
    /*
     *
     */
    fileprivate var destructiveButtonTitle: String = ""
    
    fileprivate var otherButtonTitles: NSMutableArray = NSMutableArray()
    
    internal var titleLabelFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    internal var titleLabelTextColor: UIColor = UIColor.darkGray
    
    internal var destructiveTextColor: UIColor = UIColor.red
    
    internal var otherBtnFont: UIFont = UIFont.systemFont(ofSize: 13)
    
    internal var otherBtnTextColor: UIColor = UIColor.black
    
    static func actionSheet(title: String = "",cancleButtonTitle: String = "",destructiveButtonTitle: String = "",otherButtonTitles: NSArray? ,actionSheetBlock: @escaping TSActionSheetBlock) -> TSActionSheet {
        return TSActionSheet(title: title, cancleButtonTitle: cancleButtonTitle, destructiveButtonTitle: destructiveButtonTitle, otherButtonTitles: otherButtonTitles, actionSheetBlock: actionSheetBlock)
    }
    
    required init(title: String = "",cancleButtonTitle: String = "",destructiveButtonTitle: String = "",otherButtonTitles: NSArray?,actionSheetBlock: @escaping TSActionSheetBlock) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height))
        
        self.title = title
        
        self.cancleButtonTitle = cancleButtonTitle.length > 0 ? cancleButtonTitle : "取消"
        
        if !destructiveButtonTitle.isEmpty {
            
            self.otherButtonTitles.add(destructiveButtonTitle)
        }
        
        self.destructiveButtonTitle = destructiveButtonTitle
        
        if let _ = otherButtonTitles, otherButtonTitles!.count > 0 {
            self.otherButtonTitles.addObjects(from: otherButtonTitles! as [AnyObject])
        }
        
        self.actionSheetBlock = actionSheetBlock
        
        commitInitSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TSActionSheet {
    
    fileprivate func commitInitSubviews() {
        
        frame = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height)
        
        backgroundColor = Clear_Color
        
        isHidden = true
        
        darkShadowView.alpha = 0
        
        darkShadowView.frame = bounds
        
        darkShadowView.backgroundColor = RGBColor(r: 30, g: 30, b: 30)
        
        addSubview(darkShadowView)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDismiss))
        
        darkShadowView.addGestureRecognizer(tap)
        
        buttonBackgroundView.backgroundColor = RGBColor(r: 220, g: 220, b: 220)
        
        addSubview(buttonBackgroundView)
        
        if title.length > 0 {
            
            let titleLabel: UILabel = UILabel(frame: CGRect(x: 0, y: ActionSheet_Button_Height - ActionSheet_Title_Height, width: Screen_Width, height: ActionSheet_Title_Height))
            
            titleLabel.font = titleLabelFont
            
            titleLabel.text = title
            
            titleLabel.textAlignment = .center
            
            titleLabel.textColor = titleLabelTextColor
            
            titleLabel.backgroundColor = White_Color
            
            titleLabel.numberOfLines = 0
            
            buttonBackgroundView.addSubview(titleLabel)
        }
        var i: Int = 0
        
        for item in otherButtonTitles {
            
            let btn: UIButton = UIButton(type: .custom)
            
            btn.tag = i
            
            buttonBackgroundView.addSubview(btn)
            
            btn.backgroundColor = White_Color
            
            btn.titleLabel?.font = titleLabelFont
            
            btn.setTitleColor(otherBtnTextColor, for: .normal)
            
            if i == 0 && destructiveButtonTitle.length > 0 {
                
                btn.setTitleColor(destructiveTextColor, for: .normal)
            }
            
            let btnY = ActionSheet_Button_Height * CGFloat(i + (title.length > 0 ? 1 : 0 ))
            
            btn.frame = CGRect(x: 0, y: btnY, width: Screen_Width, height: ActionSheet_Button_Height)
            
            btn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            
            btn.setTitle(item as? String, for: .normal)
            
            btn.setBackgroundImage(UIImage.imageWithColor(color: RGBColor(r: 245, g: 245, b: 245)), for: .highlighted)
            
            buttonBackgroundView.addSubview(btn)
            
            let line = UIView()
            
            line.backgroundColor = RGBColor(r: 200, g: 200, b: 200)
            
            line.frame = CGRect(x: 0, y: btnY, width: Screen_Width, height: 0.5)
            
            buttonBackgroundView.addSubview(line)
            
            i += 1
        }
        
        let cancelBtn: UIButton = UIButton(type: .custom)
        
        cancelBtn.tag = otherButtonTitles.count
        
        cancelBtn.backgroundColor = White_Color
        
        cancelBtn.titleLabel?.font = otherBtnFont
        
        cancelBtn.setTitle(cancleButtonTitle, for: .normal)
        
        cancelBtn.setTitleColor(otherBtnTextColor, for: .normal)
        
        cancelBtn.setBackgroundImage(UIImage.imageWithColor(color: RGBColor(r: 245, g: 245, b: 245)), for: .highlighted)
        
        let btnY: CGFloat = ActionSheet_Button_Height * CGFloat(otherButtonTitles.count + (title.length > 0 ? 1 : 0)) + 3
        
        cancelBtn.frame = CGRect(x: 0, y: btnY, width: Screen_Width, height: ActionSheet_Button_Height)
        
        cancelBtn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        buttonBackgroundView.addSubview(cancelBtn)
        
        let bg_height: CGFloat = ActionSheet_Button_Height * CGFloat(otherButtonTitles.count + 1 + (title.length > 0 ? 1 : 0)) + 3
        
        buttonBackgroundView.frame = CGRect(x: 0, y: Screen_Height, width: Screen_Width, height: bg_height)
        
    }
    
}
extension TSActionSheet {
    
    @objc fileprivate func buttonClick(button: UIButton) {
        
        if let _ = actionSheetBlock {
            
            actionSheetBlock!(.Item,button.tag)
        }
        
        dismiss()
        
    }
}

extension TSActionSheet {
    
    @objc fileprivate func viewDismiss() {
        
        if let _ = actionSheetBlock {
            
            actionSheetBlock!(.TapDarkShadow,999)
        }
        
        dismiss()
    }
    
}
extension TSActionSheet {
    
    internal func show() {
        let window = UIApplication.shared.keyWindow
        
        window?.addSubview(self)
        
        isHidden = false
        
        UIView.animate(withDuration: ActionSheet_Show_Animated_Duration, animations: { [weak self] in
            
            self!.darkShadowView.alpha = self!.darkShadowAlpha
            
            self!.buttonBackgroundView.transform = CGAffineTransform(translationX: 0, y: -self!.buttonBackgroundView.bounds.height)
            
        }) { (isFinished) in
            
            
        }
    }
    fileprivate func dismiss() {
        
        UIView.animate(withDuration: ActionSheet_Dismiss_Animated_Duration, animations: {[weak self] in
            
            self!.darkShadowView.alpha = 0
            
            self!.buttonBackgroundView.transform = CGAffineTransform.identity
            
        }) { [weak self](isFinished) in
            
            self!.isHidden = true
            
            self!.removeFromSuperview()
        }
        
    }
}
