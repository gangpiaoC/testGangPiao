//
//  GPWProjectDetailViewController.swift
//  GangPiaoWang
//  vip详情
//  Created by GC on 16/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWVipPDetailViewController: GPWSecBaseViewController {
    lazy private var firstVC : GPWVipFDetailViewController = {[weak self] in
        let vc = GPWVipFDetailViewController()
        return vc
        }()
    
    lazy private var secondVC: GPWSecondDetailViewController = { [weak self] in
        let vc = GPWSecondDetailViewController()
        vc.projectID = self?.projectID
        return vc
        }()
    lazy var scrollView:UIScrollView = {
        var scrollView:UIScrollView = UIScrollView(frame:  CGRect(x: 0,y: 0,width: self.bgView.bounds.size.width,height: self.bgView.bounds.size.height))
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        scrollView.contentSize = CGSize(width: self.bgView.bounds.width, height: self.bgView.bounds.height * 2)
        return scrollView
    }()
    
    lazy var firstSubView: UIView = {
        var view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.bgView.bounds.size.width, height: self.bgView.bounds.size.height))
        return view
    }()
    
    lazy var secondSubView: UIView = {
        var view: UIView = UIView(frame: CGRect(x: 0,y: self.bgView.bounds.size.height,width: self.bgView.bounds.size.width,height: self.bgView.bounds.size.height))
        return view
    }()
    
    private var projectID: String!
    
    var joinButton: UIButton!
    init(projectID: String) {
        super.init(nibName: nil, bundle: nil)
        self.projectID = projectID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShareButton()
        
        bgView.addSubview(scrollView)
        scrollView.addSubview(firstSubView)
        scrollView.addSubview(secondSubView)
        
        firstVC.projectID = projectID
        firstVC.superController = self
        secondVC.projectID = projectID
        
        firstVC.superController = self
        firstVC.refresh = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.secondVC.parent != nil {
                strongSelf.secondVC.view.frame = strongSelf.secondSubView.bounds
            } else {
                strongSelf.addChildViewController(strongSelf.secondVC)
                strongSelf.secondVC.view.frame = strongSelf.secondSubView.bounds
                strongSelf.secondSubView.addSubview(strongSelf.secondVC.view)
                strongSelf.secondVC.didMove(toParentViewController: strongSelf)
            }
            strongSelf.secondVC.refresh =  { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let contentOffset = CGPoint.zero
                strongSelf.scrollView.setContentOffset(contentOffset, animated: true)
            }
            let contentOffset = CGPoint(x: 0, y: strongSelf.bgView.bounds.height)
            strongSelf.scrollView.setContentOffset(contentOffset, animated: true)
        }
        self.addChildViewController(firstVC)
        firstVC.view.frame = firstSubView.bounds
        firstSubView.addSubview(firstVC.view)
        firstVC.didMove(toParentViewController: self)
        joinButton = UIButton(type: .custom)
        joinButton.setTitle("立即加入", for: .normal)
        joinButton.frame = CGRect(x: 0, y: self.bgView.height - 44, width: SCREEN_WIDTH, height: 44)
        joinButton.titleLabel?.font = UIFont.customFont(ofSize: 18.0)
        joinButton.setBackgroundImage(UIImage(named: "project_right_pay"), for: .normal)
        joinButton.addTarget(self, action: #selector(join), for: .touchUpInside)
        joinButton.isEnabled = false
        bgView.addSubview(joinButton)
    }
    
    @objc private func join() {
        let isLogin = GPWUser.sharedInstance().isLogin
        if isLogin {
            if let is_idcard = GPWUser.sharedInstance().is_idcard {
                if is_idcard == 0 {
                    let infoVC = UserReadInfoViewController()
                    self.navigationController?.show(infoVC, sender: nil)
                } else {
                    MobClick.event("biao", label: "详情_立即加入")
                    let investVC = GPWInvestViewController(itemID: projectID)
                    investVC.title = parent?.title
                    investVC.vipFlag = true
                    self.navigationController?.show(investVC, sender: nil)
                }
            }
        } else {
            let loginVC = GPWLoginViewController()
            self.navigationController?.show(loginVC, sender: nil)
        }
    }
    
    private func addShareButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: SCREEN_WIDTH  - 40, y: 23, width: 40, height: 40)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.setImage(UIImage(named: "share"), for: .selected)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        navigationBar.addSubview(button)
    }
    
    @objc private func share() {
        firstVC.shareViewShow()
    }
    
    deinit {
        printLog(message: "release")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
