# TSActionSheet
################# 
1.Download and drag TSActionSheet.swift to your project
Or
2.pod 'ActionSheet' -~'1.0.0'

#########简单用法#############
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

##########
