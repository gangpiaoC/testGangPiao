//
//  GPWAvailableRateCouponViewController.swift
//  GangPiaoWang
//  确认投资界面  红包和加息券选择
//  Created by GC on 16/12/22.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWAvailableRateCouponViewController: GPWSecBaseViewController {
    var handleCoupon: ((RedEnvelop?, RateCoupon?) -> Void)?
    fileprivate var tableView: GPWTableView!
    fileprivate var rateCoupons = [RateCoupon]()
    fileprivate var redEnvelops = [RedEnvelop]()
    var currentRedEnvelop:RedEnvelop?
    var currentRateCoupon:RateCoupon?
    var currentAmount: Double = 0.0
    var deadLine: Int = 0
    
    init(redEnvelops: [RedEnvelop], rateCoupons: [RateCoupon], currentRedEnvelop: RedEnvelop?, currentRateCoupon: RateCoupon?, currentAmount: Double, deadLine: Int) {
        super.init(nibName: nil, bundle: nil)
        self.redEnvelops = redEnvelops
        self.rateCoupons = rateCoupons
        self.currentRedEnvelop = currentRedEnvelop
        self.currentRateCoupon = currentRateCoupon
        self.currentAmount = currentAmount
        self.deadLine = deadLine
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "优惠券"
       
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
        
        if currentRedEnvelop == nil && currentRateCoupon == nil {
             selectImgView.image = UIImage(named: "project_sure_selected")
        }
        tableView.tableHeaderView = headView
        bgView.addSubview(tableView)
    }
    
    @objc private func notUsed() {
        handleCoupon?(nil, nil)
        let _ = navigationController?.popViewController(animated: true)
        MobClick.event("biao", label: "不使用优惠券")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension GPWAvailableRateCouponViewController: GPWTableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
             return redEnvelops.count
        } else {
            return rateCoupons.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
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
        if indexPath.section == 0 { //红包
            let redEnvelop = redEnvelops[indexPath.row]
            if Int(redEnvelop.limit) ?? 300 >= deadLine && currentAmount >= Double(redEnvelop.restrict_amount) {
                handleCoupon?(redEnvelops[indexPath.row], nil)
            } else {
                bgView.makeToast("红包不可用")
                return
            }
        } else {  //加息
//            let rateCoupon = rateCoupons[indexPath.row]
//            if Int(rateCoupon.) ?? 300 >= deadLine {
//                handleCoupon?(redEnvelops[indexPath.row], nil)
//            } else {
//                bgView.makeToast("")
//            }
            handleCoupon?(nil, rateCoupons[indexPath.row])
        }
        let _ = navigationController?.popViewController(animated: true)
    }
}
