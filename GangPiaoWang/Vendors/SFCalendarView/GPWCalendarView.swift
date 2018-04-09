//
//  GPWCalendarView.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/28.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
typealias callbackfunc = (_ itemArray:[JSON],_ waitAmount:String,_ returnAmount:String)->Void
class GPWCalendarView: UIView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topLab:UILabel!
    fileprivate var topRTLab:RTLabel!
    @IBOutlet weak var topRightViewContent:UIView!
    @IBOutlet weak var headerViewContent:UIView!
    @IBOutlet weak var collectionView:UICollectionView!
    fileprivate var headerView:SFCalendarCell!
    fileprivate var topRightView:SFCalendarCell!
    fileprivate var dataArray:[SFCalendarModel]!
    fileprivate var headerModel:SFCalendarModel!
    fileprivate var topRightModel:SFCalendarModel!
    fileprivate var dicArray:[JSON]?

    var callBack:callbackfunc?
    override func awakeFromNib() {
        super.awakeFromNib()
        dataArray = SFCalendarManager.shareInstance().getCalendarData()
        headerModel = SFCalendarManager.shareInstance().getWeekdayData()
        topRightModel = SFCalendarManager.shareInstance().getMonthData()

        self.collectionView.register(UINib(nibName: "SFCalendarCell", bundle: nil), forCellWithReuseIdentifier: "SFCalendarCell")

        //设置月份
        self.topRightView = Bundle.main.loadNibNamed("SFCalendarCell", owner: nil, options: nil)?.first as! SFCalendarCell
        self.topRightView.collectionView.backgroundColor = UIColor.hex("fa481a")
        self.topRightView.type = .top
        self.topRightView.model = self.topRightModel

        let collectionView = self.topRightView.getCollectionView()
        let flowLayout = collectionView?.collectionViewLayout  as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        self.collectionView.isScrollEnabled = true

        self.topRightViewContent.addSubview(self.topRightView)

         self.headerView = Bundle.main.loadNibNamed("SFCalendarCell", owner: nil, options: nil)?.first as! SFCalendarCell
        self.headerView.type = .header
        self.headerView.model = self.headerModel
        self.headerViewContent.addSubview(self.headerView)

        let  selectedItm = SFCalendarManager.shareInstance().getSelectedMonthModel()
        self.getNetData(selectItem: selectedItm!)

        //设置年份selectedItem.year
        self.topRTLab = RTLabel(frame: self.topView.bounds)
        self.topRTLab.width = 81
        self.topView.addSubview(self.topRTLab)
        self.topRTLab.text = "<font size=14 color='#ff957a'>\(String(describing: selectedItm?.year ?? "0"))/</font><font size=18 color='#ffffff'>\(selectedItm?.month ?? "0")</font>"
        self.topRTLab.height = self.topRTLab.optimumSize.height
        self.topRTLab.centerY = self.topView.height / 2
        self.topView.backgroundColor = UIColor.hex("fa481a")
        self.topView.backgroundColor = UIColor.hex("fa481a")
        self.topRTLab.textAlignment = RTTextAlignmentCenter


        SFCalendarManager.shareInstance().itemUpdate { [weak self] (type) in
            guard let strongSelf = self else { return }
            for (_,view) in strongSelf.collectionView.subviews.enumerated() {
                if view.isKind(of: SFCalendarCell.self) {
                    let  tempCell = view as! SFCalendarCell
                    tempCell.updateUI()
                }
            }

            switch (type) {
            case .current :
                printLog(message: "选择的当前item")
                let selectItem = SFCalendarManager.shareInstance().getSelectedItemModel()
                let array = strongSelf.dicArray?[Int(NSDate.day(selectItem?.date)) - 1]["date_info"].arrayValue
                strongSelf.callBack?(array!, "1","1")
                break
            case .unknown:
                break
            case .up:
                let selectItem = SFCalendarManager.shareInstance().getSelectedItemModel()
                if Int(selectItem?.index ?? 0) >= 0 && Int(selectItem?.index ?? 0) < KCalendarMonthCount {
                    let indexPath = IndexPath.init(row: (selectItem?.index)!, section: 0)
                    strongSelf.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
                break

            case .down:
                let selectItem = SFCalendarManager.shareInstance().getSelectedItemModel()
                if Int(selectItem?.index ?? 0) >= 0 && Int(selectItem?.index ?? 0) < KCalendarMonthCount {
                    let indexPath = IndexPath.init(row: (selectItem?.index ?? 0), section: 0)
                    strongSelf.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
                break
            case .week:
                break
            case .month:
                let selectItem = SFCalendarManager.shareInstance().getSelectedMonthModel()
                strongSelf.topRTLab.text =  "<font size=14 color='#ff957a'>\(String(describing: selectItem?.year ?? "0"))/</font><font size=18 color='#ffffff'>\(selectItem?.month ?? "0")</font>"
                if Int(selectItem?.index ?? 0) >= 0 && Int(selectItem?.index ?? 0) < KCalendarMonthCount {
                    let indexPath = IndexPath.init(row: selectItem?.index ?? 0, section: 0)
                    strongSelf.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    strongSelf.topRightView.getCollectionView().scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                }
                strongSelf.getNetData(selectItem: selectItem!)
                 strongSelf.topRightView.updateUI()
                break
            case .itemSlide:
                let selectItem = SFCalendarManager.shareInstance().getSelectedMonthModel()
                strongSelf.topRTLab.text =  "<font size=14 color='#ff957a'>\(String(describing: selectItem?.year ?? "0"))/</font><font size=18 color='#ffffff'>\(selectItem?.month ?? "0")</font>"
                if Int(selectItem?.index ?? 0) >= 0 && Int(selectItem?.index ?? 0) < KCalendarMonthCount {
                    let indexPath = IndexPath.init(row: selectItem?.index ?? 0, section: 0)
                    strongSelf.topRightView.getCollectionView().scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
                strongSelf.getNetData(selectItem: selectItem!)
                strongSelf.topRightView.updateUI()
                break
            case .topSlide:
                break
            }
        }
    }

    func getNetData(selectItem:SFCalendarItemModel) {
        GPWNetwork.requetWithGet(url: Api_refund_calendar, parameters:["user_id":GPWUser.sharedInstance().user_id ?? "000000","date":"\(selectItem.year ?? "2017")-\(selectItem.month ?? "01")"], responseJSON: {
            [weak self] (json, msg) in
            printLog(message: json)
             guard let strongSelf = self else { return }
            let temp = SFCalendarManager.shareInstance().getCalendarData()
            let  temp1 = temp?[selectItem.index]
            var temitemArray = [JSON]()
            strongSelf.dicArray = json["date"].arrayValue
            for i in 0 ..< Int(json["date"].arrayValue.count) {
                var itemModel:SFCalendarItemModel?
                for item in (temp1?.dataArray)! {
                    if i == NSDate.day(item.date) - 1 && item.type == .current {
                        itemModel = item
                        break
                    }
                }
                let  count = json["date"].arrayValue[i]["date_info"].arrayValue.count
                if count > 0 {
                    itemModel?.isNormalSelected = true
                    temitemArray = temitemArray + json["date"].arrayValue[i]["date_info"].arrayValue
                }
            }
            printLog(message: "qwqwqwqwq==\(temitemArray)")
            strongSelf.collectionView.reloadData()
            strongSelf.callBack?(temitemArray,json["wait_refund_amount"].stringValue,json["refund_amount"].stringValue)
        }) { (error) in

        }

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.headerView.frame = self.headerViewContent.bounds
        self.topRightView.frame = self.topRightViewContent.bounds
    }

    // UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SFCalendarCell", for: indexPath) as? SFCalendarCell
        cell?.model = self.dataArray[indexPath.row]
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.width, height: self.collectionView.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.width
        let currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        SFCalendarManager.shareInstance().updateSelectedMonthIndex(Int(currentPage))
    }
}
