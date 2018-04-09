//
//  GPWProjectIntroduceCell3.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWProjectIntroduceCell3: UITableViewCell {
    var imgTap: ((_ index: Int) -> Void)?
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 92, height: 130)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 17
        layout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GPWEvidenceCell.self, forCellWithReuseIdentifier: "EvidenceCell")
        return collectionView
    }()

    var imageUrls = [String]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let indictorView = GPWIndicatorView.indicatorView()
        contentView.addSubview(indictorView)
        
        let headerLabel = UILabel(title: "证明材料", color: titleColor, fontSize: 14)
        contentView.addSubview(headerLabel)
        
        contentView.addSubview(collectionView)
        
        indictorView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(17)
            maker.left.equalTo(contentView).offset(16)
            maker.height.equalTo(14)
            maker.width.equalTo(3)
        }
        
        headerLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(indictorView)
            maker.left.equalTo(indictorView.snp.right).offset(7)
            maker.right.equalTo(contentView)
        }
        
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerLabel.snp.bottom).offset(17)
            maker.left.equalTo(contentView).offset(16)
            maker.right.equalTo(contentView)
            maker.height.equalTo(100)
            maker.bottom.equalTo(contentView)
        }
        
    }
    
    func setupCell(_ dict: [String]) {
        imageUrls = dict
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension GPWProjectIntroduceCell3: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if imageUrls[indexPath.item] != "" {
              (cell as! GPWEvidenceCell).imageView.downLoadImg(imgUrl: imageUrls[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! GPWEvidenceCell).imageView.cancelDownload()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GPWEvidenceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EvidenceCell", for: indexPath) as! GPWEvidenceCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        printLog(message: "点击了第\(indexPath.item)张图片")
        if let imgTap = self.imgTap {
            imgTap(indexPath.item)
        }
    }
}
