//
//  Footer.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public enum RefreshKitFooterText{
    case pullToRefresh
    case tapToRefresh
    case scrollAndTapToRefresh
    case refreshing
    case noMoreData
}

public enum RefreshMode{
    /// 只有Scroll才会触发
    case scroll
    /// 只有Tap才会触发
    case tap
    /// Scroll和Tap都会触发
    case scrollAndTap
}

class RefreshFooterContainer:UIView{
    enum RefreshFooterState {
        case idle
        case refreshing
        case willRefresh
        case noMoreData
    }
// MARK: - Propertys -
    var refreshAction:(()->())?
    var attachedScrollView:UIScrollView!
    weak var delegate:RefreshableFooter?
    fileprivate var _state:RefreshFooterState = .idle
    var state:RefreshFooterState{
        get{
            return _state
        }
        set{
            guard newValue != _state else{
                return
            }
            _state =  newValue
            if newValue == .refreshing{
                if PullToRefreshKitBool.isLoading {
                    return
                }
                PullToRefreshKitBool.isLoading = true
                DispatchQueue.main.async(execute: {
                    self.delegate?.didBeginRefreshing()
                    self.refreshAction?()
                })
            }else if newValue == .noMoreData{
                 PullToRefreshKitBool.isLoading = false
                self.delegate?.didUpdateToNoMoreData()
            }else if newValue == .idle{
                PullToRefreshKitBool.isLoading = false
                self.delegate?.didResetToDefault()
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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Life circle -
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            self.state = .refreshing
        }
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil else{ //remove from superview
            if !self.isHidden{
                var inset = attachedScrollView.contentInset
                inset.bottom = inset.bottom - self.frame.height
                attachedScrollView.contentInset = inset
            }
            return
        }
        guard newSuperview is UIScrollView else{
            return
        }
        attachedScrollView = newSuperview as? UIScrollView
        attachedScrollView.alwaysBounceVertical = true
        if !self.isHidden {
            var contentInset = attachedScrollView.contentInset
            contentInset.bottom = contentInset.bottom + self.frame.height
            attachedScrollView.contentInset = contentInset
        }
        self.frame = CGRect(x: 0,y: attachedScrollView.contentSize.height,width: self.frame.width, height: self.frame.height)
        addObservers()
    }
    deinit{
        removeObservers()
    }
    
// MARK: - Private -
    fileprivate func addObservers(){
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathOffSet, options: [.old,.new], context: nil)
        attachedScrollView?.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathContentSize, options:[.old,.new] , context: nil)
        attachedScrollView?.panGestureRecognizer.addObserver(self, forKeyPath:PullToRefreshKitConst.KPathPanState, options:[.old,.new] , context: nil)
    }
    fileprivate func removeObservers(){
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathContentSize,context: nil)
        attachedScrollView?.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathOffSet,context: nil)
        attachedScrollView?.panGestureRecognizer.removeObserver(self, forKeyPath: PullToRefreshKitConst.KPathPanState,context: nil)
    }
    func handleScrollOffSetChange(_ change: [NSKeyValueChangeKey : Any]?){
        if state != .idle && self.frame.origin.y != 0{
            return
        }
        let insetTop = attachedScrollView.contentInset.top
        let contentHeight = attachedScrollView.contentSize.height
        let scrollViewHeight = attachedScrollView.frame.size.height
        if insetTop + contentHeight > scrollViewHeight{
            let offSetY = attachedScrollView.contentOffset.y
            if offSetY > self.frame.origin.y - scrollViewHeight + attachedScrollView.contentInset.bottom{
                let oldOffset = (change?[NSKeyValueChangeKey.oldKey] as AnyObject).cgPointValue
                let newOffset = (change?[NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue
                guard newOffset?.y > oldOffset?.y else{
                    return
                }
                let shouldStart = self.delegate?.shouldBeginRefreshingWhenScroll()
                guard shouldStart! else{
                    return
                }
                beginRefreshing()
            }
        }
    }
    func handlePanStateChange(_ change: [NSKeyValueChangeKey : Any]?){
        guard state == .idle else{
            return
        }
        if attachedScrollView.panGestureRecognizer.state == .ended {
            let scrollInset = attachedScrollView.contentInset
            let scrollOffset = attachedScrollView.contentOffset
            let contentSize = attachedScrollView.contentSize
            if scrollInset.top + contentSize.height <= attachedScrollView.frame.height{
                if scrollOffset.y >= -1 * scrollInset.top {
                    let shouldStart = self.delegate?.shouldBeginRefreshingWhenScroll()
                    guard shouldStart! else{
                        return
                    }
                    beginRefreshing()
                }
            }else{
                if scrollOffset.y > contentSize.height + scrollInset.bottom - attachedScrollView.frame.height {
                    let shouldStart = self.delegate?.shouldBeginRefreshingWhenScroll()
                    guard shouldStart! else{
                        return
                    }
                    beginRefreshing()
                }
            }
        }
    }
    func handleContentSizeChange(_ change: [NSKeyValueChangeKey : Any]?){
        self.frame = CGRect(x: 0,y: self.attachedScrollView.contentSize.height,width: self.frame.size.width,height: self.frame.size.height)
    }
// MARK: - KVO -
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard self.isUserInteractionEnabled else{
            return
        }
        if keyPath == PullToRefreshKitConst.KPathOffSet {
            handleScrollOffSetChange(change)
        }
        guard !self.isHidden else{
            return
        }
        if keyPath == PullToRefreshKitConst.KPathPanState{
            handlePanStateChange(change)
        }
        if keyPath == PullToRefreshKitConst.KPathContentSize {
            handleContentSizeChange(change)
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
    func endRefreshing(){
        self.state = .idle
        self.delegate?.didEndRefreshing()
    }
    func resetToDefault(){
        self.state = .idle
    }
    func updateToNoMoreData(){
        self.state = .noMoreData
    }
}

