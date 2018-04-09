//
//  DefaultRefreshHeader.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/28.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

open class DefaultRefreshHeader:UIView,RefreshableHeader{
    open let textLabel:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: 20))
    fileprivate var  startImgView:UIImageView!
    fileprivate var pulImgView:UIImageView!
    open var durationWhenHide = 0.5
    fileprivate var textDic = [RefreshKitHeaderText:String]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addSubview(textLabel)
        pulImgView = UIImageView(frame: CGRect(x: 0, y: 15, width: 45, height: 45))
        pulImgView.centerX = SCREEN_WIDTH / 2

        startImgView = UIImageView(frame: pulImgView.frame)
        textLabel.y = startImgView.maxY

        addSubview(pulImgView)
        addSubview(startImgView)

        pulImgView.image = UIImage.gif(name: "pulling")
        pulImgView.isHidden = true
        startImgView.image = UIImage.gif(name: "pullStart")
        
        textLabel.font = UIFont.customFont(ofSize: 14)
        textLabel.textColor = UIColor.hex("555555")
        textLabel.textAlignment = .center
        self.isHidden = true
        
        //Default text
        textDic[.pullToRefresh] = PullToRefreshKitHeaderString.pullDownToRefresh
        textDic[.releaseToRefresh] = PullToRefreshKitHeaderString.releaseToRefresh
        textDic[.refreshSuccess] = PullToRefreshKitHeaderString.refreshSuccess
        textDic[.refreshFailure] = PullToRefreshKitHeaderString.refreshFailure
        textDic[.refreshing] = PullToRefreshKitHeaderString.refreshing
        textLabel.text = textDic[.pullToRefresh]
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
//        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        imageView.centerX = SCREEN_WIDTH / 2

    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func setText(_ text:String,mode:RefreshKitHeaderText){
        textDic[mode] = text
    }
    // MARK: - Refreshable  -
    open func heightForRefreshingState() -> CGFloat {
        return PullToRefreshKitConst.defaultHeaderHeight
    }
    public func percentUpdateDuringScrolling(_ percent: CGFloat) {
        self.isHidden = false
    }
    public func stateDidChanged(_ oldState: RefreshHeaderState, newState: RefreshHeaderState) {
        printLog(message: "ddddddddd====\(oldState.rawValue)=====\(newState.rawValue)")
        if oldState == RefreshHeaderState.pulling && newState == RefreshHeaderState.refreshing{
            textLabel.text = textDic[.releaseToRefresh]
            startImgView.isHidden = true
            pulImgView.isHidden = false
        }
        if oldState == RefreshHeaderState.refreshing && newState == RefreshHeaderState.idle {
            textLabel.text = textDic[.pullToRefresh]
            startImgView.isHidden = false
            pulImgView.isHidden = true
        }
    }
    open func durationWhenEndRefreshing() -> Double {
        return durationWhenHide
    }
    open func didBeginEndRefershingAnimation(_ result:RefreshResult) {
        switch result {
        case .success:
            textLabel.text = textDic[.refreshSuccess]
           // imageView.image = UIImage(named: "success", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        case .failure:
            textLabel.text = textDic[.refreshFailure]
            //imageView.image = UIImage(named: "failure", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        case .none:
            textLabel.text = textDic[.pullToRefresh]
           // imageView.image = UIImage(named: "arrow_down", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
        }
    }
    open func didCompleteEndRefershingAnimation(_ result:RefreshResult) {
        textLabel.text = textDic[.pullToRefresh]
        self.isHidden = true
       // imageView.image = UIImage(named: "arrow_down", in: Bundle(for: DefaultRefreshHeader.self), compatibleWith: nil)
    }
    open func didBeginRefreshingState() {
        self.isHidden = false
        textLabel.text = textDic[.refreshing]
    }
}
