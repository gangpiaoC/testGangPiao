//
//  GPWBaseViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/24.
//  Copyright © 2016年 GC. All rights reserved.
//  说明：

import UIKit

class GPWBaseViewController: UIViewController {
    override var title: String? {
        willSet {
            self.navigationBar?.title = newValue
        }
    }
    open var navigationBar: GPWNavigationBar!
    var bgView: UIView = UIView()
    var noDataImgView:UIImageView!
    var isBarHidden: Bool = false
    {
        didSet {
             let navBarFrame = isBarHidden ? CGRect.zero : CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: 64.0)
             self.navigationBar.isHidden = isBarHidden
             self.bgView.frame = CGRect(x: 0.0, y: navBarFrame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - navBarFrame.height - 49)
        }
    }

    func getNetData(){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.view.backgroundColor = UIColor.white
        GPWUser.sharedInstance().getUserInfo()
        commonUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GPWGlobal.sharedInstance().currentViewController = self
        MobClick.beginLogPageView("\(self.classForCoder)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("\(self.classForCoder)")
    }
    
    fileprivate func commonUI() {

        var  navHeight:CGFloat = 64
        if SCREEN_HEIGHT == 812.0 {
            navHeight = 88
        }
        let navBarFrame = CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: navHeight)
        self.bgView.frame = CGRect(x: 0.0, y: navBarFrame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - navBarFrame.height - 49)
        self.bgView.backgroundColor = bgColor
        self.view.addSubview(self.bgView)
        
        noDataImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 76, height: 112))
        noDataImgView.centerX = SCREEN_WIDTH / 2
        noDataImgView.image = UIImage(named: "comm_noData")
        noDataImgView.centerY = SCREEN_HEIGHT / 2 - 60
        self.noDataImgView.isHidden = true
        self.bgView.addSubview(noDataImgView)
        
        self.navigationBar = GPWNavigationBar(frame: navBarFrame)
        self.navigationBar.title = self.title
        self.view.addSubview(self.navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

