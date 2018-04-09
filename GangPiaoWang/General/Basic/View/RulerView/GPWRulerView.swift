//
//  GPWRulerView.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/8.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

fileprivate struct Distance {
    static let leftAndRight: CGFloat = 8   //标尺左右距离
    static var value:CGFloat = 8      //刻度实际长度
    static let topAndBottom: CGFloat = 20   //标尺上下距离
}

@objc protocol GPWRulerDelegate: NSObjectProtocol {
    //声明方法
    @objc optional func ruler(_ rulerScrollView: GPWRulerScrollView)
}

class GPWRulerView: UIView, UIScrollViewDelegate {
    var a: ((String) -> Void)?
    weak var delegete: GPWRulerDelegate?
    lazy var rulerScrollView: GPWRulerScrollView = {
        let scrollView: GPWRulerScrollView = GPWRulerScrollView(frame: CGRect.zero)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    /*
     *  count * average = 刻度最大值
     *  @param count        10个小刻度为一个大刻度
     *  @param average      每个小刻度的值，最小精度 0.1
     *  @param currentValue 直尺初始化的刻度值
     */
    init(frame: CGRect, count: Int, average: Int, currentValue: Int, minMultiple: Int) {
        super.init(frame: frame)
        if Int(frame.width / Distance.value) > count {
            Distance.value = CGFloat(Int(frame.width) / count)
        }
        rulerScrollView.frame = frame
        rulerScrollView.rulerAverage = average
        rulerScrollView.rulerCount = count
        rulerScrollView.rulerValue = currentValue
        rulerScrollView.minMultiple = minMultiple
        rulerScrollView.drawRuler()
        self.addSubview(rulerScrollView)
        drawline()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!;
        fatalError("init(coder:) has not been implemented")
    }
    //中间标示线
   private func drawline() {
        let pathLine: CGMutablePath = CGMutablePath()
        let shapeLayerLine: CAShapeLayer = CAShapeLayer.init()
        shapeLayerLine.strokeColor = UIColor.red.cgColor
        shapeLayerLine.fillColor = UIColor.red.cgColor
        shapeLayerLine.lineWidth = 1.0
        shapeLayerLine.lineCap = kCALineCapSquare
        
        pathLine.move(to: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height - Distance.topAndBottom - 20))
        pathLine.addLine(to: CGPoint(x: self.frame.size.width / 2, y: Distance.topAndBottom + 8))
        shapeLayerLine.path = pathLine
        self.layer.addSublayer(shapeLayerLine)
    }
    
    //MARK: ScrollView Delegete
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollView = scrollView as! GPWRulerScrollView
        let offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - Distance.leftAndRight
        let rulerValue: Int = Int(offSetX / Distance.value) * scrollView.rulerAverage
        if rulerValue < 0 {
            return
        } else if (rulerValue > scrollView.rulerCount * scrollView.rulerAverage) {
            return
        }
      
        if delegete != nil {
            scrollView.rulerValue = rulerValue
            if delegete!.responds(to: #selector(GPWRulerDelegate.ruler(_:))) {
                delegete!.ruler!(scrollView)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.animationRebound((scrollView as? GPWRulerScrollView)!)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.animationRebound((scrollView as? GPWRulerScrollView)!)
    }
    
    func animationRebound(_ scrollView: GPWRulerScrollView) {
        let offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - Distance.leftAndRight
        let rulerValue: Int = Int(offSetX / Distance.value) * scrollView.rulerAverage
        let x: Int = rulerValue / scrollView.rulerAverage * Int(Distance.value) - Int(self.frame.size.width / 2) + Int(Distance.leftAndRight)
        UIView.animate(withDuration: 0.2) { () -> Void in
            scrollView.contentOffset = CGPoint(x: x, y: 0)
        }
    }
}

 //MARK: /*************尺子滚动视图***************
class GPWRulerScrollView: UIScrollView {
    var rulerCount: Int = 100
    var rulerAverage: Int = 100
    var rulerHeight: Int = 100
    var rulerWidth: Int = Int(UIScreen.main.bounds.width)
    var rulerValue: Int = 0
    var minMultiple: Int = 0
    
    func drawRuler() {
        let pathRef1 = CGMutablePath()
        let pathRef2 = CGMutablePath()
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.lineWidth = 1
        shapeLayer1.lineCap = kCALineCapButt
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.strokeColor = UIColor.lightGray.cgColor
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.lineWidth = 1
        shapeLayer2.lineCap = kCALineCapButt
        
        for index in 0...rulerCount {
            let rule: UILabel = UILabel.init()
            rule.textColor = UIColor.black
            rule.text = String(format: "%d", index * rulerAverage)
            guard let text = rule.text else {
                return
            }
            let textSize = text.size(attributes: [NSFontAttributeName: rule.font])
            
            //主要刻度
            if index % 10 == 0 {
                pathRef2.move(to: CGPoint(x: Distance.leftAndRight + Distance.value * CGFloat(index) , y: Distance.topAndBottom))
                pathRef2.addLine(to: CGPoint(x: Distance.leftAndRight + Distance.value * CGFloat(index), y: CGFloat(rulerHeight) - Distance.topAndBottom - textSize.height))
                rule.frame = CGRect(x: Distance.leftAndRight + Distance.value * CGFloat(index) - textSize.width / 2, y: CGFloat(rulerHeight) - Distance.topAndBottom - textSize.height, width: 0, height: 0)
                rule.sizeToFit()
                self.addSubview(rule)
            }
                //中间刻度
            else if index % 5 == 0 {
                pathRef1.move(to: CGPoint(x: Distance.leftAndRight + Distance.value * CGFloat(index), y: Distance.topAndBottom + 10))
                pathRef1.addLine(to: CGPoint(x: Distance.leftAndRight + Distance.value * CGFloat(index), y: CGFloat(rulerHeight) - Distance.topAndBottom - textSize.height))
            }
                //正常刻度
            else {
                pathRef1.move(to: CGPoint(x: Distance.leftAndRight + Distance.value * CGFloat(index), y: Distance.topAndBottom + 20))
                pathRef1.addLine(to: CGPoint(x: Distance.leftAndRight + Distance.value * CGFloat(index), y: CGFloat(rulerHeight) - Distance.topAndBottom - textSize.height))
            }
        }
        
        shapeLayer1.path = pathRef1
        shapeLayer2.path = pathRef2
        self.layer.addSublayer(shapeLayer1)
        self.layer.addSublayer(shapeLayer2)
        
        self.frame = CGRect(x: 0, y: 0, width: CGFloat(rulerWidth), height: CGFloat(rulerHeight))
        
        let edge: UIEdgeInsets = UIEdgeInsetsMake(0, CGFloat(rulerWidth) / 2 - Distance.leftAndRight - Distance.value * CGFloat(minMultiple), 0, CGFloat(rulerWidth) / 2 - Distance.leftAndRight)
        self.contentInset = edge
        self.contentOffset = CGPoint(x: Distance.value * (CGFloat(rulerValue) / CGFloat(rulerAverage)) - CGFloat(rulerWidth) / 2 + Distance.leftAndRight, y: 0)
        self.contentSize = CGSize(width: CGFloat(rulerCount) * Distance.value + Distance.leftAndRight * 2, height: CGFloat(rulerHeight))
    }
}
