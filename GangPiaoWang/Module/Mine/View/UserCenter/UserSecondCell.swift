//
//  UserSecondCell.swift
//  test
//
//  Created by gangpiaowang on 2016/12/16.
//  Copyright © 2016年 mutouwang. All rights reserved.
//

import UIKit
class UserSecondCell: UITableViewCell {
    weak var superControl:UserController?
    fileprivate var cunBtn:UIButton!
    fileprivate var block:UIView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        let imgArray = ["user_center_tixian","user_center_chongzhi"]
        
        for i in 0 ..< imgArray.count {
          let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 0, y: 0, width: 100, height: 34)
            btn.centerX = CGFloat(2 * i + 1) * SCREEN_WIDTH / 4
            btn.centerY = 76 / 2
            btn.setImage(UIImage(named: imgArray[i]), for: .normal)
            btn.tag = 1000 + i
            btn.addTarget(self, action: #selector(self.btnClick(_:)), for: .touchUpInside)
            contentView.addSubview(btn)

            if i == 0 {
                let line = UIView(frame: CGRect(x: SCREEN_WIDTH / 2, y: 0, width: 0.5, height: 32))
                line.backgroundColor = UIColor.hex("d8d8d8")
                line.centerY = btn.centerY
                contentView.addSubview(line)
            }
        }

        //开通存管按钮
        cunBtn = UIButton(type: .custom)
        cunBtn.frame = CGRect(x: 0, y: 76, width: SCREEN_WIDTH, height: 32)
        cunBtn.backgroundColor = UIColor.hex("fff4e1")
        cunBtn.titleLabel?.font = UIFont.customFont(ofSize: 14)
        cunBtn.setTitle("开通恒丰银行存管账户，立即领取618红包 >", for: .normal)
        cunBtn.contentHorizontalAlignment = .left
        cunBtn.contentEdgeInsets = UIEdgeInsetsMake(0,16, 0, 0)
        cunBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        cunBtn.setTitleColor(UIColor.hex("f6a623"), for: .normal)
        contentView.addSubview(cunBtn)

        block = UIView(frame: CGRect(x: 0, y: 76 + 32, width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
    }
    func updata(flag:Bool) {
        cunBtn.setTitle("开通恒丰银行存管账户，立即领取618红包 >", for: .normal)
        cunBtn.isHidden = flag
        if flag {
                block.y = 76
        }else{
                block.y = cunBtn.maxY
        }
    }

    //风险测评
    func safeViewShow(flag:Bool) {
        cunBtn.isHidden = flag
        cunBtn.tag = 103
        cunBtn.setTitle("先完成风险测评再出借 >", for: .normal)
        if flag {
            block.y = 76
        }else{
            block.y = cunBtn.maxY
        }
    }
    
    @objc func btnClick(_ sender:UIButton) {
        printLog(message: sender.tag)
        if GPWUser.sharedInstance().isLogin == false{
            self.superControl?.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
        }else if GPWUser.sharedInstance().is_idcard == 0{
            self.superControl?.navigationController?.pushViewController(UserReadInfoViewController(), animated: true)
        }else{
            if sender.tag == 1001 {
                MobClick.event("mine", label: "充值")
                let control = GPWUserRechargeViewController(money: 0.00)
                superControl?.navigationController?.pushViewController(control, animated: true)
            }else if sender.tag == 1000{
                MobClick.event("mine_withdraw", label: nil)
                let control = GPWUserTixianViewController()
                superControl?.navigationController?.pushViewController(control, animated: true)
            }else if sender.tag == 103 {
                 superControl?.navigationController?.pushViewController(GPWRiskAssessmentViewController(), animated: true)
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
