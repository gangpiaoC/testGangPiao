//
//  PullToRefreshHeader.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

public enum RefreshKitHeaderText{
    case pullToRefresh
    case releaseToRefresh
    case refreshSuccess
    case refreshFailure
    case refreshing
}
/**
 Header所处的状态
 
 - Idle:        最初
 - Pulling:     下拉
 - Refreshing:  正在刷新中
 - WillRefresh: 将要刷新
 */
@objc public enum RefreshHeaderState:Int{
    case idle = 0
    case pulling = 1
    case refreshing = 2
    case willRefresh = 3
}

open class RefreshHeaderContainer:UIView{
    // MARK: - Propertys -
    var refreshAction:(()->())?
    var attachedScrollView:UIScrollView!
    var originalInset:UIEdgeInsets?
    var durationOfEndRefreshing = 0.4
    weak var delegate:RefreshableHeader?
    fileprivate var currentResult:RefreshResult = .none
    fileprivate var _state:RefreshHeaderState = .idle
    fileprivate var insetTDelta:CGFloat = 0.0
    fileprivate var state:RefreshHeaderState{
        get{
            return _state
        }
        set{
            guard newValue != _state else{
                return
            }
            self.delegate?.stateDidChanged?(_state,newState: newValue)
            let oldValue = _state
            _state =  newValue
            switch newValue {
            case .idle:
                guard oldValue == .refreshing else{
                    return
                }
                UIView.animate(withDuration: durationOfEndRefreshing, animations: {
                    var oldInset = self.attachedScrollView.contentInset
                    oldInset.top = oldInset.top + self.insetTDelta
                    self.attachedScrollView.contentInset = oldInset
                    
                    }, completion: { (finished) in
                        self.delegate?.didCompleteEndRefershingAnimation(self.currentResult)
                })
                PullToRefreshKitBool.isLoading = false
            case .refreshing:
                DispatchQueue.main.async(execute: {
                    let insetHeight = (self.delegate?.heightForRefreshingState())!
                    var fireHeight:CGFloat! = self.delegate?.heightForFireRefreshing?()
                    if fireHeight == nil{
                        fireHeight = insetHeight
                    }
                    let offSetY = self.attachedScrollView.contentOffset.y
                    let topShowOffsetY = -1.0 * self.originalInset!.top
                    let normal2pullingOffsetY = topShowOffsetY - fireHeight
                    let currentOffset = self.attachedScrollView.contentOffset
                    UIView.animate(withDuration: 0.4, animations: {
                        let top = (self.originalInset?.top)! + insetHeight
                        var oldInset = self.attachedScrollView.contentInset
                        oldInset.top = top
                        self.attachedScrollView.contentInset = oldInset
                        if offSetY > normal2pullingOffsetY{ //手动触发
                            self.attachedScrollView.contentOffset = CGPoint(x: 0, y: -1.0 * top)
                        }else{//release，防止跳动
                            self.attachedScrollView.contentOffset = currentOffset
                        }
                        }, completion: { (finsihed) in
                            if PullToRefreshKitBool.isLoading {
                                return
                            }
                            PullToRefreshKitBool.isLoading = true
                            self.refreshAction?()
                    })
                    self.delegate?.percentUpdateDuringScrolling?(1.0)
                    if !PullToRefreshKitBool.isLoading {
                        self.delegate?.didBeginRefreshingState()
                    }
                })
            default:
                break
            }
        }
    }
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit(){
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = .flexibleWidth
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life circle -
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            self.state = .refreshing
        }
    }
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview is UIScrollView else{
            return;
        }
        attachedScrollView = newSuperview as? UIScrollView
        attachedScrollView.alwaysBounceVertical = true
        originalInset = attachedScrollView?.contentInset
        addObservers()
    }
    deinit{
        removeObservers()
    }
    // MARK: - Private -
    fileprivate func addObservers(){
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathOffSet, options: [.old,.new], context: nil)
    }
    fileprivate func removeObservers(){
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathOffSet,context: nil)
    }
    func handleScrollOffSetChange(_ change: [NSKeyValueChangeKey : Any]?){
        let insetHeight = (self.delegate?.heightForRefreshingState())!
        var fireHeight:CGFloat! = self.delegate?.heightForFireRefreshing?()
        if fireHeight == nil{
            fireHeight = insetHeight
        }
        if state == .refreshing {
//Refer from here https://github.com/CoderMJLee/MJRefresh/blob/master/MJRefresh/Base/MJRefreshHeader.m, thanks to this lib again
            guard self.window != nil else{
                return
            }
            let offset = attachedScrollView.contentOffset
            let inset = originalInset!
            var insetT = -1 * offset.y > inset.top ? (-1 * offset.y):inset.top
            insetT = insetT > insetHeight + inset.top ? insetHeight + inset.top:insetT
            var oldInset = attachedScrollView.contentInset
            oldInset.top = insetT
            attachedScrollView.contentInset = oldInset
            insetTDelta = inset.top - insetT
            return;
        }
        
        originalInset =  attachedScrollView.contentInset
        let offSetY = attachedScrollView.contentOffset.y
        let topShowOffsetY = -1.0 * originalInset!.top
        guard offSetY <= topShowOffsetY else{
            return
        }
        let normal2pullingOffsetY = topShowOffsetY - fireHeight
        if attachedScrollView.isDragging {
            if state == .idle && offSetY < normal2pullingOffsetY {
                self.state = .pulling
            }else if state == .pulling && offSetY >= normal2pullingOffsetY{
                state = .idle
            }
        }else if state == .pulling{
            beginRefreshing()
            return
        }
        let percent = (topShowOffsetY - offSetY)/fireHeight
        //防止在结束刷新的时候，percent的跳跃
        if let oldOffset = (change?[NSKeyValueChangeKey.oldKey] as AnyObject).cgPointValue{
            let oldPercent = (topShowOffsetY - oldOffset.y)/fireHeight
            if oldPercent >= 1.0 && percent == 0.0{
                return
            }else{
                self.delegate?.percentUpdateDuringScrolling?(percent)
            }
        }else{
            self.delegate?.percentUpdateDuringScrolling?(percent)
        }
    }
    // MARK: - KVO -
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard self.isUserInteractionEnabled else{
            return;
        }
        if keyPath == PullToRefreshKitConst.KPathOffSet {
            handleScrollOffSetChange(change)
        }
    }
    // MARK: - API -
    func beginRefreshing(){
        if self.window != nil {
            self.state = .refreshing
        }else{
            if state != .refreshing{
                self.state = .willRefresh
            }
        }
    }
    func updateStateToIdea(){
        self.state = .idle
    }
    func endRefreshing(_ result:RefreshResult,delay:TimeInterval = 0.0){
        self.delegate?.didBeginEndRefershingAnimation(result)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: { [weak self] in
            self?.updateStateToIdea()
        })
    }
}



