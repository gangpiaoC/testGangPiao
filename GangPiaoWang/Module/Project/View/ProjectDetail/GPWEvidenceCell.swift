//
//  GPWEvidenceCell.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SnapKit

class GPWEvidenceCell: UICollectionViewCell {
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        imageView = UIImageView()
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(contentView)
        }
    }
    
}
