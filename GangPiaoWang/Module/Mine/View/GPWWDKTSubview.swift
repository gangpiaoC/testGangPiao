//
//  GPWWDKTSubview.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2018/3/6.
//  Copyright © 2018年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWWDKTSubview: LazyScrollSubView,UITableViewDelegate,UITableViewDataSource,HeadViewDelegate {
    fileprivate var showTableView:UITableView!
    fileprivate var dataDic:[JSON]?
    fileprivate var type = "1"
    fileprivate var answersArray = [ProblemTitleModel]()
    fileprivate var textSize:CGSize = CGSize(width: 0, height: 0)
    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化界面
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView() {
        showTableView = UITableView(frame: self.bounds, style: .plain)
        showTableView.backgroundColor = bgColor
        showTableView?.delegate = self
        showTableView?.dataSource = self
        showTableView.separatorStyle = .none
        showTableView.register(GPWFHelpTopCell.self, forCellReuseIdentifier: "GPWFHelpTopCell")
        showTableView.register(GPWFHelpSecCell.self, forCellReuseIdentifier: "GPWFHelpSecCell")
        showTableView.register(GPWFoundThreeCell.self, forCellReuseIdentifier: "GPWFoundThreeCell")
        showTableView.register(GPWFoundFourCell.self, forCellReuseIdentifier: "GPWFoundFourCell")
        self.addSubview(showTableView)
        showTableView.setUpHeaderRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getNetData()
        }
    }

    override func reloadData(withDict dict: [AnyHashable : Any]!) {
        type = dict["type"] as! String
        self.getNetData()
    }

    func changeArray() {
        printLog(message: self.dataDic)
        let num = self.dataDic?.count ?? 1
        self.answersArray.removeAll()
        for i in 0 ..< num{
            let dict = self.dataDic?[i]
            let titleGroup = ProblemTitleModel.friendGroup(withDict: dict?.dictionaryObject, with: i)
            self.answersArray.append(titleGroup!)
        }
        self.showTableView.reloadData()
    }

    func getNetData() {
        GPWNetwork.requetWithGet(url: Net_loan, parameters: ["type":type], responseJSON: {  [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.dataDic = json.array
            strongSelf.changeArray()
            strongSelf.showTableView.endHeaderRefreshing()
        }) { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endHeaderRefreshing()
        }
    }
}
extension GPWWDKTSubview{

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataDic == nil {
            return  0
        }else{
            return self.answersArray.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let titleGroup = self.answersArray[section]
        let count = titleGroup.isOpened ? titleGroup.infor.count : 0
        return count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.textSize.height + 32
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = HeadView.init(tableView: tableView)
        headView?.delegate = self
        headView?.titleGroup = self.answersArray[section]
        return headView
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

        let cellDentifier:String = "AnswerCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellDentifier)
        if cell == nil {
            cell = AnswerCell.init(style: .default, reuseIdentifier: cellDentifier)
        }
        let tempCell:AnswerCell = cell as! AnswerCell
        tempCell.selectionStyle = .none
        let titleGroup = self.answersArray[indexPath.section]
        let answerModel = titleGroup.infor[indexPath.row] as! AnswerModel
        tempCell.tempTitleLabel.text = answerModel.answer
        self.textSize = self.getLabelSizeFortextFont(font: UIFont.systemFont(ofSize: 14), text: answerModel.answer)
        tempCell.tempTitleLabel.height = self.textSize.height
        return cell!
    }

    func getLabelSizeFortextFont(font:UIFont,text:String) -> CGSize {
        let options:NSStringDrawingOptions = .usesLineFragmentOrigin
        let boundingRect = text.boundingRect(with:  CGSize(width: SCREEN_WIDTH - 32, height: 1000), options: options, attributes:[NSAttributedStringKey.font:font], context: nil)
        return boundingRect.size
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
