//
//  GPWAddDayMoneyController.swift
//  GangPiaoWang
//  累计收益
//  Created by gangpiaowang on 2016/12/23.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWAddDayMoneyController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource {

    var dataArray:[Any]!
    var totalAccrual = "0.0"
    var accrual = "0.0"
    var showTableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "累计收益"
        dataArray = Array()
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = bgColor
        showTableView.delegate = self
        showTableView.dataSource = self
        showTableView.setUpHeaderRefresh {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getNetData()
        }
        self.getNetData()
        self.bgView.addSubview(showTableView)
    }
    
    override func getNetData() {
        GPWNetwork.requetWithPost(url: Api_cumulative, parameters: nil, responseJSON:  {
            [weak self] (json,msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.accrual = json["accrual"].stringValue
            strongSelf.totalAccrual = json["totalAccrual"].stringValue
            strongSelf.dataArray = json["accrual_info"].arrayObject
            if strongSelf.dataArray.count == 0 {
                strongSelf.noDataImgView.isHidden = false
            }else{
                 strongSelf.noDataImgView.isHidden = true
            }
            strongSelf.showTableView.endHeaderRefreshing()
            strongSelf.showTableView.reloadData()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.showTableView.endHeaderRefreshing()
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else if self.dataArray.count == 0 || self.dataArray == nil {
            return 0
        }else{
            return self.dataArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return 10
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 96
        }
        return 46
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWAddMoneyCell") as? GPWAddMoneyCell
            if cell == nil {
                cell = GPWAddMoneyCell(style: .default, reuseIdentifier: "GPWAddMoneyCell")
            }
            cell?.updata(addMoney: self.accrual, allMoney: self.totalAccrual)
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWAddMoneyOtherCell") as? GPWAddMoneyOtherCell
            if cell == nil {
                cell = GPWAddMoneyOtherCell(style: .default, reuseIdentifier: "GPWAddMoneyOtherCell")
            }
            cell?.update(dic: self.dataArray[indexPath.row] as! [String:Any], index: indexPath.row)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
