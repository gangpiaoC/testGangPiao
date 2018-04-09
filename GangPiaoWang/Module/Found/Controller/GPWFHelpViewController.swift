//
//  GPWFHelpViewController.swift
//  GangPiaoWang
//   发现-帮助中心
//  Created by gangpiaowang on 2017/8/10.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWFHelpViewController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource,HeadViewDelegate {

    fileprivate var showTableView:UITableView!
    fileprivate var page:Int?
    fileprivate var dataDic:JSON?
    fileprivate var answersArray = [ProblemTitleModel]()
    fileprivate var textSize:CGSize = CGSize(width: 0, height: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化界面
        initView()
    }
    
    func initView() {
        self.title = "帮助中心"
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = bgColor
        showTableView?.delegate = self
        showTableView?.dataSource = self
        showTableView.separatorStyle = .none
        showTableView.register(GPWFHelpTopCell.self, forCellReuseIdentifier: "GPWFHelpTopCell")
        showTableView.register(GPWFHelpSecCell.self, forCellReuseIdentifier: "GPWFHelpSecCell")
        showTableView.register(GPWFoundThreeCell.self, forCellReuseIdentifier: "GPWFoundThreeCell")
        showTableView.register(GPWFoundFourCell.self, forCellReuseIdentifier: "GPWFoundFourCell")
        self.bgView.addSubview(showTableView)
        self.getNetData()
        showTableView.setUpHeaderRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.page = 1
            strongSelf.getNetData()
        }
    }
    
    func changeArray(type:String) {
        printLog(message: self.dataDic?[type])
        let num = self.dataDic?[type].count ?? 1
        self.answersArray.removeAll()
        for i in 0 ..< num{
            let dict = self.dataDic?[type][i]
            let titleGroup = ProblemTitleModel.friendGroup(withDict: dict?.dictionaryObject, with: i)
            self.answersArray.append(titleGroup!)
        }
        self.showTableView.reloadData()
    }
    
    override func getNetData() {
        GPWNetwork.requetWithGet(url: Help_center, parameters: nil, responseJSON: {  [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.dataDic = json
            strongSelf.changeArray(type: "bidu")
            strongSelf.showTableView.endHeaderRefreshing()
        }) { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endHeaderRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension GPWFHelpViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataDic == nil {
            return  0
        }else{
             return 1 + self.answersArray.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else{
            let titleGroup = self.answersArray[section - 1]
            let count = titleGroup.isOpened ? titleGroup.infor.count : 0
            return count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 163
            }else if indexPath.row == 1{
                return 188
            }
        }else{
            return self.textSize.height + 32
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else{
            let headView = HeadView.init(tableView: tableView)
            headView?.delegate = self
            headView?.titleGroup = self.answersArray[section - 1]
            return headView
        }
    }
    
    func clickWidthIndex(_ index: Int) {
        for tempModel in self.answersArray {
            if tempModel.index == index {
                tempModel.isOpened = !tempModel.isOpened
            }else{
                tempModel.isOpened = false
            }
        }
        self.showTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell: GPWFHelpTopCell = tableView.dequeueReusableCell(withIdentifier: "GPWFHelpTopCell", for: indexPath) as! GPWFHelpTopCell
                cell.superControl = self
                return cell
            }else  if indexPath.row == 1{
                let cell: GPWFHelpSecCell = tableView.dequeueReusableCell(withIdentifier: "GPWFHelpSecCell", for: indexPath) as! GPWFHelpSecCell
                cell.superControl = self
                return cell
            }
        }else{
            let cellDentifier:String = "AnswerCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellDentifier)
            if cell == nil {
                cell = AnswerCell.init(style: .default, reuseIdentifier: cellDentifier)
            }
            let tempCell:AnswerCell = cell as! AnswerCell
            tempCell.selectionStyle = .none
            let titleGroup = self.answersArray[indexPath.section - 1]
            let answerModel = titleGroup.infor[indexPath.row] as! AnswerModel
            tempCell.tempTitleLabel.text = answerModel.answer
            self.textSize = self.getLabelSizeFortextFont(font: UIFont.systemFont(ofSize: 14), text: answerModel.answer)
            tempCell.tempTitleLabel.height = self.textSize.height
            return cell!
        }
        
        //无用
        let cell: GPWFHelpSecCell = tableView.dequeueReusableCell(withIdentifier: "GPWFHelpSecCell", for: indexPath) as! GPWFHelpSecCell
        cell.superControl = self
        return cell
    }
    
    func getLabelSizeFortextFont(font:UIFont,text:String) -> CGSize {
        let options:NSStringDrawingOptions = .usesLineFragmentOrigin
        let boundingRect = text.boundingRect(with:  CGSize(width: SCREEN_WIDTH - 32, height: 1000), options: options, attributes:[NSFontAttributeName:font], context: nil)
        return boundingRect.size
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

