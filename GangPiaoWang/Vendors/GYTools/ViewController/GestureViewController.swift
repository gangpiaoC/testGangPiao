//
//  GestureViewController.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/24.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit

enum GestureViewControllerType: Int {
    
    //设置
    case setting = 1
    
    //验证
    case login
    
    //关闭
    case close
    
    //修改
    case  change
}

enum EditGesturepwType: Int {
    
    //添加
    case add = 1
    
    //删除
    case delegate
    
    //修改
    case change
}



enum buttonTag: Int {
    case rest = 1
    case manager
    case forget
}

class GestureViewController: GPWSecBaseViewController {
    
    /// 控制器的来源类型:设置密码、登录
    var type:GestureViewControllerType?
    
    //是否跳回根试图  true 跳回根试图  false  返回上一级
    var  flag = false
    
    //设置第一次密码的标题
    fileprivate var titleLabel:UILabel!
    
    //密码错误次数
    fileprivate var errorNum:Int!
    
    /// 重置按钮
    fileprivate var resetBtn: UIButton?
    
    /// 提示Label
    fileprivate var msgLabel: GYLockLabel?
    
    /// 解锁界面
    fileprivate  var lockView: GYCircleView?
    
    //头像
    var headImgView:UIImageView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (navigationController as! GPWNavigationController).canDrag = false
        if self.type == GestureViewControllerType.login {
            navigationController?.isNavigationBarHidden = true
            self.leftButton.isHidden = true
        }
        
        //进来先清空存储的第一个密码
        GYCircleConst.saveGesture(nil, key: gestureOneSaveKey)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (navigationController as? GPWNavigationController)?.canDrag = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorNum = 0
        bgView.backgroundColor = CircleViewBackgroundColor
        self.navigationBar.backgroundColor = UIColor.clear
        self.navigationBar.isLineHidden = true
        if self.type == GestureViewControllerType.login {
            self.leftButton.isHidden = true
        }
        //1.界面相同部分生成器
        setupSameUI()
        
        //2.界面不同部分生成器
        setupDifferentUI()
    }
    
    func setupSameUI(){
        //解锁界面
        let lockView = GYCircleView()
        lockView.y = 210
        lockView.delegate = self
        self.lockView = lockView
        view.addSubview(lockView)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 130, width: SCREEN_WIDTH, height: 25))
        titleLabel.font = UIFont.customFont(ofSize: 24)
        titleLabel.text = "为了您的账户安全"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.hex("333333")
        view.addSubview(titleLabel)

        
        self.resetBtn = UIButton(type: .custom)
        self.resetBtn?.frame = CGRect(x: 0, y: lockView.maxY + 20 , width: SCREEN_WIDTH, height: 25)
        self.resetBtn?.tag = buttonTag.rest.rawValue
        self.resetBtn?.setTitle("重新绘制", for: .normal)
        self.resetBtn?.isHidden = true
        self.resetBtn?.titleLabel?.font = UIFont.customFont(ofSize: 14)
        self.resetBtn?.setTitleColor(UIColor.hex("999999"), for: .normal)
        self.resetBtn?.addTarget(self, action: #selector(self.didClickBtn(_:)), for: .touchUpInside)
        view.addSubview(self.resetBtn!)
        
        let msgLabel = GYLockLabel.init(frame: CGRect(x: 0, y: 170, width: SCREEN_WIDTH, height: 14))
        self.msgLabel = msgLabel
        view.addSubview(msgLabel)
        
    }
    
    func setupDifferentUI() {
        switch self.type! {
        case GestureViewControllerType.setting:
            setupSubViewsSettingVc()
            break
        case GestureViewControllerType.login:
            setupSubViewsLoginVc()
            break
        case GestureViewControllerType.close:
            setupSubViewsLoginVc()
            break
        case GestureViewControllerType.change:
            setupSubViewsLoginVc()
            break
        }
    }
    
    //MARK: -设置手势密码界面
    func setupSubViewsSettingVc() {
        
        self.lockView?.type = CircleViewType.circleViewTypeSetting
        title = ""
        self.msgLabel?.showNormalMag(gestureTextBeforeSet as NSString)
    }
    
    //MARK: - 登录手势密码
    func setupSubViewsLoginVc() {
         self.lockView?.type = CircleViewType.circleViewTypeLogin
        if type == GestureViewControllerType.close || type == GestureViewControllerType.change{
             self.lockView?.type = CircleViewType.circleViewTypeVerify
             self.msgLabel?.showNormalMag(gestureTextOldGesture as NSString)
        }
        
        //头像
        headImgView = UIImageView(frame: CGRect(x: 0, y: 82, width: 62, height: 62))
        headImgView?.centerX = SCREEN_WIDTH / 2
        titleLabel.y = (headImgView?.maxY)! + 15
        titleLabel.font = UIFont.customFont(ofSize: 16)
        titleLabel.textColor = UIColor.hex("666666")
        var phone = GPWUser.sharedInstance().telephone!
        if GPWUser.sharedInstance().is_idcard == 1 {
            phone = GPWUser.sharedInstance().name ?? ""
        }
        titleLabel.text = "欢迎您," + phone
        
        self.msgLabel?.y = titleLabel.maxY + 15
        self.msgLabel?.font = UIFont.customFont(ofSize: 12)
        headImgView?.image = UIImage(named: "guster_header")
        view.addSubview(headImgView!)
        
        self.resetBtn?.setTitle("忘记手势密码", for: .normal)
        self.resetBtn?.tag = buttonTag.forget.rawValue
        self.resetBtn?.isHidden = false
    }
    
    @objc func didClickBtn(_ sender:UIButton){
        switch sender.tag {
        case buttonTag.rest.rawValue:
            //1.隐藏按钮
            self.resetBtn?.isHidden = true
            
            //3.msgLabel提示文字复位
            self.msgLabel?.showNormalMag(gestureTextBeforeSet as NSString)
            
            //4.清除之前存储的密码
            GYCircleConst.saveGesture(nil, key: gestureOneSaveKey)
            break
        case buttonTag.manager.rawValue:
            break
        case buttonTag.forget.rawValue:
            //忘记手势密码
            let alertController = UIAlertController(title: nil, message: "忘记手势密码                                  需要重新登录", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .default, handler: { (alert) in
            })
            
            alertController.addAction(cancelAction)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { (alert) in
              self.toLoginController()
            })
            alertController.addAction(okAction)
            self.navigationController?.present(alertController, animated: true, completion: nil)

            break
        default:
            break
        }
    }
    open override func back(sender: GPWButton) {
        if flag == false {
              _ = self.navigationController?.popViewController(animated: true)
        }else{
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
       
    }
    
}

