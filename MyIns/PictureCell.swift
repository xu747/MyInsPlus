//
//  PictureCell.swift
//  MyIns
//
//  Created by xcl on 2017/5/19.
//  Copyright © 2017年 xcl. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    @IBOutlet weak var picImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let width = UIScreen.main.bounds.width
        //将单元格中 Image View 的尺寸同样设置为屏幕宽度的1/3
        picImg.frame = CGRect(x: 0, y: 0,width: width / 3, height: width / 3)
        
    }
    
    
}


