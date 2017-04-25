//
//  ViewController.swift
//  TSActionSheetDemo
//
//  Created by 王磊 on 25/04/2017.
//  Copyright © 2017 ThreeStone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var item: UIButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(item)
        
        item.setTitle("展示action", for: .normal)
        
        item.setTitle("收回action", for: .selected)
        
        item.setTitleColor(UIColor.red, for: .normal)
        
        item.setTitleColor(UIColor.blue, for: .selected)
        
        item.isSelected = false
        
        item.addTarget(self, action: #selector(actionSheetShow), for: .touchUpInside)
        
        item.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    }
}

extension ViewController {
    
    @objc fileprivate func actionSheetShow(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        
        
        let actionSheet = TSActionSheet.actionSheet(title: "弹出框ActionSheet", cancleButtonTitle: "取消", destructiveButtonTitle: "", otherButtonTitles: ["确定"]) { (dismissType, buttonIndex) in
            switch (dismissType,buttonIndex) {
            case (.Item,buttonIndex):
                
                print(buttonIndex)
                
                break
            default:
                break
            }
            
        }
        
        actionSheet.show()
    }
}
