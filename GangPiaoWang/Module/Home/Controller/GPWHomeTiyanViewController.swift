//
//  GPWHomeTiyanViewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHomeTiyanViewController: GPWSecBaseViewController,UITableViewDelegate, UITableViewDataSource {
    var showTableView:UITableView!
    var tiyanid:String?
    var dic:JSON?
    fileprivate var isCanShare: Bool = false
    
    //初始化
    init(tiyanID:String) {
        super.init(nibName: nil, bundle: nil)
        self.tiyanid = tiyanID
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getNetData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "体验标"
        self.showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        self.showTableView.dataSource = self
        self.showTableView.delegate = self
        self.showTableView.sectionFooterHeight = 0.001
        self.showTableView.sectionHeaderHeight = 0.0001
        self.showTableView.rowHeight = UITableViewAutomaticDimension
        self.showTableView.estimatedRowHeight = 80.0
        self.showTableView.separatorStyle = .none
        self.showTableView.backgroundColor = UIColor.clear
        self.bgView.addSubview(showTableView)
        self.showTableView.register(GPWHTTopCell.self, forCellReuseIdentifier: "GPWHTTopCell")
        self.showTableView.register(GPWHTSecCell.self, forCellReuseIdentifier: "GPWHTSecCell")
        self.showTableView.register(GPWHTOtherCell.self, forCellReuseIdentifier: "GPWHTOtherCell")
        self.showTableView.register(GPWHTLCell.self, forCellReuseIdentifier: "GPWHTLCell")
        addShareButton()
        self.getNetData()
        }
    
    override func  getNetData()  {
        GPWNetwork.requetWithPost(url: Exper_details, parameters: ["exper_id":self.tiyanid!], responseJSON:  { [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.dic = json
            printLog(message: json)
            strongSelf.title = json["exper_name"].stringValue
            printLog(message: strongSelf.dic)
            strongSelf.isCanShare = true
            strongSelf.showTableView.reloadData()
            } , failure: { error in
                printLog(message: error)
        })
    }
    
    //添加分享按钮
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
        if !isCanShare {
            return
        }
        if let json = dic {
            MobClick.event("index_experience_biao", label: "分享")
            let title = json["share_title"].stringValue
            let subtitle = json["share_content"].stringValue
            let imgUrl = json["share_picture"].stringValue
            let toUrl = json["share_link"].stringValue
            GPWShare.shared.show(title: title, subtitle: subtitle, imgUrl: imgUrl, toUrl: toUrl)
        }
    }
    
}
extension GPWHomeTiyanViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dic == nil {
            return 0
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
             let cell: GPWHTTopCell = tableView.dequeueReusableCell(withIdentifier: "GPWHTTopCell", for: indexPath) as! GPWHTTopCell
            cell.setupCell(self.dic!)
            return cell
        } else if indexPath.section == 1 {
             let cell: GPWHTSecCell = tableView.dequeueReusableCell(withIdentifier: "GPWHTSecCell", for: indexPath) as! GPWHTSecCell
            cell.updata(dic: dic!, superControl: self)
            return cell
        } else if indexPath.section == 2 {
            let cell: GPWHTLCell = tableView.dequeueReusableCell(withIdentifier: "GPWHTLCell", for: indexPath) as! GPWHTLCell
            return cell
        } else {
             let cell: GPWHTOtherCell = tableView.dequeueReusableCell(withIdentifier: "GPWHTOtherCell", for: indexPath) as! GPWHTOtherCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {

            if GPWUser.sharedInstance().isLogin {
                self.navigationController?.pushViewController(GPWHTLController(), animated: true)
                printLog(message: "去往投资记录")
            }else{
                self.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
            }
        }
    }
}
