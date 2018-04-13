//
//  GPWFailController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/9/28.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
enum FailType:Int {
    case CHONGTYPE = 1
    case TIXIANTYPE
    case CHUJIETYPE
    case CUNGUANTYPE
}
class GPWFailController: GPWBaseViewController {
    fileprivate var type:FailType!
    fileprivate var tipStr:String!
    init(type:FailType,tip:String){
        super.init(nibName: nil, bundle: nil)
        self.type = type
        self.tipStr = tip
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
         (navigationController as! GPWNavigationController).canDrag = false
        super.viewDidLoad()
        self.bgView.backgroundColor = UIColor.white
        self.bgView.height = self.bgView.height + 49
        self.initView()
    }

    func initView() {
        //顶部block
        let block = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.bgView.addSubview(block)
        let   imgView = UIImageView(frame: CGRect(x: 0, y: block.maxY + 45, width: 78, height: 82))
        imgView.image = UIImage(named:"user_fail")
        imgView.centerX = SCREEN_WIDTH / 2
        self.bgView.addSubview(imgView)

        let  titleLabel = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 30, width: SCREEN_WIDTH, height: 18))
        titleLabel.textColor = UIColor.hex("333333")
        titleLabel.font = UIFont.customFont(ofSize: 18)
        titleLabel.textAlignment = .center
        self.bgView.addSubview(titleLabel)

        let  tipleLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.maxY + 14, width: SCREEN_WIDTH, height: 14))
        tipleLabel.textColor = UIColor.hex("999999")
        tipleLabel.font = UIFont.customFont(ofSize: 14)
        tipleLabel.text = self.tipStr.removingPercentEncoding
        tipleLabel.textAlignment = .center
        self.bgView.addSubview(tipleLabel)

        let  btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 16, y: tipleLabel.maxY + 96, width: SCREEN_WIDTH - 32, height: 48)
        btn.setImage(UIImage(named:"user_fail_btn"), for: .normal)
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        self.bgView.addSubview(btn)

        let  btnTitleLabel = UILabel(frame: btn.bounds)
        btnTitleLabel.height = btnTitleLabel.height - 3
        btnTitleLabel.font = UIFont.customFont(ofSize: 18)
        btnTitleLabel.textAlignment = .center
        btnTitleLabel.textColor = UIColor.hex("ffffff")
        btn.addSubview(btnTitleLabel)
        if type == FailType.CHONGTYPE {
            self.title = "充值失败"
            titleLabel.text = "充值失败"
            btnTitleLabel.text = "返回充值界面"
        }else if type == FailType.TIXIANTYPE {
            self.title = "提现失败"
            titleLabel.text = "提现失败"
            btnTitleLabel.text = "返回提现界面"
        }else if type == FailType.CUNGUANTYPE {
            self.title = "开通存管失败"
            titleLabel.text = "开通存管账户失败"
            btnTitleLabel.text = "返回我的账户"
        }else if type == FailType.CHUJIETYPE {
            self.title = "出借失败"
            titleLabel.text = "出借失败"
            btnTitleLabel.text = "返回项目详情"
        }
    }

    @objc func btnClick() {
         (navigationController as! GPWNavigationController).canDrag = true
        if type == FailType.CHONGTYPE {
            for vc in self.navigationController!.viewControllers {
                if vc.isKind(of: GPWUserRechargeViewController.self) {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }else if type == FailType.TIXIANTYPE {
            for vc in self.navigationController!.viewControllers {
                if vc.isKind(of: GPWUserTixianViewController.self) {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }else if type == FailType.CUNGUANTYPE {
            if let viewControllers = self.navigationController?.viewControllers {
                for vc in viewControllers {
                    if vc.isKind(of: UserReadInfoViewController.self) {
                        _ = self.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
            }
        }else if type == FailType.CHUJIETYPE {
            for vc in self.navigationController!.viewControllers {
                if vc.isKind(of: GPWProjectDetailViewController.self) {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }
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
