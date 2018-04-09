//
//  GPWGetFriendRcordController.swift
//  GangPiaoWang
//  new  邀请记录
//  Created by gangpiaowang on 2017/3/9.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWGetFriendRcordController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource  {
    private var showTableView:UITableView!
    private var page = 1
    private var dataArray =  [JSON]()
    //邀请数量
    private var inviteCount = 0
    
    //邀请码
    private var inviteCode = "0"
    
    //获利
    private var earned_amount = "0"
    
    //seccell  数据
    private var  secArray:[String]?
    
    //立即邀请链接
    private var inUrl:String?

    //是否没有数据 true  有  false  没有
    private  var noDataFlag:Bool?
    /// 懒加载
    fileprivate lazy var dataSource: [GPWFriendSectionModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邀请记录"
        secArray = [String]()
        dataArray = [JSON]()
        dataSource =  [GPWFriendSectionModel]()
        noDataFlag = true
        
        self.bgView.backgroundColor = UIColor.hex("15a4f4")
        
        showTableView = UITableView(frame: self.bgView.bounds , style: .plain)
        showTableView.delegate = self
        showTableView.dataSource = self
        showTableView.height = self.bgView.height - pixw(p: 44)
        showTableView.setUpFooterRefresh {
             self.showTableView.endFooterRefreshing()
        }
        showTableView.backgroundColor = UIColor.clear
        showTableView.separatorStyle = .none
        self.bgView.addSubview(showTableView)
        self.getNetData()
        
        //设置背景
        let  bgLayer = CALayer()
        bgLayer.contents = UIImage(named: "user_getfriends_bg")?.cgImage
        bgLayer.anchorPoint = CGPoint(x: 0, y: 0)
        bgLayer.bounds = self.bgView.bounds
        bgLayer.zPosition = -1
        showTableView.layer.addSublayer(bgLayer)
        
        //创建底部邀请好友按钮
        let  bottomBtn = UIButton(type: .custom)
        bottomBtn.frame = CGRect(x: 0, y: self.bgView.height - pixw(p: 44), width: SCREEN_WIDTH, height: pixw(p: 44))
        bottomBtn.backgroundColor = redColor
        bottomBtn.addTarget(self, action: #selector(shareYao), for: .touchUpInside)
        bottomBtn.titleLabel?.font = UIFont.customFont(ofSize: pixw(p: 18))
        bottomBtn.setTitle("邀请好友一起赚钱", for: .normal)
        self.bgView.addSubview(bottomBtn)
    }
    @objc func shareYao() {
        GPWShare.shared.shareYao()
    }
    override func getNetData() {
        GPWNetwork.requetWithGet(url: Api_my_invite, parameters: ["page":"\(page)"], responseJSON:  {
            [weak self] (json,msg) in
            guard let strongSelf = self else { return }
            printLog(message: json)
            if strongSelf.page == 1 {
                strongSelf.dataArray.removeAll()
                strongSelf.inviteCode = json["user_invite_code"].stringValue
                strongSelf.earned_amount = json["earned_amount"].stringValue
                strongSelf.secArray?.append("\(json["one_invitecount"])")
                strongSelf.secArray?.append("\(json["one_investamount"])")
                strongSelf.secArray?.append("\(json["direct_amount"])")
                strongSelf.secArray?.append("\(json["finvitecount"])")
                strongSelf.secArray?.append("\(json["secdamount"])")
                strongSelf.secArray?.append("\(json["fired_amount"])")
                strongSelf.secArray?.append("\(json["allcount"])")
                strongSelf.secArray?.append("\(json["all_investamount"])")
                strongSelf.secArray?.append("\(json["allamount"])")
                strongSelf.dataArray = json["info"].array!
                strongSelf.inUrl =  json["url"].stringValue
                if strongSelf.dataArray.count == 0 {
                    strongSelf.noDataImgView.isHidden = false
                    strongSelf.showTableView.setFooterNoMoreData()
                    strongSelf.noDataFlag = false
                     strongSelf.showTableView.footerRefresh.isHidden = false
                    strongSelf.showTableView.endFooterRefreshingWithNoMoreData()
                }else{
                    strongSelf.noDataImgView.isHidden = true
                    strongSelf.showTableView.footerRefresh.isHidden = false
                    strongSelf.page += 1
                    strongSelf.noDataFlag = true
                }
                GPWFriendSectionModel.loadData(dicArray:  strongSelf.dataArray, finish: { (models) in
                     strongSelf.dataSource = models
                    printLog(message:   strongSelf.dataSource)
                    strongSelf.showTableView.reloadData()
                    strongSelf.showTableView.endFooterRefreshing()
                    strongSelf.showTableView.endHeaderRefreshing()
                })
            }else{
                if (json["info"].arrayObject?.count)! > 0 {
                    strongSelf.dataArray = strongSelf.dataArray + json["info"].array!
                    strongSelf.page += 1
                     strongSelf.noDataFlag = true
                    GPWFriendSectionModel.loadData(dicArray:  strongSelf.dataArray, finish: { (models) in
                        strongSelf.dataSource = models
                        strongSelf.showTableView.reloadData()
                    })
                } else {
                     strongSelf.noDataFlag = false
                    strongSelf.showTableView.endFooterRefreshingWithNoMoreData()
                }
            }
            strongSelf.showTableView.reloadData()
            }, failure: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.showTableView.endFooterRefreshing()
                strongSelf.showTableView.endHeaderRefreshing()
        })
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 + dataSource!.count + (noDataFlag == false ? 0 : 1)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 3 {
            return 1
        }else if section < 3 + dataSource!.count{
             return (dataSource![section - 3].isExpanded != false) ? dataSource![section - 3].cellModels.count : 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
              return pixw(p: 188)
        } else if indexPath.section == 1 {
              return pixw(p: 234)
        }else if  indexPath.section == 2{
            return pixw(p: 88 + 28)
        }else if indexPath.section >= 3 + dataSource!.count {
            return pixw(p: 91)
        }
        return pixw(p: 40)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section < 3 {
            return 0.0001
        }else if section >= 3 + dataSource!.count {
            return pixw(p: 0.00001)
        }
        return pixw(p: 40)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < 3 || section >= 3 + dataSource!.count{
            return nil
        }else{
            var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GPWGetFriendsHeadView") as? GPWGetFriendsHeadView
            if headerView == nil {
                headerView = GPWGetFriendsHeadView.init(reuseIdentifier: "GPWGetFriendsHeadView")
            }
            headerView?.sectionModel = dataSource![section - 3]
            headerView!.expandCallBack = {
                (isExpanded: Bool) -> Void in
                tableView.reloadSections(NSIndexSet.init(index: section) as IndexSet, with: UITableViewRowAnimation.fade)
            }
            if  section % 2 == 0 {
                 headerView?.bgView.backgroundColor = UIColor.hex("e5f5fe")
            }else{
                 headerView?.bgView.backgroundColor = UIColor.white
            }
            return headerView!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWGetFriendsTopCell") as? GPWGetFriendsTopCell
            if cell == nil {
                cell = GPWGetFriendsTopCell(style: .default, reuseIdentifier: "GPWUserInvTopCell")
            }
            cell?.updata(code: self.inviteCode, money: self.earned_amount)
            return cell!
        }else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWGetFriendsSecCell") as? GPWGetFriendsSecCell
            if cell == nil {
                cell = GPWGetFriendsSecCell(style: .default, reuseIdentifier: "GPWUserInvTopCell")
            }
            cell?.updata(array: self.secArray!)
            return cell!
        }else if indexPath.section == 2{
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWGetFriendsThreeCell") as? GPWGetFriendsThreeCell
            if cell == nil {
                cell = GPWGetFriendsThreeCell(style: .default, reuseIdentifier: "GPWGetFriendsThreeCell")
            }
            return cell!
        }else if indexPath.section < 3 + dataSource!.count{
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWGetFriendsCell") as? GPWGetFriendsCell
            if cell == nil {
                cell = GPWGetFriendsCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "GPWGetFriendsCell")
            }
            cell?.cellModel = dataSource![indexPath.section - 3].cellModels[indexPath.row]
            if indexPath.row == 0 {
                cell?.showYaoType(flag:true)
            }else{
                cell?.showYaoType(flag:false)
            }
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWGetFriendsBottomCell") as? GPWGetFriendsBottomCell
            if cell == nil {
                cell = GPWGetFriendsBottomCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "GPWGetFriendsBottomCell")
            }
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.section >= 3 + (dataSource?.count)! {
            self.getNetData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


