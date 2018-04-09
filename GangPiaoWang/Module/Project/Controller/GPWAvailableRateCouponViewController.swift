//
//  GPWAvailableRateCouponViewController.swift
//  GangPiaoWang
//  确认投资界面  红包和加息券选择
//  Created by GC on 16/12/22.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

enum GPWAvailableType: Int {
    
    //红包
    case REDBAG = 1
    
    //加息券
    case RATECOPU
}

class GPWAvailableRateCouponViewController: GPWSecBaseViewController {
    var handleRateCouponUsed: ((_ rateCoupon: RateCoupon?, _ isUse: Bool) -> Void)?
    var handleRedEnvelopUsed: ((_ redEnvelop: RedEnvelop?, _ isUse: Bool) -> Void)?
    fileprivate var tableView: GPWTableView!
    fileprivate var rateCoupons = [RateCoupon]()
    fileprivate var redEnvelops = [RedEnvelop]()
    var currentRedEnvelop:RedEnvelop?
    var currentRateCoupon:RateCoupon?
    
    fileprivate var type:GPWAvailableType!
    
    init(_ redEnvelops: [RedEnvelop]) {
        super.init(nibName: nil, bundle: nil)
        self.redEnvelops = redEnvelops
        self.type = .REDBAG
    }
    
    init(_ rateCoupons: [RateCoupon]) {
        super.init(nibName: nil, bundle: nil)
        self.rateCoupons = rateCoupons
        self.type = .RATECOPU
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .REDBAG {
            self.title = "可用红包"
        }else{
             self.title = "可用加息券"
        }
       
        tableView = GPWTableView(frame: self.bgView.bounds, delegate: self)
        tableView.register(GPWAvailableRateCouponCell.self, forCellReuseIdentifier: "RateCouponCell")
        tableView.register(GPWUserRBCell.self, forCellReuseIdentifier: "GPWUserRBCell")
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 70))
        headView.backgroundColor = UIColor.clear
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3
        button.frame = CGRect(x: 16, y: 16, width: tableView.bounds.width - 32, height: 44)
        button.addTarget(self, action: #selector(notUsed), for: .touchUpInside)
        headView.addSubview(button)
        
        //不使用
        let  noUseLabel = UILabel(frame: CGRect(x: 18, y: 0, width: 200, height: button.height))
        noUseLabel.textColor = UIColor.hex("333333")
        noUseLabel.text = "不使用"
        noUseLabel.font = UIFont.customFont(ofSize: 16)
        button.addSubview(noUseLabel)
        
        let  selectImgView = UIImageView(frame: CGRect(x: button.width - 16 - 18, y: 0, width: 18, height: 18))
        selectImgView.image = UIImage(named: "project_sure_select")
        selectImgView.centerY = noUseLabel.centerY
        button.addSubview(selectImgView)
        
        if type == .REDBAG {
            if currentRedEnvelop == nil {
                 selectImgView.image = UIImage(named: "project_sure_selected")
            }
        }else{
            if currentRateCoupon == nil {
                selectImgView.image = UIImage(named: "project_sure_selected")
            }
        }
        tableView.tableHeaderView = headView
        bgView.addSubview(tableView)
    }
    
    @objc private func notUsed() {
        if type == .REDBAG {
            MobClick.event("biao", label: "无红包")
            if let handle = handleRedEnvelopUsed {
                handle(nil, false)
                let _ = navigationController?.popViewController(animated: true)
            }
        }else{
            MobClick.event("biao", label: "无加息券")
            if let handle = handleRateCouponUsed {
                handle(nil, false)
                let _ = navigationController?.popViewController(animated: true)
            }
        }
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension GPWAvailableRateCouponViewController: GPWTableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .REDBAG {
             return redEnvelops.count
        }else{
            return rateCoupons.count
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if type == .REDBAG {
            return 136
        }else{
             return 116
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if type == .REDBAG {
            
            let cell: GPWUserRBCell = tableView.dequeueReusableCell(withIdentifier: "GPWUserRBCell", for: indexPath) as! GPWUserRBCell
            cell.setupCell(redEnvelops[indexPath.row], selectFlag: currentRedEnvelop == nil ? false : (currentRedEnvelop?.auto_id == redEnvelops[indexPath.row].auto_id ? true : false))
            return cell
        }else{
            let cell: GPWAvailableRateCouponCell = tableView.dequeueReusableCell(withIdentifier: "RateCouponCell", for: indexPath) as! GPWAvailableRateCouponCell
            cell.setupCell(rateCoupons[indexPath.row], selectFlag: currentRateCoupon == nil ? false : (currentRateCoupon?.auto_id == rateCoupons[indexPath.row].auto_id ? true : false))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == .REDBAG {
            if let handle = handleRedEnvelopUsed {
                handle(redEnvelops[indexPath.row], true)
                let _ = navigationController?.popViewController(animated: true)
            }
        }else{
            if let handle = handleRateCouponUsed {
                handle(rateCoupons[indexPath.row], true)
                let _ = navigationController?.popViewController(animated: true)
            }
        }
    }
}
