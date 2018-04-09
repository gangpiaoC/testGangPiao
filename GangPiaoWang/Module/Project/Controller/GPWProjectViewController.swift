//
//  GPWProjectViewController.swift
//  GangPiaoWang
// we 
//  Created by GC on 16/11/25.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON

class GPWProjectViewController: GPWBaseViewController, GPWTableViewDelegate {
    var tableView: GPWTableView!
    fileprivate var dataDic:JSON?
    fileprivate var gpy_count:Int?
//            ["title":"银行存管","img":""],
    fileprivate var titleArray = [
        ["title":"钢票盈","img":"project_list_gpy"],
        ["title":"钢融宝","img":"project_list_yszk"],
        ["title":"体验标","img":"project_list_tyb"]
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gpy_count = 0
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNetData()
    }
    
    private func commonInit() {
        self.tableView = GPWTableView(frame: self.bgView.bounds, delegate: self)
        self.tableView.register(GPWProjectCell.self, forCellReuseIdentifier: "GPWProjectCell")
        self.tableView.register(GPWListTopCell.self, forCellReuseIdentifier: "GPWListTopCell")
        self.bgView.addSubview(self.tableView)
        
        tableView.setUpHeaderRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getNetData()
        }
        
    }
    
    override func getNetData() {
        GPWNetwork.requetWithGet(url: Financing_lists, parameters:nil, responseJSON:  {
            [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.dataDic = json
            strongSelf.gpy_count = json["gpy_count"].intValue
            if strongSelf.gpy_count == 0 {
                strongSelf.titleArray.removeAll()
//                strongSelf.titleArray.append( ["title":"银行存管","img":""])
                strongSelf.titleArray.append(["title":"钢融宝","img":"project_list_yszk"])
                strongSelf.titleArray.append(["title":"钢票盈","img":"project_list_gpy"])
                strongSelf.titleArray.append(["title":"体验标","img":"project_list_tyb"])
            }
            strongSelf.tableView.endHeaderRefreshing()
            strongSelf.tableView.reloadData()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.tableView.endHeaderRefreshing()
        })
    }
}

extension GPWProjectViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataDic != nil {
            return 3
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        if section == 0 {
//            return 1
//        }else
        if section == 0 {
            if self.gpy_count == 0 {
                //钢融宝
                return (dataDic!["steel_melt"].array?.count ?? 1) + 1
            }else{
                //钢票盈
                return (dataDic!["steel_ticket"].array?.count ?? 1) + 1
            }
        }else if section == 1 {
            if self.gpy_count == 0 {
                //钢票盈
                return (dataDic!["steel_ticket"].array?.count ?? 1) + 1
            }else{
                //钢融宝
                return (dataDic!["steel_melt"].array?.count ?? 1) + 1
            }
        }else{
            //体验金
            return (dataDic!["tiyan"].array?.count ?? 1) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
             let cell: GPWListTopCell = tableView.dequeueReusableCell(withIdentifier: "GPWListTopCell", for: indexPath) as! GPWListTopCell
//            if indexPath.section == 0 {
//                cell.setupdata(false,titleArray[indexPath.section]["title"]!, true, false, "")
//            }else

            if indexPath.section == 2{
                 cell.setupdata(true,titleArray[indexPath.section]["title"]!, true, true, titleArray[indexPath.section]["img"]!)
            }else{
                cell.setupdata(true,titleArray[indexPath.section]["title"]!, false, false, titleArray[indexPath.section]["img"]!)
            }
            return cell
        }else{
            let cell: GPWProjectCell = tableView.dequeueReusableCell(withIdentifier: "GPWProjectCell", for: indexPath) as! GPWProjectCell
            var  tempStr = "steel_melt"
            if  indexPath.section == 0 {
                if self.gpy_count! > 0 {
                    tempStr = "steel_ticket"
                }else{
                    tempStr = "steel_melt"
                }
            }else if  indexPath.section == 1 {
                if self.gpy_count! > 0 {
                    tempStr = "steel_melt"
                }else{
                    tempStr = "steel_ticket"
                }
            }else if indexPath.section == 2 {
                tempStr = "tiyan"
            }
            cell.setupCell(dict: (dataDic?[tempStr][indexPath.row - 1])!)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            switch indexPath.section {
//            case 0:
//                printLog(message: "银行介绍")
//                 MobClick.event("project", label: "菜单栏-拼手气-点击")
//                self.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url: self.dataDic?["bank_url"].stringValue ?? ""), animated: true)
//                break

            case 0:
                let  vcControl = GPWProjectTypeController()
                if self.gpy_count! > 0 {
                    vcControl.type = "GENERAL"
                     MobClick.event("project", label: "票据-更多")
                }else{
                    vcControl.type = "YSZK"
                    MobClick.event("project", label: "应收账款-更多")
                }
                
                self.navigationController?.pushViewController(vcControl, animated: true)
                break
                
            case 1:
                let  vcControl = GPWProjectTypeController()
                if self.gpy_count! > 0 {
                    vcControl.type = "YSZK"
                    MobClick.event("project", label: "票据")
                }else{
                    vcControl.type = "GENERAL"
                    MobClick.event("project", label: "票据-应收账款")
                }
                self.navigationController?.pushViewController(vcControl, animated: true)
                break
         
            case 2:
               printLog(message: "体验标")
                break
            default:
                break
            }
        }else{
            
            var  tempStr = "steel_melt"
            if  indexPath.section == 0 {
                if self.gpy_count! > 0 {
                    tempStr = "steel_ticket"
                }else{
                    tempStr = "steel_melt"
                }
            }else if  indexPath.section == 1 {
                if self.gpy_count! > 0 {
                    tempStr = "steel_melt"
                }else{
                    tempStr = "steel_ticket"
                }
            }else if indexPath.section == 2 {
                tempStr = "tiyan"
            }
            
            let projectID = self.dataDic?[tempStr][indexPath.row-1]["auto_id"] ?? 0
            printLog(message: projectID)
            if indexPath.section == 2 {
                MobClick.event("project", label: "体验标")
                self.navigationController?.pushViewController(GPWHomeTiyanViewController(tiyanID:"\(projectID)"), animated: true)
            }else{
                if tempStr == "steel-ticket" {
                    MobClick.event("project", label: "票据")
                }else{
                    MobClick.event("project", label: "应收账款")
                }
                let vc = GPWProjectDetailViewController(projectID: "\(String(describing: projectID))")
                vc.title =  self.dataDic?[tempStr][indexPath.row-1]["title"].string
                self.navigationController?.show(vc, sender: nil)
            }
        }
    }
}