extension GestureViewController: GYCircleViewDelegate {
    
    func circleViewConnectCirclesLessThanNeedWithGesture(_ view: GYCircleView, type: CircleViewType, gesture: String) {
        
        //swift 很奇葩
        guard GYCircleConst.getGestureWithKey(gestureOneSaveKey) != nil else {
            self.msgLabel?.showWarnMsgAndShake(gestureTextConnectLess as String)
            return
        }
        
        let gestureOne = GYCircleConst.getGestureWithKey(gestureOneSaveKey)! as NSString
        
        //看是否存在第一个密码
        if gestureOne.length > 0 {
            self.resetBtn?.isHidden = false
            self.msgLabel?.showWarnMsgAndShake(gestureTextConnectLess as String)
        } else {
            print("密码长度不合格\(gestureOne.length)")
            self.msgLabel?.showWarnMsgAndShake(gestureTextConnectLess as String)
        }
    }
    
    func circleViewdidCompleteSetFirstGesture(_ view: GYCircleView, type: CircleViewType, gesture: String) {
        print("获取第一个手势密码\(gesture)")
        self.resetBtn?.isHidden = false
        self.msgLabel?.showNormalMag(gestureTextDrawAgain as NSString)
    }
    
    func circleViewdidCompleteSetSecondGesture(_ view: GYCircleView, type: CircleViewType, gesture: String, result: Bool) {
        
        print("获得第二个手势密码\(gesture)")
        if result {
            print("两次手势匹配！可以进行本地化保存了")
            self.msgLabel?.showWarnMsg(gestureTextSetSuccess)
            GYCircleConst.saveGesture(gesture, key: gestureFinalSaveKey)
            if UserDefaults.standard.value(forKey: "USERPHONEGETURE") == nil {
                  UserDefaults.standard.setValue("\(GPWUser.sharedInstance().telephone ?? "0")+" + gesture, forKey: USERPHONEGETURE)
            }else{
               self.editGesturePW(type: EditGesturepwType.add, gesture: gesture)
            }
            self.bgView.makeToast("设置成功")
          
            if flag {
                if let viewControllers = self.navigationController?.viewControllers {
                    for vc in viewControllers {
                        if vc.isKind(of: GPWProjectDetailViewController.self) {
                            _ = self.navigationController?.popToViewController(vc, animated: true)
                            return
                        }
                    }
                }
                navigationController?.popToRootViewController(animated: true)
            }else{
                navigationController?.popViewController(animated: true)
            }
            
        } else {
            print("两次手势不匹配")
            self.msgLabel?.showWarnMsgAndShake(gestureTextDrawAgainError)
            self.resetBtn?.isHidden = false
        }
    }
    
