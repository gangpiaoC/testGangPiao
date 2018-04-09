//
//  DefaultRefreshFooter.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/28.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

open class DefaultRefreshFooter:UIView,RefreshableFooter{
    open let spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    open  let textLabel:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: 140,height: 40)).SetUp {
        $0.font = UIFont.customFont(ofSize: 14)
        $0.textAlignment = .center
    }
    /// 触发刷新的模式
    open var refreshMode = RefreshMode.scrollAndTap{
        didSet{
            tap.isEnabled = (refreshMode != .scroll)
            udpateTextLabelWithMode(refreshMode)
        }
    }
    fileprivate func udpateTextLabelWithMode(_ refreshMode:RefreshMode){
        switch refreshMode {
        case .scroll:
            textLabel.text = textDic[.pullToRefresh]
        case .tap:
            textLabel.text = textDic[.tapToRefresh]
        case .scrollAndTap:
            textLabel.text = textDic[.scrollAndTapToRefresh]
        }
    }
    fileprivate var tap:UITapGestureRecognizer!
    fileprivate var textDic = [RefreshKitFooterText:String]()
    /**
     This function can only be called before Refreshing
     */
    open  func setText(_ text:String,mode:RefreshKitFooterText){
        textDic[mode] = text
        textLabel.text = textDic[.pullToRefresh]
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        addSubview(textLabel)
        
        textDic[.pullToRefresh] = PullToRefreshKitFooterString.pullUpToRefresh
        textDic[.refreshing] = PullToRefreshKitFooterString.refreshing
        textDic[.noMoreData] = PullToRefreshKitFooterString.noMoreData
        textDic[.tapToRefresh] = PullToRefreshKitFooterString.tapToRefresh
        textDic[.scrollAndTapToRefresh] = PullToRefreshKitFooterString.scrollAndTapToRefresh
        udpateTextLabelWithMode(refreshMode)
        tap = UITapGestureRecognizer(target: self, action: #selector(DefaultRefreshFooter.catchTap(_:)))
        self.addGestureRecognizer(tap)
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2);
        spinner.center = CGPoint(x: frame.width/2 - 70 - 20, y: frame.size.height/2)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func catchTap(_ tap:UITapGestureRecognizer){
        let scrollView = self.superview?.superview as? UIScrollView
        scrollView?.beginFooterRefreshing()
    }
    // MARK: - Refreshable  -
    open func heightForRefreshingState() -> CGFloat {
        return PullToRefreshKitConst.defaultFooterHeight
    }
    open func didBeginRefreshing() {
        textLabel.text = textDic[.refreshing];
        spinner.startAnimating()
    }
    open func didEndRefreshing() {
        udpateTextLabelWithMode(refreshMode)
        spinner.stopAnimating()
    }
    open func didUpdateToNoMoreData(){
        textLabel.text = textDic[.noMoreData]
    }
    open func didResetToDefault() {
        udpateTextLabelWithMode(refreshMode)
    }
    open func shouldBeginRefreshingWhenScroll()->Bool {
        return refreshMode != .tap
    }
    // MARK: - Handle touch -
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard refreshMode != .scroll else{
            return
        }
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard refreshMode != .scroll else{
            return
        }
        self.backgroundColor = UIColor.white
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard refreshMode != .scroll else{
            return
        }
        self.backgroundColor = UIColor.white
    }
}
