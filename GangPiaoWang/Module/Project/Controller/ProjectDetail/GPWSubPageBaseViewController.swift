//
//  GPWSubPageBaseViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWSubPageBaseViewController: UIViewController, UIScrollViewDelegate {
    var refresh: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -60 {
            if let refresh = refresh {
                refresh()
            }
        }
    }
}