    func circleViewdidCompleteLoginGesture(_ view: GYCircleView, type: CircleViewType, gesture: String, result: Bool) {
        
        //此时的type有两种情况 Login or verify
        if type == CircleViewType.circleViewTypeLogin {
            if result {
                print("登录成功!")
                if  GPWGlobal.sharedInstance().gotoUrl != "" {
                    self.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url: GPWGlobal.sharedInstance().gotoUrl!), animated: true)
                    GPWGlobal.sharedInstance().gotoUrl = ""
                }else{
                     navigationController?.popViewController(animated: true)
                }
            } else {
                print("密码错误")
                errorNum = errorNum + 1
                self.msgLabel?.showWarnMsgAndShake("密码错误，还有\(5 - errorNum)次机会")
                if errorNum >= 5 {
                    let alertController = UIAlertController(title: nil, message: "您已经连续5次输错手势密码  请重新登录", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler: { (alert) in
                      self.toLoginController()
                    })
                    alertController.addAction(okAction)
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                }
            }
        } else  if type == CircleViewType.circleViewTypeVerify {
            if result {
                if self.type == GestureViewControllerType.close {
                    
                    //删除
                    self.editGesturePW(type: EditGesturepwType.delegate, gesture: "")
                    navigationController?.popViewController(animated: true)
                }else if self.type == GestureViewControllerType.change {
                    self.headImgView?.isHidden = true
                    titleLabel.font = UIFont.customFont(ofSize: 24)
                    titleLabel.text = "为了您的账户安全"
                    titleLabel.y = 130
                    self.msgLabel?.y = 170
                    self.msgLabel?.font = UIFont.customFont(ofSize: 16)
                    self.type = GestureViewControllerType.setting
                    self.lockView?.type = CircleViewType.circleViewTypeSetting
                    self.resetBtn?.isHidden = true
                    self.resetBtn?.tag = buttonTag.rest.rawValue
                    self.resetBtn?.setTitle("重新绘制", for: .normal)
                    self.msgLabel?.showNormalMag(gestureTextBeforeSet as NSString)
                    GYCircleConst.saveGesture(nil, key: gestureOneSaveKey)
                }
            } else {
                print("密码错误")
                errorNum = errorNum + 1
                self.msgLabel?.showWarnMsgAndShake("密码错误，还有\(5 - errorNum)次机会")
                if errorNum >= 5 {
                    
                    let alertController = UIAlertController(title: nil, message: "您已经连续5次输错手势密码            请重新登录", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler: { (alert) in
                      self.toLoginController()
                    })
                    alertController.addAction(okAction)
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func editGesturePW(type:EditGesturepwType,gesture:String) {
        var tempStr = UserDefaults.standard.value(forKey: "USERPHONEGETURE") as! String
        var  temArray = tempStr.components(separatedBy: "@")
        var  tempIndex = -1
        switch type {
        case EditGesturepwType.add:
            
            //是否之前保存过密码
            var  flag = false
            for (index,str) in temArray.enumerated() {
                let  temSubArray = str.components(separatedBy: "+")
                if temSubArray[0] == GPWUser.sharedInstance().telephone {
                    flag = true
                    temArray[index] =  "\(GPWUser.sharedInstance().telephone ?? "0")+" + gesture
                }
            }
            if flag {
                tempStr = temArray.joined(separator: "@")
                UserDefaults.standard.setValue(tempStr, forKey: USERPHONEGETURE)
            }else{
                UserDefaults.standard.setValue(tempStr + "@\(GPWUser.sharedInstance().telephone ?? "0")+" + gesture, forKey: USERPHONEGETURE)
            }
            break
        case EditGesturepwType.delegate:
                for (index,str) in temArray.enumerated() {
                let  temSubArray = str.components(separatedBy: "+")
                    printLog(message: "\(temSubArray[0])     \(String(describing: GPWUser.sharedInstance().telephone))")
                if temSubArray[0] == GPWUser.sharedInstance().telephone {
                    tempIndex = index
                }
            }
            print(temArray)
            if tempIndex != -1 {
                temArray.remove(at: tempIndex)
            }
            tempStr = temArray.joined(separator: "@")
            UserDefaults.standard.setValue(tempStr, forKey: USERPHONEGETURE)
            GYCircleConst.saveGesture(nil, key: gestureFinalSaveKey)
            print(temArray)
            break
        case EditGesturepwType.change:
            break
        }
    }
    
    func toLoginController()  {
        self.editGesturePW(type: EditGesturepwType.delegate, gesture: "")
        GPWUser.sharedInstance().outLogin()
        let  loginController = GPWLoginViewController()
        loginController.flag = "1"
        loginController.setGestureFlag = "1"
        self.navigationController?.pushViewController(loginController, animated: true)
    }
}
