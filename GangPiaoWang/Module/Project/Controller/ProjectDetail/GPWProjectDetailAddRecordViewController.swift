//
//  GPWProjectDetailAddRecordViewController.swift
//  GangPiaoWang
//
//  Created by GC on 2018/4/11.
//  Copyright © 2018年 GC. All rights reserved.
//
import UIKit
import SwiftyJSON

class GPWProjectDetailAddRecordViewController: GPWSecBaseViewController, UITableViewDataSource, UITableViewDelegate {
    let projectID: String
    var dataArray = [JSON]()
    var tableView: UITableView!
    var page = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("\(self.classForCoder)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("\(self.classForCoder)")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(projectID: String) {
        self.projectID = projectID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "加入记录"
        bgView.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76
        tableView.sectionHeaderHeight = 0.001
        tableView.sectionFooterHeight = 0.001
        tableView.separatorStyle = .none
        tableView.register(GPWBidRecordCell.self, forCellReuseIdentifier: "bidCell")
        bgView.addSubview(tableView)
        
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(bgView)
        }
        
        tableView.setUpHeaderRefresh {
            [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.page = 1
            strongSelf.requestNetData()
        }
        
        tableView.setUpFooterRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.requestNetData()
        }
        
        requestNetData()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func requestNetData() {
        GPWNetwork.requetWithGet(url: Financing_details_jct, parameters: ["auto_id": projectID, "type": 3, "page": page], responseJSON: { [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.endFooterRefreshing()
            strongSelf.tableView.endHeaderRefreshing()
            let info = json.arrayValue
            if strongSelf.page == 1 {
                strongSelf.dataArray = info
                if  strongSelf.dataArray.count == 0 {
                    strongSelf.tableView.setFooterNoMoreData()
                } else {
                    strongSelf.page += 1
                    strongSelf.tableView.footerRefresh.isHidden = false
                }
            }else{
                if info.count > 0 {
                    strongSelf.page += 1
                    strongSelf.dataArray += info
                    strongSelf.tableView.endFooterRefreshing()
                } else {
                    strongSelf.tableView.endFooterRefreshingWithNoMoreData()
                }
            }
            if strongSelf.dataArray.count > 0 {
                strongSelf.noDataImgView.isHidden = true
            }else{
                strongSelf.noDataImgView.isHidden = false
                strongSelf.bgView.bringSubview(toFront: strongSelf.noDataImgView)
            }
            strongSelf.tableView.reloadData()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.tableView.endHeaderRefreshing()
                strongSelf.tableView.endFooterRefreshing()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GPWBidRecordCell = tableView.dequeueReusableCell(withIdentifier: "bidCell", for: indexPath) as! GPWBidRecordCell
        cell.setupCell(dataArray[indexPath.row])
        return cell
    }
}
