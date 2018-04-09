//
//  GPWProjectSubListView.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/6/5.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWProjectSubListView: LazyScrollSubView ,GPWTableViewDelegate{
    weak var delegate:GPWProjectSubListViewDelegate?
    var urls = [JSON]()
    var tableView: GPWTableView!
    var topImgView:UIImageView!
    fileprivate var type:String?
    fileprivate var superControl:GPWBaseViewController?
    private var page = 1
    fileprivate let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 102))
    fileprivate var dataArray = [JSON]()

    init(frame: CGRect ,superControl:GPWBaseViewController) {
        super.init(frame: frame)
        self.superControl = superControl
         commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reloadData(withDict dict: [AnyHashable : Any]!) {
        type = dict["type"] as? String
        self.page = 1
        self.requestNetData()
    }
    
    private func commonInit() {
        self.tableView = GPWTableView(frame: self.superControl!.bgView.bounds, delegate: self)
        let bounds = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 102)
        topImgView = UIImageView(frame: bounds)
        topImgView.height = 102
        let  tap  = UITapGestureRecognizer(target: self, action: #selector(self.imgPressed))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        topImgView.isUserInteractionEnabled = true
        topImgView.addGestureRecognizer(tap)
        
        headerView.addSubview(topImgView)
        self.tableView.tableHeaderView = headerView
        self.tableView.register(GPWProjectCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(self.tableView)
        
        tableView.setUpHeaderRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.page = 1
            strongSelf.requestNetData()
        }
        
        tableView.setUpFooterRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.requestNetData()
        }
    }
    
    private func requestNetData() {
        GPWNetwork.requetWithGet(url: Financing_list, parameters: ["page": page,"type":type ?? "0"], responseJSON:  {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            guard let info = json["info"].array else {
                return
            }
            
            if strongSelf.page == 1 {
                strongSelf.dataArray.removeAll()
            }
            
            strongSelf.tableView.footerRefresh.isHidden = false
            if info.count > 0 {
                strongSelf.page += 1
                strongSelf.dataArray += info
                strongSelf.tableView.endFooterRefreshing()
            } else {
                strongSelf.tableView.endFooterRefreshingWithNoMoreData()
            }
            
            strongSelf.tableView.endHeaderRefreshing()
            strongSelf.tableView.reloadData()
            
            guard let imgs = json["img"].array else {
                return
            }
            strongSelf.urls = imgs
            strongSelf.topImgView.downLoadImg(imgUrl: imgs[0]["img_url"].string!)
            printLog(message: imgs)
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.tableView.endHeaderRefreshing()
                strongSelf.tableView.endFooterRefreshing()
        })
    }
    
    func imgPressed() {
        let  url = urls[0]
        if url["link"].stringValue.characters.count > 10 {
            self.superControl?.navigationController?.pushViewController(GPWOhterWebViewController(subtitle: "", url: url["link"].stringValue), animated: true)
        }
    }
}

extension GPWProjectSubListView {
    func eScrollerInitView(for index: UInt) -> UIView! {
        let imageView = UIImageView()
        if self.urls.count > 0 {
            let i = Int(index)
            imageView.downLoadImg(imgUrl: self.urls[i]["img_url"].string!)
        }
        return imageView
    }
    func eScrollerViewDidClicked(_ index: UInt) {
        let i = Int(index)
        let  url = urls[i]
        if url["link"].stringValue.characters.count > 10 {
            self.superControl?.navigationController?.pushViewController(GPWOhterWebViewController(subtitle: "", url: url["link"].stringValue), animated: true)
        }
    }
}

extension GPWProjectSubListView {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GPWProjectCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GPWProjectCell
        cell.setupCell(dict: dataArray[indexPath.row])
        cell.buyHandle = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let projectID = strongSelf.dataArray[indexPath.row]["auto_id"]
            let vc = GPWProjectDetailViewController(projectID: "\(projectID)")
            vc.title = strongSelf.dataArray[indexPath.row]["title"].string
            strongSelf.superControl?.navigationController?.show(vc, sender: nil)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let projectID = dataArray[indexPath.row]["auto_id"]
        let vc = GPWProjectDetailViewController(projectID: "\(projectID)")
        vc.title = dataArray[indexPath.row]["title"].string
        self.superControl?.navigationController?.show(vc, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.delegate?.responds(to: #selector(self.delegate?.listScrollDidScrol(scrollview:))) == true {
            self.delegate?.listScrollDidScrol!(scrollview: scrollView)
        }
    }
}

@objc protocol GPWProjectSubListViewDelegate:NSObjectProtocol{
    @objc optional func listScrollDidScrol(scrollview:UIScrollView)
}
