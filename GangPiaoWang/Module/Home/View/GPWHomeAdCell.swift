//
//  GPWHomeAdCell.swift
//  GangPiaoWang
//  首页广告
//  Created by gangpiaowang on 2018/4/10.
//  Copyright © 2018年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHomeAdCell: UITableViewCell {
    fileprivate var imgView:UIImageView!
    fileprivate var dicJson:JSON?
    fileprivate var superController:UIViewController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: pixw(p: 120)))
        imgView.isUserInteractionEnabled = true
        self.contentView.addSubview(imgView)

        //添加点击手势
        let  signleTap = UITapGestureRecognizer(target: self, action: #selector(self.tapClick(_:)))
        imgView.addGestureRecognizer(signleTap)

        let block = UIView(frame: CGRect(x: 0, y: pixw(p: 120), width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updata(_ imgJson:JSON,_ Controller:UIViewController) {
        dicJson = imgJson
        superController = Controller
        imgView.downLoadImg(imgUrl: imgJson["img_url"].string ?? "")
    }




    /// 点击
    @objc func tapClick(_ sender:UITapGestureRecognizer){
        let url = dicJson!["link"].string ?? ""
        if (url.range(of: "https")) != nil{
            if(url.count) > 6 {
                superController?.navigationController?.pushViewController(GPWWebViewController(dic: dicJson!), animated: true)
            }
        }else{
            _ = GPWHelper.selectedNavController()?.pushViewController(GPWProjectDetailViewController(projectID: url), animated: true)
        }
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
