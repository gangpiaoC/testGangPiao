//
//  UserRewardViewController.swift
//  GangPiaoWang
//  我的奖励
//  Created by gangpiaowang on 2016/12/18.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class UserRewardViewController: GPWSecBaseViewController,LazyScrollViewDelegate {
    
     var _startIndex = 0
    
    //使用规则
    private var button:UIButton!
    let contentArray = [
        ["title":"红包","type":Useraccounts_myred],
        ["title":"加息券","type":User_ticket],
         ["title":"体验金","type":User_experient]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的奖励"
        self.addRightButton()
        let lazyScrollView = LazyScrollView(frame: self.bgView.bounds, delegate: self, dataArray: contentArray)
        lazyScrollView?.setTopOffSetWith(Int32(_startIndex))
        self.bgView.addSubview(lazyScrollView!)
    }
    private func addRightButton() {
        button = UIButton(type: .custom)
        button.frame = CGRect(x: SCREEN_WIDTH - 100, y: 23, width: 84, height: 40)
        button.setTitle("使用规则", for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.customFont(ofSize: 14)
        button.setTitleColor(UIColor.hex("666666"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        navigationBar.addSubview(button)
    }
    
    func rightAction()  {
        MobClick.event("mine_reward", label: "使用规则")
        self.navigationController?.pushViewController(GPWUserRUseRuleViewController(), animated: true)
    }
    
    func lazyView(at index: Int32) -> LazyScrollSubView! {
        let view = GPWUserRSubView(frame: self.bgView.bounds)
        view.inCtl = self
        return view
    }
    
    func lazyViewdidSelectTab(at index: Int32, subView: LazyScrollSubView!) {
        if index == 2 {
            button.isHidden = true
        }else{
            button.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

