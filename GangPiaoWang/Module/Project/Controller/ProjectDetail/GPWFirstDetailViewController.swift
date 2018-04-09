//
//  GPWFirstDetailViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON

class GPWFirstDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate var isCanShare: Bool = false
    var refresh: (() -> Void)?
    var superContoller:GPWProjectDetailViewController?
    var tableView: UITableView!
    
    //起息方式  1融满起息  2立即起息
    var  rateMode = 1
    
    //是否隐藏满标奖励 1隐藏  0 展示
    var  isHiddenFull = 0
    
    private var cell2LeftText: [String] = ["起息方式", "还款方式", "温馨提示"]
    private var cell2RightText: [String] = ["立即起息", "一次性还本付息", "新手用户出借仅享有一次加息机会"]
    var projectID: String!
    var superController:GPWProjectDetailViewController?
    private var json: JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.sectionHeaderHeight = 0.001
        tableView.sectionFooterHeight = 0.001
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        self.tableView.register(GPWFirstDetailCell1.self, forCellReuseIdentifier: "cell1")
        self.tableView.register(GPWFirstDetailCell2_0.self, forCellReuseIdentifier: "cell2_0")
        self.tableView.register(GPWFirstDetailCell2_1.self, forCellReuseIdentifier: "cell2_1")
        self.tableView.register(GPWFirstDetailCell2.self, forCellReuseIdentifier: "cell2")
        self.tableView.register(GPWFirstDetailCell3.self, forCellReuseIdentifier: "cell3")
        self.tableView.register(GPWProjectIntroduceCell0.self, forCellReuseIdentifier: "cell4")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell5")
        self.tableView.register(GPWProjectIntroduceBottomCell.self, forCellReuseIdentifier: "GPWProjectIntroduceBottomCell")
        self.view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    fileprivate func requestData() {
        GPWNetwork.requetWithGet(url: Financing_details, parameters: ["auto_id": projectID], responseJSON: { [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.json = json
            strongSelf.superContoller?.title = json["title"].stringValue
            strongSelf.isCanShare = true
            strongSelf.isHiddenFull = 0
            if json["full_scale"]["close"].intValue == 0 {
                strongSelf.isHiddenFull = 1
            }
            
            if json["start_interest"].stringValue == "融满后起息" {
                strongSelf.rateMode = 1
            }else{
                strongSelf.rateMode = 2
            }
            strongSelf.cell2LeftText = ["起息方式", "还款方式"]
            strongSelf.cell2RightText = [json["start_interest"].stringValue, json["refund_type"].stringValue]
            
            if json["is_index"].intValue == 1 {
                if GPWUser.sharedInstance().staue == 0 {
                    strongSelf.cell2LeftText.append("温馨提示")
                    strongSelf.cell2RightText.append("新手用户出借仅享有一次加息机会")
                }
            }
            
            strongSelf.tableView.reloadData()
            guard let status = json["status"].string else {
                strongSelf.superController?.joinButton.isEnabled = false
                return
            }
            switch status {
            case "COLLECTING":
                strongSelf.superController?.joinButton.isEnabled = true
                strongSelf.superController?.joinButton.setBackgroundImage(UIImage(named: "project_right_pay"), for: .normal)
            case "FULLSCALE":
                strongSelf.superController?.joinButton.setTitle("已抢光", for: .normal)
                strongSelf.superController?.joinButton.setBackgroundImage(UIImage(named: ""), for: .normal)
                strongSelf.superController?.joinButton.backgroundColor = UIColor.hex("c3c3c3")
            case "REPAYING":
                strongSelf.superController?.joinButton.setTitle("回款中", for: .normal)
                strongSelf.superController?.joinButton.setBackgroundImage(UIImage(named: ""), for: .normal)
                strongSelf.superController?.joinButton.backgroundColor = UIColor.hex("c3c3c3")
            case "FINISH":
                strongSelf.superController?.joinButton.setTitle("已回款", for: .normal)
                strongSelf.superController?.joinButton.setBackgroundImage(UIImage(named: ""), for: .normal)
                strongSelf.superController?.joinButton.backgroundColor = UIColor.hex("c3c3c3")
            case "RELEASE":
                strongSelf.superController?.joinButton.setTitle("即将开始", for: .normal)
                strongSelf.superController?.joinButton.setBackgroundImage(UIImage(named: ""), for: .normal)
                strongSelf.superController?.joinButton.backgroundColor = UIColor.hex("fcc30c")
            default:
                strongSelf.superController?.joinButton.setTitle("已抢光", for: .normal)
                strongSelf.superController?.joinButton.setBackgroundImage(UIImage(named: ""), for: .normal)
                strongSelf.superController?.joinButton.backgroundColor = UIColor.hex("c3c3c3")
                break
            }
            if json["type"].string == "NEWBIE"{
                if GPWUser.sharedInstance().staue == 1 && GPWUser.sharedInstance().isLogin == true{
                    strongSelf.superController?.joinButton.isEnabled = false
                    strongSelf.superController?.joinButton.setTitle("新手标只能投一次", for: .normal)
                    strongSelf.superController?.joinButton.setBackgroundImage(UIImage(named: ""), for: .normal)
                    strongSelf.superController?.joinButton.backgroundColor = UIColor.hex("c3c3c3")
                }
            }
            }, failure: { error in
        })
    }
    
    func shareViewShow() {
        if !isCanShare {
            return
        }
        if let json = json {
            MobClick.event("biao", label: "分享")
            let title = json["share_title"].stringValue
            let subtitle = json["share_content"].stringValue
            let imgUrl = json["share_picture"].stringValue
            let toUrl = json["share_link"].stringValue
            GPWShare.shared.show(title: title, subtitle: subtitle, imgUrl: imgUrl, toUrl: toUrl)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = view.bounds.height - 44
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isHiddenFull == 1 {
            return 4
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 1
        }else if section == 1 - isHiddenFull {
            return 1
        }else if section == 2 - isHiddenFull{
            return 1
        }else if section == 3  - isHiddenFull {
            return self.cell2LeftText.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: GPWFirstDetailCell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! GPWFirstDetailCell1
            if let json = json {
                cell.setupCell(json)
            }
            return cell
        }else if indexPath.section == 1 - isHiddenFull {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath)
            cell.textLabel?.text = "满标奖励"
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.customFont(ofSize: 16)
            cell.textLabel?.textColor = UIColor.hex("666666")
            
            if cell.contentView.viewWithTag(10000) == nil {
                let  rightImbView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - 16 - 6, y: 0, width:  6, height:  11))
                rightImbView.image = UIImage(named: "user_rightImg")
                rightImbView.centerY = cell.contentView.height / 2
                cell.contentView.addSubview(rightImbView)
                
                let  detailLabel = UILabel(frame: CGRect(x: rightImbView.x - 50, y: 0, width: 80, height: 13))
                detailLabel.text = "领红包"
                detailLabel.textColor = redTitleColor
                detailLabel.tag = 10000
                detailLabel.font = UIFont.customFont(ofSize: 12)
                detailLabel.centerY = rightImbView.centerY
                cell.contentView.addSubview(detailLabel)
                
                let  detailImgView = UIImageView(frame: CGRect(x: detailLabel.x - 5 - 18, y: 19, width: 18, height: 19))
                detailImgView.image = UIImage(named: "project_investRedEnvelop")
                detailImgView.centerY = rightImbView.centerY
                cell.contentView.addSubview(detailImgView)
            }
            return cell
        }else if indexPath.section == 2 - isHiddenFull{
            if rateMode == 1 {
                let cell: GPWFirstDetailCell2_0 = tableView.dequeueReusableCell(withIdentifier: "cell2_0", for: indexPath) as! GPWFirstDetailCell2_0
                cell.updata(self.json?["daytime"].stringValue ?? " ", self.json?["dayfulltime"].stringValue ?? " ",self.json?["daytimeout"].stringValue ?? " ")
                return cell
            }else{
                let cell: GPWFirstDetailCell2_1 = tableView.dequeueReusableCell(withIdentifier: "cell2_1", for: indexPath) as! GPWFirstDetailCell2_1
                cell.updata(self.json?["daytime"].stringValue ?? "", self.json?["dayfulltime"].stringValue ?? " ",self.json?["daytimeout"].stringValue ?? " ")
                return cell
            }
        }else if indexPath.section == 3 - isHiddenFull {
            let cell: GPWFirstDetailCell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! GPWFirstDetailCell2
            cell.setupCell(["left": cell2LeftText[indexPath.row], "right": cell2RightText[indexPath.row]], index: indexPath.row, superVC: self)
            if indexPath.row == 2 && rateMode == 1{
                cell.markButton.isHidden = true
            } else {
                cell.markButton.isHidden = true
            }
            return cell
        } else {
            
            //取消
            if rateMode == 0 {
                let cell: GPWProjectIntroduceBottomCell = tableView.dequeueReusableCell(withIdentifier: "GPWProjectIntroduceBottomCell", for: indexPath) as! GPWProjectIntroduceBottomCell
                return cell
            }else{
                let cell: GPWProjectIntroduceBottomCell = tableView.dequeueReusableCell(withIdentifier: "GPWProjectIntroduceBottomCell", for: indexPath) as! GPWProjectIntroduceBottomCell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 && isHiddenFull == 0 {
            return 8
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && isHiddenFull == 0{
            MobClick.event("project", label: "详情-满标奖励")
            let vc = GPWDetailFullBiaoViewController(para: (self.json?["full_scale"])!)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 2 - isHiddenFull && rateMode == 1{
            self.navigationController?.pushViewController(GPWProjectIRuleController(), animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffsetY = scrollView.contentOffset.y
        if(contentOffsetY > 0 && contentOffsetY > (scrollView.contentSize.height - scrollView.bounds.size.height + 20))
        {
            if let refresh = refresh {
                refresh()
            }
        }
    }
    
}
