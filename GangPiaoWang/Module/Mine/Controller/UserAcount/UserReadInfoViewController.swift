//
//  UserReadInfoViewController.swift
//  GangPiaoWang
//  实名认证
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class UserReadInfoViewController: GPWSecBaseViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    fileprivate let NAMETAG       = 1001
    fileprivate let SHENFENTAG  = 1002
    fileprivate let BANKTAG         = 1004
    fileprivate let PHONETAG      = 1000
    fileprivate let AREATAG        = 1001
    fileprivate var  tempBgView:UIView!
    fileprivate var bottomView:UIView!
    //选择省份的下标
    fileprivate var proIndex = 0
    //是否展示pickview
    fileprivate var showPickViewFlag:Bool!
    //银行名称
    fileprivate var bankLabel:UILabel!

    //银行类别
    fileprivate var abbreviation:String?
    //根据类型跳转
    var type:String?

    //展示表
    fileprivate var bgVickerView:UIView!

    //城市数据
    fileprivate var cityArray:[JSON]?

    //城市编码
    fileprivate var  cityCode:Int!

    //选择器
    var pickerView:UIPickerView!

    fileprivate let  bankCodeArray =  [
        "CITIC":"CIBK",
        "PSBC":"PSBC",
        "SPABANK":"SZDB",
         "ABC":"ABOC",
          "CMBC":"MSBC",
           "CEB":"EVER",
            "ICBC":"ICBK",
            "CMB":"CMBC",
             "CIB":"FJIB",
              "SPDB":"SPDB",
               "COMM":"COMM",
                "CCB":"PCBC",
                 "HXBANK":"HXBK",
                  "CGB":"GDBK",
                   "BOC":"BKCH"
    ]
    let contentArray = [
        ["name":"实名认证","title":""],
        ["name":"真实姓名","title":"请输入姓名"],
        ["name":"身份证号","title":"请输入身份证号"],
        ["name":"银行卡信息","title":""],
        ["name":"银行卡号","title":"请输入本人银行卡号"]
    ]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "开通存管账户"
        cityArray = [JSON]()
        showPickViewFlag = false
        self.getNetData()
    }
    override func getNetData() {
        GPWNetwork.requetWithGet(url: CityAddress, parameters: nil, responseJSON: {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            printLog(message: json)
            strongSelf.cityArray = json.array
            strongSelf.proIndex = 0
            strongSelf.initPickerView()
            strongSelf.initView()
        }) { (error) in

        }
    }

    //初始化pickerview
    func initPickerView() {
         let wid = UIApplication.shared.keyWindow
        self.bgVickerView = UIView(frame: (wid?.bounds)!)
        self.bgVickerView.backgroundColor = UIColor.hex("000000", alpha: 0.6)
        wid?.addSubview(self.bgVickerView)
        self.bgVickerView.isHidden = true

        //加入手势
        let  gesture = UITapGestureRecognizer(target: self, action: #selector(self.pickShowOrHideClick))
        self.bgVickerView.addGestureRecognizer(gesture)
        pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.white
        pickerView.x = 0
        pickerView.width = SCREEN_WIDTH
        pickerView.y = SCREEN_HEIGHT - pickerView.height
        pickerView.dataSource = self
        pickerView.delegate = self
        if self.cityArray?.count != 0 {
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        self.proIndex = 0
        self.bgVickerView.addSubview(pickerView)

        //顶部
        let  tempTopArray = ["省市","区县","完成"]
        for i in 0 ..< tempTopArray.count {
            if i == 2 {
                let finishBtn = UIButton(type: .custom)
                finishBtn.frame = CGRect(x: SCREEN_WIDTH - 90, y: 0, width: 90, height: 50)
                finishBtn.setTitle("完成", for: .normal)
                finishBtn.setTitleColor(redColor, for: .normal)
                finishBtn.titleLabel?.font = UIFont.customFont(ofSize: 14)
                finishBtn.addTarget(self, action: #selector(self.pickShowOrHideClick), for: .touchUpInside)
                pickerView.addSubview(finishBtn)

                let line = UIView(frame: CGRect(x: 16, y: 46 , width: SCREEN_WIDTH - 16, height: 1))
                line.backgroundColor =  bgColor
                pickerView.addSubview(line)
            }else{
                let titleLabel = UILabel(frame: CGRect(x: CGFloat(i) * SCREEN_WIDTH / 3, y: 0, width: SCREEN_WIDTH / 3, height: 50))
                titleLabel.textAlignment = .center
                titleLabel.font = UIFont.customFont(ofSize: 14)
                titleLabel.backgroundColor = UIColor.white
                titleLabel.text = tempTopArray[i]
                pickerView.addSubview(titleLabel)
            }
        }
    }

    //初始化界面
    func initView() {
        let bgscrollview = UIScrollView(frame: self.bgView.bounds)
        self.bgView.addSubview(bgscrollview)

        tempBgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 56*4))
        tempBgView.backgroundColor = UIColor.white
        bgscrollview.addSubview(tempBgView)

        bottomView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 56*4))
        bottomView.backgroundColor = UIColor.clear
        bgscrollview.addSubview(bottomView)

        let  topTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 28))
        topTitleLabel.font = UIFont.customFont(ofSize: 14)
        topTitleLabel.textColor = UIColor.hex("f6a623")
        topTitleLabel.textAlignment = .center
        topTitleLabel.backgroundColor = UIColor.hex("fff4e1")
        topTitleLabel.text = "钢票网携手银行开通资金存管服务"
        tempBgView.addSubview(topTitleLabel)

        var maxHeight = topTitleLabel.maxY
        for i in 0 ..< contentArray.count {
            if i == 0 || i == 3 {
                let  tempLabel = UILabel(frame: CGRect(x: 0, y: maxHeight, width: SCREEN_WIDTH, height: 42))
                tempLabel.backgroundColor = UIColor.hex("f3f3f3")
                tempLabel.textAlignment = .center
                tempLabel.font = UIFont.customFont(ofSize: 16)
                tempLabel.textColor = UIColor.hex("666666")
                tempLabel.text = contentArray[i]["name"]
                tempBgView.addSubview(tempLabel)
                maxHeight = tempLabel.maxY
            }else{
                let  line = UIView(frame: CGRect(x: 16, y: maxHeight, width: SCREEN_WIDTH - 16, height: 1))
                line.backgroundColor = UIColor.hex("f3f3f3")
                tempBgView.addSubview(line)
                maxHeight = line.maxY
                let  tempLabel = UILabel(frame: CGRect(x: 15, y: maxHeight, width: 82, height: 56))
                tempLabel.font = UIFont.customFont(ofSize: 16)
                tempLabel.textColor = UIColor.hex("333333")
                tempLabel.text = contentArray[i]["name"]
                tempBgView.addSubview(tempLabel)

                let textField = UITextField(frame: CGRect(x: tempLabel.maxX + 16, y: CGFloat(maxHeight), width: SCREEN_WIDTH - tempLabel.maxX - 32, height: 56))
                textField.font = UIFont.customFont(ofSize: 16)
                textField.tag = 1000 + i
                textField.textColor = UIColor.hex("333333")
                textField.placeholder = contentArray[i]["title"]
                tempBgView.addSubview(textField)
                if  i == 4{
                    textField.keyboardType = .numberPad
                    textField.delegate = self
                }else if i == 2 {
                    textField.keyboardType = .numbersAndPunctuation
                }
                maxHeight = textField.maxY
            }
        }

        bankLabel = UILabel(frame: CGRect(x: 32 + 82, y: maxHeight - 5, width: SCREEN_WIDTH - 16 - 32 - 55, height: 0))
        bankLabel.text = "工商银行"
        bankLabel.textColor = redColor
        bankLabel.font = UIFont.customFont(ofSize: 14)
        tempBgView.addSubview(bankLabel)
        tempBgView.height = maxHeight

        //底部
        bottomView.y = maxHeight
        maxHeight = 0
        let  bottomArray = [
            ["name":"   预留手机号","title":"请输入预留手机号"],
            ["name":"   开户地区","title":"请选择开户地区"]
        ]
        for i in 0 ..< bottomArray.count {
            let  line = UIView(frame: CGRect(x: 16, y: maxHeight, width: SCREEN_WIDTH - 16, height: 1))
            line.backgroundColor = UIColor.hex("f3f3f3")
            bottomView.addSubview(line)
            maxHeight = line.maxY
            let  tempLabel = UILabel(frame: CGRect(x: 0, y: maxHeight, width: 82 + 31, height: 56 ))
            tempLabel.font = UIFont.customFont(ofSize: 16)
            tempLabel.backgroundColor = UIColor.white
            tempLabel.textColor = UIColor.hex("333333")
            tempLabel.text = bottomArray[i]["name"]
            bottomView.addSubview(tempLabel)

            let textField = UITextField(frame: CGRect(x: tempLabel.maxX, y: CGFloat(maxHeight), width: SCREEN_WIDTH - tempLabel.maxX, height: 56))
            textField.backgroundColor = UIColor.white
            textField.font = UIFont.customFont(ofSize: 16)
            textField.tag = 1000 + i
            textField.textColor = UIColor.hex("333333")
            textField.placeholder = bottomArray[i]["title"]
            bottomView.addSubview(textField)
            if  i == 0{
                textField.keyboardType = .numberPad
            }else{
                let imgView = UIImageView(frame:CGRect(x: SCREEN_WIDTH - 16 - 18 , y: textField.y, width: 18, height: 8))
                imgView.image = UIImage(named:"user_realname_city")
                imgView.centerY = textField.centerY
                bottomView.addSubview(imgView)

                let  textBtn = UIButton(type: .custom)
                textBtn.frame = CGRect(x: textField.x, y: textField.y, width: SCREEN_WIDTH - textField.x, height: textField.height)
                textBtn.addTarget(self, action: #selector(self.pickShowOrHideClick), for: .touchUpInside)
                bottomView.addSubview(textBtn)
            }
            maxHeight = textField.maxY
        }
        //限额列表按钮
        let bankBtn = UIButton(type: .custom)
        bankBtn.frame = CGRect(x: 0, y: maxHeight + 6, width: SCREEN_WIDTH, height: 18 + 14 + 18)
        bankBtn.setTitle("查看支持银行及限额 >", for: .normal)
        bankBtn.addTarget(self, action: #selector(self.bankQ), for: .touchUpInside)
        bankBtn.titleLabel?.font = UIFont.customFont(ofSize: 14)
        bankBtn.setTitleColor(UIColor.hex("f6390c"), for: .normal)
        bottomView.addSubview(bankBtn)

        let  btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 16, y:  bankBtn.maxY, width: SCREEN_WIDTH - 32, height: 64)
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.setTitle("确定", for: .normal)
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        bottomView.addSubview(btn)

        bottomView.height = btn.maxY + 10

        bgscrollview.contentSize = CGSize(width: SCREEN_WIDTH , height: SCREEN_HEIGHT + 140)
    }

    @objc func bankQ() {
        self.navigationController?.pushViewController(GPWBankQuotaViewController(), animated: true)
    }

    @objc func btnClick() {

        //Auth_user
        var dic = [String:String]()
        //姓名
        let temp1Str = (self.tempBgView.viewWithTag(NAMETAG) as! UITextField).text ?? ""
        if temp1Str.characters.count < 2 {
            bgView.makeToast("请输入真实姓名")
            return
        }
        dic["name"] = temp1Str

        //身份证号
        let temp2Str = (self.tempBgView.viewWithTag(SHENFENTAG) as! UITextField).text ?? ""
        let regex = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluate(with: temp2Str) {
            dic["idcard"] = temp2Str
        }else{
            bgView.makeToast("请输入正确身份证")
            return
        }

        //银行卡
        let temp3Str = (self.tempBgView.viewWithTag(BANKTAG) as! UITextField).text ?? ""

        if temp3Str.characters.count >= 15 && temp3Str.characters.count <= 19 {
            dic["banck"] = temp3Str
        }else{
            bgView.makeToast("不支持或错误的银行卡号")
            return
        }
        
        if self.abbreviation == ""{
            bgView.makeToast("不支持或错误的银行卡号")
            return
        }


        //开户行名称
        dic["parent_bank_id"] = self.abbreviation

        //手机号
        let temp4Str = (self.bottomView.viewWithTag(PHONETAG) as! UITextField).text ?? ""
        if GPWHelper.judgePhoneNum(temp4Str)  {
            dic["phone"] = temp4Str
        }else{
            bgView.makeToast("请输入正确手机号")
            return
        }

        //开户城市
        let temp5Str = (self.bottomView.viewWithTag(AREATAG) as! UITextField).text ?? ""
        if temp5Str.characters.count > 2  {
            //城市id
            dic["city_id"] = "\(cityCode ?? 0)"
        }else{
            bgView.makeToast("请选择开户城市")
            return
        }

        //用户id
        dic["user_id"] = "\(String(describing: GPWUser.sharedInstance().user_id ?? 0))"

        printLog(message: dic)
        MobClick.event("certification_button", label: nil)
        GPWNetwork.requetWithPost(url: Auth_user, parameters: dic, responseJSON:  {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            printLog(message: json)
            GPWUser.sharedInstance().getUserInfo()
            //实名认证成功
            GPWHelper.authNameSucess()
            for vc in strongSelf.navigationController!.viewControllers {
                if vc.isKind(of: GPWProjectDetailViewController.self) {
                    _ = strongSelf.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
            _ = strongSelf.navigationController?.popToRootViewController(animated: true)
            }, failure: {
                [weak self] (error) in
                guard let strongSelf = self else { return }
                 strongSelf.navigationController?.pushViewController(GPWFailController(type: FailType.CUNGUANTYPE, tip: GPWGlobal.sharedInstance().msg), animated: true)
        })
    }
    override func back(sender: GPWButton) {
        if type == "shenfen"{
            _ = self.navigationController?.popToRootViewController(animated: true)
            GPWHelper.selectTabBar(index: MINEBARTAG)
        }else{
            if let viewControllers = self.navigationController?.viewControllers {
                for vc in viewControllers {
                    if vc.isKind(of: GPWProjectDetailViewController.self) {
                        _ = self.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    @objc func pickShowOrHideClick() {
        for subView in tempBgView.subviews {
            if subView.isKind(of: UITextField.self){
                subView.resignFirstResponder()
            }
        }

        for subView in bottomView.subviews {
            if subView.isKind(of: UITextField.self){
                subView.resignFirstResponder()
            }
        }

        if showPickViewFlag {
            //展示
            self.bgVickerView.isHidden = showPickViewFlag
            showPickViewFlag = false

        }else{
            //隐藏
             self.bgVickerView.isHidden = showPickViewFlag
            self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
            showPickViewFlag = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UserReadInfoViewController{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let  tempStr = textField.text ?? ""
        var maxHeight:CGFloat = 0.00

        if tempStr.characters.count < 15 || tempStr.characters.count > 19 {
            bankLabel.height = 0
            maxHeight = bankLabel.maxY + 5
            tempBgView.height = maxHeight
            bottomView.y = tempBgView.maxY
            return
        }

        GPWNetwork.requetWithGet(url: "https://v.apistore.cn/api/v4/bankCard/", parameters: ["key":"953cdcb6c61be3aeac141a1daa9d57c7","bankcard":tempStr], responseJSON: {
            [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.bankLabel.text = json["bankname"].stringValue + "·" + json["cardtype"].stringValue
            let tempAbb = strongSelf.bankCodeArray[json["abbreviation"].stringValue] ?? ""

            if tempAbb  == "" {
                strongSelf.bankLabel.height = 0
                maxHeight = strongSelf.bankLabel.maxY + 5
                strongSelf.tempBgView.height = maxHeight
                strongSelf.bottomView.y = strongSelf.tempBgView.maxY
            }else{
                strongSelf.abbreviation = strongSelf.bankCodeArray[json["abbreviation"].stringValue] ?? ""
                strongSelf.bankLabel.height = 22
                maxHeight = strongSelf.bankLabel.maxY + 3
                strongSelf.tempBgView.height = maxHeight
                strongSelf.bottomView.y = strongSelf.tempBgView.maxY
            }

        }) {   [weak self] msg in
            guard let strongSelf = self else { return }
            strongSelf.bankLabel.height = 0
            maxHeight = strongSelf.bankLabel.maxY + 5
            strongSelf.tempBgView.height = maxHeight
            strongSelf.bottomView.y = strongSelf.tempBgView.maxY
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if cityArray?.count == 0{
            return 0
        }
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return cityArray?.count ?? 0
        }else if component == 1{
            return cityArray?[proIndex]["city"].array?.count ?? 0
        }else{
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH / 3, height: 14 * 3))
        titleLabel.font = UIFont.customFont(ofSize: 15)
        titleLabel.textAlignment = .center
        if component == 0 {
            titleLabel.text = cityArray?[row]["name"].stringValue
        }else if component == 1{
            titleLabel.text = cityArray?[proIndex]["city"][row]["name"].stringValue
        }else{
            titleLabel.text =  "       "
        }
        return titleLabel
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         let textField = bottomView.viewWithTag(1001) as! UITextField
        if component == 0 {
           proIndex = row
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            let pro = cityArray?[row]["name"].stringValue ?? ""
            textField.text = pro + ( cityArray?[proIndex]["city"][0]["name"].stringValue ?? "" )
            cityCode = cityArray?[proIndex]["city"][0]["code"].intValue ?? 00
        }else if component == 1 {
            let pro = cityArray?[proIndex]["name"].stringValue ?? ""
            let city = cityArray?[proIndex]["city"][row]["name"].stringValue ?? ""
            cityCode = cityArray?[proIndex]["city"][row]["code"].intValue ?? 00
            textField.text = pro + city
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREEN_WIDTH / 3
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 14 + 14 + 14
    }
}


