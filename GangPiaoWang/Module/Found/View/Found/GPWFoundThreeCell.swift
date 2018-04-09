//
//  GPWHomeSecTableViewCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWFoundThreeCell: UITableViewCell {
    
    var superControl:UIViewController?
    fileprivate var dataDic:JSON?
    fileprivate var centerImgView:UIImageView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        centerImgView = UIImageView(frame: CGRect(x: 0 , y: 0, width: SCREEN_WIDTH, height: pixw(p: 122)))
        centerImgView.isUserInteractionEnabled = true
        self.contentView.addSubview(centerImgView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imgClick))
        centerImgView.addGestureRecognizer(tapGesture)
        
        let block = UIView(frame: CGRect(x: 0, y: centerImgView.maxY , width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
    }
    
    func updata(dic:JSON,superControl:UIViewController) {
        self.dataDic = dic
        centerImgView.downLoadImg(imgUrl: (self.dataDic?["img_url"].stringValue)!, placeImg: "")
        self.superControl = superControl
    }
    
    @objc func imgClick()  {
         MobClick.event("found", label: "广告位")
        if self.dataDic != nil {
            let url = self.dataDic?["link"].string ?? ""
            if url == "VIP" {
                let  ttController = GPWFTTZHController()
                ttController.urlstr = self.dataDic?["h5_link"].string ?? ""
                 _ = GPWHelper.selectedNavController()?.pushViewController(ttController, animated: true)
            }else if url == "redpackt" {
                if GPWUser.sharedInstance().isLogin {
                    self.superControl?.navigationController?.pushViewController(GPWHomeGetBageController(), animated: true)
                }else{
                    self.superControl?.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
