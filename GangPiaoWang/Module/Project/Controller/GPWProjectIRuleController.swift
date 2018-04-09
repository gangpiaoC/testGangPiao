//
//  GPWProjectIRuleController.swift
//  GangPiaoWang
// 计息规则
//  Created by gangpiaowang on 2017/3/21.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWProjectIRuleController: GPWSecBaseViewController ,GPWTableViewDelegate{
    private var tableView: GPWTableView!
    let contArray = [
    "钢票网对募集期标的进行站岗利息补贴。",
    "站岗利息计算公式=出借金额X年化利率X(满标日期-出借日期)/365。",
    "站岗利息补贴的利率与所投标的利率一致。",
    "募集期如果资金没有募集完成，则为流标，用户本金和产生收益退回账户余额。",
    "出借成功后，在未满标的状态下，回款时间不显示，满标后显示回款时间。",
    "站岗利息补贴在项目回款时一起发放。"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "利息补贴"
        self.tableView = GPWTableView(frame: self.bgView.bounds, delegate: self)
        
        self.tableView.register(GPWRuleTopCell.self, forCellReuseIdentifier: "GPWRuleTopCell")
        self.tableView.register(GPWRuleContentCell.self, forCellReuseIdentifier: "GPWRuleContentCell")
        self.tableView.register(GPWRuleBottomCell.self, forCellReuseIdentifier: "GPWRuleBottomCell")
        self.bgView.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension GPWProjectIRuleController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return contArray.count
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 8
        }else{
            return 0.00001
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: GPWRuleTopCell = tableView.dequeueReusableCell(withIdentifier: "GPWRuleTopCell", for: indexPath) as! GPWRuleTopCell
            return cell
        }else  if indexPath.section == 1{
            let cell: GPWRuleContentCell = tableView.dequeueReusableCell(withIdentifier: "GPWRuleContentCell", for: indexPath) as! GPWRuleContentCell
            cell.updata(index: indexPath.row + 1, content: self.contArray[indexPath.row])
            return cell
        }else{
            let cell: GPWRuleBottomCell = tableView.dequeueReusableCell(withIdentifier: "GPWRuleBottomCell", for: indexPath) as! GPWRuleBottomCell
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
}

