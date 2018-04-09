//
//  GPWProjectInSecondVC.swift
//  GangPiaoWang
// 立即起息
//  Created by gangpiaowang on 2017/4/18.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON

class GPWProjectInSecondVC: GPWSubPageBaseViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var data: JSON!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.sectionHeaderHeight = 0.001
        tableView.sectionFooterHeight = 0.001
        tableView.separatorStyle = .none
        self.tableView.register(GPWProjectIntroduceCell1.self, forCellReuseIdentifier: "GPWProjectIntroduceCell1")
        self.tableView.register(GPWProjectIntroduceCell2.self, forCellReuseIdentifier: "GPWProjectIntroduceCell2")
        self.tableView.register(GPWProjectIntroduceCell3.self, forCellReuseIdentifier: "GPWProjectIntroduceCell3")
        self.tableView.register(GPWProjectIntroduceCell0.self, forCellReuseIdentifier: "GPWProjectIntroduceCell0")
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("\(self.classForCoder)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("\(self.classForCoder)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell: GPWProjectIntroduceCell0 = tableView.dequeueReusableCell(withIdentifier: "GPWProjectIntroduceCell0", for: indexPath) as! GPWProjectIntroduceCell0
            cell.update(desStr: data["product_description"].stringValue,flag: 2)
            return cell
        }else if indexPath.row == 1{
            let cell: GPWProjectIntroduceCell2 = tableView.dequeueReusableCell(withIdentifier: "GPWProjectIntroduceCell2", for: indexPath) as! GPWProjectIntroduceCell2
            if let data = self.data {
                let  tempStr = data["acceptor_information"].string
                cell.update(desStr: tempStr, title: "原始债务企业")
            }
            return cell
        } else if indexPath.row == 2{
            let cell: GPWProjectIntroduceCell2 = tableView.dequeueReusableCell(withIdentifier: "GPWProjectIntroduceCell2", for: indexPath) as! GPWProjectIntroduceCell2
            if let data = self.data {
                let  tempStr = data["risk_measures"].string
                cell.update(desStr: tempStr, title: "风控措施")
            }
            return cell
        }else if indexPath.row == 3 {
            let cell: GPWProjectIntroduceCell2 = tableView.dequeueReusableCell(withIdentifier: "GPWProjectIntroduceCell2", for: indexPath) as! GPWProjectIntroduceCell2
            if let data = self.data {
                let  tempStr = data["user_where"].string
                cell.update(desStr: tempStr, title: "借款用途")
            }
            return cell
        }else if indexPath.row == 4 {
            let cell: GPWProjectIntroduceCell2 = tableView.dequeueReusableCell(withIdentifier: "GPWProjectIntroduceCell2", for: indexPath) as! GPWProjectIntroduceCell2
            if let data = self.data {
                let  tempStr = data["repay_where"].string
                cell.update(desStr: tempStr, title: "还款来源")
            }
            return cell
        }else {
            let cell: GPWProjectIntroduceCell3 = tableView.dequeueReusableCell(withIdentifier: "GPWProjectIntroduceCell3", for: indexPath) as! GPWProjectIntroduceCell3
            
            if let data = self.data , let imgs = data["file"].array {
                var photosURLString: [String] = [String]()
                for file in imgs {
                    let fileStr = file.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    photosURLString.append(fileStr)
                }
                
                cell.imgTap = { [weak self] index in
                    guard let strongSelf = self else { return }
                    let photoBrowser = PhotoBrowser(photoModels: strongSelf.setPhoto(photosURLString))
                    photoBrowser.show(inVc: strongSelf, beginPage: index)
                }
                cell.setupCell(photosURLString)
            }
            return cell
        }
    }
    
    private func setPhoto(_ photosURLString: [String]) -> [PhotoModel] {
        var photos: [PhotoModel] = []
        for photoURLString in photosURLString {
            // 初始化不设置sourceImageView,也可以设置, 如果sourceImageView是不需要动态改变的, 那么推荐不需要代理设置sourceImageView
            // 而在代理方法中动态更新,将会覆盖原来设置的sourceImageView
            let photoModel = PhotoModel(imageUrlString: photoURLString, sourceImageView: nil)
            photos.append(photoModel)
        }
        return photos
    }
}
