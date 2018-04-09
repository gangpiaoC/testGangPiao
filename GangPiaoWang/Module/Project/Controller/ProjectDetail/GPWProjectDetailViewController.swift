//
//  GPWProjectDetailViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWProjectDetailViewController: GPWSecBaseViewController {
     lazy private var firstVC : GPWFirstDetailViewController = {[weak self] in
        let vc = GPWFirstDetailViewController()
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
        firstVC.superContoller = self
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
                    //self.navigationController?.show(infoVC, sender: nil)
                    self.navigationController?.pushViewController(infoVC, animated: true)
                } else {
                    MobClick.event("biao", label: "详情_立即加入")
                    if GPWUser.sharedInstance().show_iden == 0 {
                        //风险测评
                       self.goSafeController()
                    }else{
                        let investVC = GPWInvestViewController(itemID: projectID)
                        investVC.title = parent?.title
                        self.navigationController?.pushViewController(investVC, animated: true)
                        //                    self.navigationController?.show(investVC, sender: nil)
                    }
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

    //风险测评提示框
    func goSafeController() {
        let wid = UIApplication.shared.keyWindow

        let  bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bgView.backgroundColor = UIColor.hex("000000", alpha: 0.6)
        bgView.tag = 10001
        wid?.addSubview(bgView)

        let  tempBgView = UIView(frame: CGRect(x: 0, y: 0, width: 310, height: 204))
        tempBgView.layer.masksToBounds = true
        tempBgView.layer.cornerRadius = 5
        tempBgView.centerX = bgView.width / 2
        tempBgView.backgroundColor = UIColor.white
        tempBgView.center = CGPoint(x: bgView.width / 2, y: bgView.height / 2)
        bgView.addSubview(tempBgView)

        let  imgView = UIImageView(frame: CGRect(x: 0, y: 34, width: 92, height: 53))
        imgView.centerX = tempBgView.width / 2
        imgView.image = UIImage(named: "project_detail_fengxian")
        tempBgView.addSubview(imgView)

        let  temp1Label = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 24, width: tempBgView.width, height: 21))
        temp1Label.text = "先完成风险测评才可以出借"
        temp1Label.textAlignment = .center
        temp1Label.font = UIFont.customFont(ofSize: 18)
        temp1Label.textColor = UIColor.hex("333333")
        tempBgView.addSubview(temp1Label)


        let btn = UIButton(frame: CGRect(x: 0, y: tempBgView.height - 48, width: tempBgView.width / 2, height: 48))
        btn.setTitle("在看看", for: .normal)
        btn.tag = 1000
        btn.setTitleColor(UIColor.hex("666666"), for: .normal)
        btn.addTarget(self, action: #selector(self.safeClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 16)
        tempBgView.addSubview(btn)

        let goBtn = UIButton(frame: CGRect(x: tempBgView.width / 2, y: tempBgView.height - 48, width: tempBgView.width / 2, height: 48))
        goBtn.setTitle("立即前往", for: .normal)
        goBtn.setTitleColor(redTitleColor, for: .normal)
        goBtn.tag = 1001
        goBtn.addTarget(self, action: #selector(self.safeClick(_:)), for: .touchUpInside)
        goBtn.titleLabel?.font = UIFont.customFont(ofSize: 16)
        tempBgView.addSubview(goBtn)

        //横线
        let  horLine = UIView(frame: CGRect(x: 0, y: tempBgView.height - 48, width: tempBgView.width, height: 0.5))
        horLine.backgroundColor = UIColor.hex("e6e6e6")
        tempBgView.addSubview(horLine)

        //横线
        let  verLine = UIView(frame: CGRect(x: tempBgView.width / 2, y: tempBgView.height - 48, width: 0.5, height: 48))
        verLine.backgroundColor = UIColor.hex("e6e6e6")
        tempBgView.addSubview(verLine)
    }

    func safeClick(_ sender:UIButton) {
        UIApplication.shared.keyWindow?.viewWithTag(10001)?.removeFromSuperview()
        if sender.tag == 1000 {
            //取消
        }else{
            //去测评
             self.navigationController?.pushViewController(GPWRiskAssessmentViewController(), animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
