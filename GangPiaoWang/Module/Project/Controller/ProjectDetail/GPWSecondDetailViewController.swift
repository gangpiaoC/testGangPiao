//
//  GPWSecondDetailViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate let menuHeight: CGFloat = 57
class GPWSecondDetailViewController: UIViewController, UIScrollViewDelegate {
    var refresh: (() -> Void)?
    var projectID: String!
    
    //起息方式
    var  rateMode = 1
    
    //票据类型
    var billType = 1
    
    private var dic:JSON?
    
    var titles = ["项目简介", "常见问题", "出借记录","还款计划"]
    lazy  var containerView: UIScrollView! = { [unowned self] in
        let containerView = UIScrollView(frame: CGRect(x: 0, y: menuHeight, width: self.view.bounds.width, height: self.view.bounds.height - menuHeight))
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return containerView
        }()
    lazy var menuView: UIView = {
        let menuView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width,height: menuHeight))
        menuView.backgroundColor = UIColor.white
        return menuView
    }()
    
    private let line = UIView()
    private(set) var viewControllers:  [GPWSubPageBaseViewController]!
    private(set) var menuViews = [UIButton]()
    private var currentSelectedMenu: UIButton!
    private var _currentIndex = 0
    var currentIndex: Int  {
        get {
            return _currentIndex
        }
        set {
            _currentIndex = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
    }
    
    func getData() {
        GPWNetwork.requetWithGet(url: Financing_details_jct, parameters: ["auto_id": projectID!, "type": 1], responseJSON: { [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            if json["start_interest"].stringValue == "融满后起息" {
                strongSelf.rateMode = 1
            }else{
                strongSelf.rateMode = 2
            }
            
            printLog(message: json["type"])
            if json["type"] == "YSZK"{
                strongSelf.billType = 2
            }else{
                strongSelf.billType = 1
            }
            strongSelf.dic = json
            strongSelf.initView()
            
            }, failure: { error in
                
        })

    }
    
    func initView() {
        if billType == 2 {
            titles = ["项目简介",  "出借记录","还款计划"]
        }
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        if containerView.superview == nil {
            view.addSubview(containerView)
        }
        
        containerView.bounces = false
        containerView.alwaysBounceHorizontal = false
        containerView.alwaysBounceVertical = false
        containerView.scrollsToTop = false
        containerView.delegate = self
        containerView.showsVerticalScrollIndicator = false
        containerView.showsHorizontalScrollIndicator = false
        containerView.isPagingEnabled = true
        
        let introduceVC = GPWProjectIntroduceVC()
        introduceVC.data = self.dic
        
        let  intrSecVC = GPWProjectInSecondVC()
        intrSecVC.data = self.dic
        
        let faqVC = GPWFAQViewController()
        faqVC.projectID = self.projectID
        
        let bidRecordVC = GPWBidRecordViewController()
        bidRecordVC.projectID = self.projectID
        
        if billType == 2 {
            viewControllers = [intrSecVC, bidRecordVC]
        }else{
            viewControllers = [introduceVC, faqVC, bidRecordVC]
        }
        
        
        for index in 0..<viewControllers.count {
            let viewController = viewControllers[index]
            viewController.refresh =  { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if let refresh = strongSelf.refresh {
                    refresh()
                }
            }
            
            
            let button = UIButton(type: .custom)
            let buttonWidth = view.frame.width / CGFloat(viewControllers.count)
            button.frame = CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: menuView.bounds.height)
            button.setTitle("\(titles[index])", for: .normal)
            button.setTitleColor(subTitleColor, for: .normal)
            button.setTitleColor(redTitleColor, for: .selected)
            button.titleLabel?.font = UIFont.customFont(ofSize: 16)
            button.backgroundColor = UIColor.clear
            button.tag = index + 10000
            button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
            menuView.addSubview(button)
            menuViews.append(button)
            
            if index == 1 || index == 2 {
                let verticalLine = UIView(frame: CGRect(x: CGFloat(index) * buttonWidth, y: 17, width: 1, height: 16))
                verticalLine.backgroundColor = UIColor.hex("d8d8d8")
                menuView.addSubview(verticalLine)
            }
            
        }
        
        line.frame = CGRect(x: view.frame.width / CGFloat(viewControllers.count) * 0.1, y: menuHeight - 9, width: view.frame.width / CGFloat(viewControllers.count) * 0.8, height: 1)
        line.backgroundColor = redTitleColor
        menuView.addSubview(line)
        
        let placehoderView = UIView(frame: CGRect(x: 0, y: line.maxY, width: view.frame.width, height: 8))
        placehoderView.backgroundColor = bgColor
        menuView.addSubview(placehoderView)
        
        view.addSubview(menuView)
        moveTo(index: currentIndex)
    }
    
    @objc private func join() {
        let isLogin = GPWUser.sharedInstance().isLogin
        if isLogin {
            if let is_idcard = GPWUser.sharedInstance().is_idcard {
                if is_idcard == 0 {
                    let infoVC = UserReadInfoViewController()
                    self.navigationController?.show(infoVC, sender: nil)
                } else {
                    let investVC = GPWInvestViewController(itemID: projectID)
                    investVC.title = parent?.title
                    self.navigationController?.show(investVC, sender: nil)
                }
            }
        } else {
            let loginVC = GPWLoginViewController()
            self.navigationController?.show(loginVC, sender: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.dic == nil {
            return
        }
        containerView.frame = CGRect(x: 0, y: menuHeight, width: self.view.bounds.width, height: self.view.bounds.height - menuHeight - 44)
        containerView.contentSize = CGSize(width: containerView.bounds.width * CGFloat(viewControllers.count), height: containerView.bounds.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonAction(button: UIButton) {
        moveTo(index: button.tag - 10000)
    }
    
    func pageOffsetForChild(at index: Int) -> CGFloat {
        return CGFloat(index) * containerView.bounds.width
    }
    
    func moveTo(index: Int) {
        if index == 0 {
            MobClick.event("project", label: "详情-项目简介")
        }else if index == 1 {
            if rateMode == 2 {
                MobClick.event("project", label: "详情-出借记录")
            }else{
                MobClick.event("project", label: "详情-常见问题")
            }
        }else if index == 2 {
            MobClick.event("project", label: "详情-出借记录")
        }
        let viewController = viewControllers[index]
        if viewController.parent != nil {
             viewController.beginAppearanceTransition(true, animated: false)
            viewController.view.frame = CGRect(x: pageOffsetForChild(at: index), y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewController.endAppearanceTransition()
        } else {
            addChildViewController(viewController)
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.view.frame = CGRect(x: pageOffsetForChild(at: index), y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
            viewController.endAppearanceTransition()
        }
       
        containerView.setContentOffset( CGPoint(x: pageOffsetForChild(at: index), y: 0), animated: true)
        if currentSelectedMenu != nil {
            currentSelectedMenu.isSelected = false
        }
        menuViews[index].isSelected = true
        currentSelectedMenu = menuViews[index]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let lineStartX = scrollView.contentOffset.x / containerView.bounds.width * view.frame.width / CGFloat(viewControllers.count)
        line.frame = CGRect(x: view.frame.width / CGFloat(viewControllers.count) * 0.1 +  lineStartX, y: menuHeight - 9, width: view.frame.width / CGFloat(viewControllers.count) * 0.85, height: 1)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = containerView.bounds.width
        let index =  Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)) + 1
        moveTo(index: index)
    }
    
}
