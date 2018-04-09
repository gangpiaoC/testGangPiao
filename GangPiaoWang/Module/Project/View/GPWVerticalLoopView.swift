//
//  GPWVerticalLoopView.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWVerticalLoopView: UIView {
    enum VerticalLoopDirection {
        case bottom, down
    }
    
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    internal let bgView = UIView()
    private var index = 0
    var dataArray = [NSAttributedString]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.white
        let imageView = UIImageView(frame: CGRect(x: 16, y: 10, width: 17, height: 14))
        imageView.image = UIImage(named: "project_loudspeaker")
        addSubview(imageView)
        bgView.frame = CGRect(x: imageView.frame.maxX + 6, y: 0, width: SCREEN_WIDTH - imageView.frame.maxX - 6, height: bounds.height)
        bgView.clipsToBounds = true
        addSubview(bgView)
        
        firstLabel.frame = CGRect(x: 0, y: 0, width: bgView.bounds.width, height: bgView.bounds.height)
        firstLabel.backgroundColor = UIColor.clear
        firstLabel.textColor = subTitleColor
        firstLabel.font = UIFont.customFont(ofSize: 12)
        
        secondLabel.frame = CGRect(x: 0, y: bgView.bounds.height, width: bgView.bounds.width, height: bgView.bounds.height)
        secondLabel.backgroundColor = UIColor.clear
        secondLabel.textColor = subTitleColor
        secondLabel.font = UIFont.customFont(ofSize: 12)
        
        bgView.addSubview(firstLabel)
        bgView.addSubview(secondLabel)
    }
    
    func start() {
        firstLabel.attributedText = dataArray[index]
        var secondIndex = index + 1
        if secondIndex > dataArray.count - 1 {
            secondIndex = 0
        }
        let firstLabelStartY: CGFloat = 0
        let firstLabelEndY: CGFloat = -bounds.height
        let secondLabelStartY: CGFloat = firstLabelStartY + bounds.height
        let secondLabelEndY: CGFloat = firstLabelEndY + bounds.height
        
        secondLabel.attributedText = dataArray[secondIndex]
        firstLabel.frame = CGRect(x: 0, y: firstLabelStartY, width: bgView.bounds.width, height: bgView.bounds.height)
        secondLabel.frame = CGRect(x: 0, y: secondLabelStartY, width: bgView.bounds.width, height: bgView.bounds.height)
        
        UIView.animate(withDuration: 1, animations: {
            var firstLabelFrame = self.firstLabel.frame
            firstLabelFrame.origin.y = firstLabelEndY
            self.firstLabel.frame = firstLabelFrame
            self.secondLabel.frame = CGRect(x: 0, y: secondLabelEndY, width: self.bgView.bounds.width, height: self.bgView.bounds.height)
        }, completion: { finished in
            self.index += 1
            if self.index >= self.dataArray.count {
                self.index = 0
            }
            self.start()
        })
    }
    
}
