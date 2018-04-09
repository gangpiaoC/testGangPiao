//
//  GPWFAQViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON

class GPWFAQViewController: GPWSubPageBaseViewController, UITableViewDelegate, UITableViewDataSource {
    var projectID: String?
    var tableView: UITableView!
    var dataArray = [JSON]()
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
        self.tableView.register(GPWFAQCell.self, forCellReuseIdentifier: "FAQCell")
        self.view.addSubview(tableView)
        
        // Do any additional setup after loading the view.
    }
    
    private func requestNetData() {
        GPWNetwork.requetWithGet(url: Financing_details_jct, parameters: ["auto_id": projectID!, "type": 2], responseJSON: { [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.dataArray = json.arrayValue
            strongSelf.tableView.reloadData()
            }, failure: { error in
                
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestNetData()
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
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GPWFAQCell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! GPWFAQCell
        if dataArray.count > 0 {
            cell.setupCell(dataArray[indexPath.row])
        }
        return cell
    }

}
