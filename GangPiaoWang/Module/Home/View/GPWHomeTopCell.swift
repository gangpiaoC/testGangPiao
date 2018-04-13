//
//  GPWHomeTopCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHomeTopCell: UITableViewCell,EScrollerViewDelegate {
    //临时测试
    var linshiImgUrl = ""
    var _scrollView:EScrollerView?
    var _data:JSON?
    weak var _indexControl:UIViewController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    func showInfo(array:JSON,control:UIViewController) {
        _indexControl = control
        _data = array
        self.reloadData()
    }
    
    func reloadData() {
        if  _data?.count == 0 {
            return
        }
        _scrollView?.removeFromSuperview()
        _scrollView = EScrollerView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: pixw(p: 197)), pageCount: (_data?.count)!, delegate: self)
        let line = UIView(frame: CGRect(x: 0, y: (_scrollView?.height)! - 0.5, width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = lineColor
        _scrollView?.addSubview(line)
        self.contentView.addSubview(_scrollView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GPWHomeTopCell{
    func eScrollerInitView(for index: UInt) -> UIView! {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 206))
        if (_data?.count)! > 0 {
            let dic = self._data![Int(index)]
            imgView.downLoadImg(imgUrl: dic["img_url"].string ?? "")
        }else{
            imgView.downLoadImg(imgUrl: linshiImgUrl)
        }
        return imgView
    }
    func eScrollerViewDidClicked(_ index: UInt) {
        printLog(message: "滑动中,点击去哪里？")
        let dic = self._data![Int(index)]
        MobClick.event("home", label:  "banner_\(index)")
        let url = dic["link"].string ?? ""
        if (url.range(of: "https")) != nil{
            if(url.count) > 6 {
                _indexControl?.navigationController?.pushViewController(GPWWebViewController(dic: dic), animated: true)
            }
        }else{
              _ = GPWHelper.selectedNavController()?.pushViewController(GPWProjectDetailViewController(projectID: url), animated: true)
        }
    }
}
