//
//  UIImageView+xh.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView{
    
    func downLoadImg(imgUrl:String  = "" ,placeImg:String = "") {
        if imgUrl == ""  {
            return
        }
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        let resource = ImageResource(downloadURL: URL(string: imgUrl)!)
        //self.image = UIImage(named: "placeholderImage")
        self.kf.setImage(with: resource, placeholder: UIImage(named: placeImg.count > 3 ? "" : "placeholderImage" ), options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { (img, error, cache, url) in
        }
    }
    
    func cancelDownload() {
        self.kf.cancelDownloadTask()
    }
}
