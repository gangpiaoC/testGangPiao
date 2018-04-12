//
//  GPWProjectDetailViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON

class GPWProjectDetailViewController: GPWSecBaseViewController {
    private let projectID: String
    
    fileprivate var isCanShare: Bool = false
    private var json: JSON?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.sectionFooterHeight = 0.001
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.register(GPWFirstDetailCell1.self, forCellReuseIdentifier: "cell1")
        tableView.register(GPWFirstDetailCell2.self, forCellReuseIdentifier: "cell2")
        tableView.register(GPWFirstDetailCell3.self, forCellReuseIdentifier: "cell3")
        tableView.register(GPWFirstDetailCell4.self, forCellReuseIdentifier: "cell4")
        return tableView
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString.attributedString("剩余金额 ", mainColor: titleColor, mainFont: 14, second: "1000元", secondColor: redColor, secondFont: 14)
        return label
    }()
    let joinButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("即将开放  敬请期待", for: .normal)
        button.titleLabel?.font = UIFont.customFont(ofSize: 18.0)
        button.backgroundColor = UIColor.hex("f9bd59")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(join), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    init(projectID: String) {
        self.projectID = projectID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        bgView.addSubview(tableView)
        
        let bottomView = UIView(bgColor: .white)
        bottomView.addSubview(balanceLabel)
        bottomView.addSubview(joinButton)
        bgView.addSubview(bottomView)
        
        tableView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(bgView)
            maker.width.equalTo(bgView)
        }
        
        bottomView.snp.makeConstraints { (maker) in
            maker.top.equalTo(tableView.snp.bottom)
            maker.left.right.bottom.equalTo(bgView)
        }
        
        balanceLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(bottomView).offset(20)
            maker.left.right.equalTo(bottomView)
        }
        
        joinButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(balanceLabel.snp.bottom).offset(12)
            maker.left.right.equalTo(bottomView).inset(16)
            maker.bottom.equalTo(bottomView).offset(-16)
            maker.height.equalTo(46)
        }
    }
    
    @objc private func join() {
        let isLogin = GPWUser.sharedInstance().isLogin
        if isLogin {
            if let is_idcard = GPWUser.sharedInstance().is_idcard {
                if is_idcard == 0 {
                    let infoVC = UserReadInfoViewController()
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
                    }
                }
            }
        } else {
            let loginVC = GPWLoginViewController()
            self.navigationController?.show(loginVC, sender: nil)
        }
    }
    
    private func setupNavigationBar() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: SCREEN_WIDTH  - 40, y: 23, width: 40, height: 40)
        button.setImage(#imageLiteral(resourceName: "project_detail_share"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "project_detail_share"), for: .highlighted)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        navigationBar.addSubview(button)
        navigationBar.backgroundColor = redColor
        navigationBar.titleLabel.textColor = UIColor.white
        navigationBar.isLineHidden = true
        
        let size = CGSize(width: 60, height: 44)
        let scaleImage = #imageLiteral(resourceName: "nav_left_wite").imageWithContentSize(size: size, drawInRect: CGRect(x: 16, y: 14, width: 8, height: 16))
        self.leftButton.setBackgroundImage(scaleImage, for: .normal)
        self.leftButton.setBackgroundImage(scaleImage, for: .highlighted)
    }
    
    @objc private func share() {
        shareViewShow()
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
    
    @objc func safeClick(_ sender:UIButton) {
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

extension GPWProjectDetailViewController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func requestData() {
        GPWNetwork.requetWithGet(url: Financing_details, parameters: ["auto_id": projectID], responseJSON: { [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.json = json
            strongSelf.title = json["title"].stringValue
            strongSelf.isCanShare = true
            
            strongSelf.tableView.reloadData()
            guard let status = json["status"].string else {
                strongSelf.joinButton.isEnabled = false
                return
            }
            strongSelf.balanceLabel.attributedText = NSAttributedString.attributedString("募集总额 ", mainColor: titleColor, mainFont: 14, second: "\(json["amount"].stringValue)元", secondColor: redColor, secondFont: 14)
            switch status {
            case "COLLECTING":
                strongSelf.joinButton.isEnabled = true
                strongSelf.joinButton.setTitle("立即加入", for: .normal)
                strongSelf.joinButton.backgroundColor = redColor
                strongSelf.balanceLabel.attributedText = NSAttributedString.attributedString("剩余金额 ", mainColor: titleColor, mainFont: 14, second: "\(json["balance_amount"].stringValue)元", secondColor: redColor, secondFont: 14)
            case "FULLSCALE", "REPAYING", "FINISH":
                strongSelf.joinButton.setTitle("已满标", for: .normal)
                strongSelf.joinButton.backgroundColor = UIColor.hex("d8d8d8")
            case "RELEASE":
                strongSelf.joinButton.setTitle("即将开放  敬请期待", for: .normal)
                strongSelf.joinButton.backgroundColor = UIColor.hex("f9bd59")
            default:
                strongSelf.joinButton.setTitle("已抢光", for: .normal)
                strongSelf.joinButton.setBackgroundImage(UIImage(named: ""), for: .normal)
                strongSelf.joinButton.backgroundColor = UIColor.hex("c3c3c3")
                break
            }
//            if json["type"].string == "NEWBIE"{
//                if GPWUser.sharedInstance().staue == 1 && GPWUser.sharedInstance().isLogin == true{
//                    strongSelf.joinButton.isEnabled = false
//                    strongSelf.joinButton.setTitle("新手标只能投一次", for: .normal)
//                    strongSelf.joinButton.setBackgroundImage(UIImage(named: ""), for: .normal)
//                    strongSelf.joinButton.backgroundColor = UIColor.hex("c3c3c3")
//                }
//            }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 1 {
            return 2
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
        } else if indexPath.section == 1 {
            let cell: GPWFirstDetailCell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! GPWFirstDetailCell2
            if let json = json {
                let array = [
                    ["img": #imageLiteral(resourceName: "project_detail_ asset"), "text": json["ZC"].stringValue],
                    ["img": #imageLiteral(resourceName: "project_detail_safe"), "text": json["HF"].stringValue]
                ]
                cell.setupCell(dict: array[indexPath.row])
            }
            if indexPath.row == 1 {
                cell.lineView.isHidden = true
            } else {
                cell.lineView.isHidden = false
            }
            return cell
        } else if indexPath.section == 2 {
            let cell: GPWFirstDetailCell3 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! GPWFirstDetailCell3
            if let json = json {
                cell.setupCell(day: json["deadline"].stringValue, returnStr: json["WYL"].stringValue)
            }
            return cell
        } else {
            let cell: GPWFirstDetailCell4 = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! GPWFirstDetailCell4
            cell.tapAction = { [weak self] (index) in
                guard let strongSelf = self else { return }
                guard let json = strongSelf.json else {
                    strongSelf.bgView.makeToast("数据异常")
                    return
                }
                switch index {
                case 0:    //项目详情
                    let vc = GPWWebViewController(subtitle: "", url: json["details_link"].stringValue)
                    strongSelf.navigationController?.show(vc, sender: nil)
                case 1:   //风险控制
                    let vc = GPWWebViewController(subtitle: "", url: json["risk_link"].stringValue)
                    strongSelf.navigationController?.show(vc, sender: nil)
                case 2:     //加入记录
                    let vc = GPWProjectDetailAddRecordViewController(projectID: json["auto_id"].stringValue)
                    strongSelf.navigationController?.show(vc, sender: nil)
                default:
                    break
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(bgColor: UIColor.hex("f4f4f4"))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        }
        return 10
    }
}
