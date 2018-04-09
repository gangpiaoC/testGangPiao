//
//  GPWDetailFullBiaoViewController.swift
//  GangPiaoWang
//  满标奖励
//  Created by gangpiaowang on 2017/6/7.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWDetailFullBiaoViewController: GPWSecBaseViewController {
    fileprivate var scrollView:UIScrollView!
    fileprivate var paraJson:JSON?
    init(para:JSON){
        super.init(nibName: nil, bundle: nil)
        self.paraJson = para
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "满标奖励"
        self.bgView.backgroundColor = UIColor.white
        self.initView()
    }
    
    func initView()  {
        scrollView = UIScrollView(frame:self.bgView.bounds)
        scrollView.showsVerticalScrollIndicator = false
        self.bgView.addSubview(scrollView)
        
        let topImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: pixw(p: 124)))
        topImgView.image = UIImage(named: "project_detail_full_top")
        scrollView.addSubview(topImgView)
        
        let  redImgView = UIImageView(frame: CGRect(x: 0, y: topImgView.maxY + 20, width: 156, height: 125))
        redImgView.image = UIImage(named: "project_detail_full_red")
        redImgView.centerX = scrollView.width / 2
        scrollView.addSubview(redImgView)
        
        let redNumLabel = UILabel(frame: CGRect(x: 0, y: 31, width: redImgView.width, height: 33))
         redNumLabel.attributedText = NSAttributedString.attributedBoldString( "￥", mainColor: UIColor.hex("fc0101"), mainFont: 20, second: "\(self.paraJson?["amount"] ?? "0")", secondColor: UIColor.hex("fc0000"), secondFont: 33)
        redNumLabel.textAlignment = .center
        redImgView.addSubview(redNumLabel)
        
        let detailLabel = RTLabel(frame: CGRect(x: 0, y: redImgView.maxY + 9, width: 255, height: 10))
        detailLabel.text = "<font size=16 color='#333333'>单个标的促成满标者可获得</font><font size=16 color='#f6390c'>\(self.paraJson?["amount"] ?? "0")元</font><font size=16 color=#333333''>红包奖励</font>"
        detailLabel.centerX = scrollView.width / 2
        detailLabel.textAlignment = RTTextAlignmentCenter
        detailLabel.height = detailLabel.optimumSize.height
        scrollView.addSubview(detailLabel)
        let bottomView = UIView(frame: CGRect(x: 0, y: detailLabel.maxY + 27, width: 333, height: 218))
        bottomView.backgroundColor = UIColor.hex("fffaf1")
        bottomView.centerX = scrollView.width / 2
        bottomView.layer.masksToBounds = true
        bottomView.layer.cornerRadius = 8
        scrollView.addSubview(bottomView)
        
        let  bottomImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: bottomView.width, height: 48))
        bottomImgView.image = UIImage(named: "project_detail_full_shuoming")
        bottomView.addSubview(bottomImgView)
        
        let contentArray = ["\(self.paraJson?["amount"].intValue ?? 0)元红包,项目期限≥\(self.paraJson?["limit"].intValue ?? 90)天且出借金额≥\((self.paraJson?["amount"].intValue ?? 100) * (self.paraJson?["restrict"].intValue ?? 250))元时方可使用；","红包有效期为\(self.paraJson?["limits"] ?? "0")天，请及时使用，以免过期；","红包不可转让，也不可拆分；","本活动最终解释权归钢票网所有，如有疑问请致电客服："]
        
        var maxY = bottomImgView.maxY + 25
        for i in 0 ..< contentArray.count {
            let numLabel = UILabel(frame: CGRect(x: 19, y: maxY + 3, width: 25, height: 15))
            numLabel.font = UIFont.customFont(ofSize: 14)
            numLabel.textColor = UIColor.hex("333333")
            numLabel.text = "\(i + 1)、"
            bottomView.addSubview(numLabel)
            
            let detailLabel = RTLabel(frame: CGRect(x: numLabel.maxX, y: maxY, width: bottomView.width - 19 - numLabel.maxX - 3, height: 10))
            detailLabel.text = "<font size=14 color='#333333'>\(contentArray[i])</font>"
            if i == contentArray.count - 1 {
                detailLabel.text = detailLabel.text + "<font size=14 color='#f6390c'>400-900-9017</font>"
            }
            
            detailLabel.height = detailLabel.optimumSize.height
            bottomView.addSubview(detailLabel)
            maxY = detailLabel .maxY + 7
        }
        
        bottomView.height = maxY + 10
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: bottomView.maxY  + 30)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
