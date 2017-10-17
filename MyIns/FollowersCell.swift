//
//  FollowersCell.swift
//  MyIns
//
//  Created by xcl on 2017/6/4.
//  Copyright © 2017年 xcl. All rights reserved.
//

import UIKit
import AVOSCloud

class FollowersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var user : AVUser!
    
    //单击改变关注状态
    @IBAction func followBtn_clicked(_ sender: Any) {
        let title = followBtn.title(for:.normal)
        
        if title == "关 注"{
            guard user != nil else { return }
            AVUser.current()?.follow(user.objectId!, andCallback: {(success:Bool,error:Error?) in
                if success {
                    self.followBtn.setTitle("√ 已关注", for: .normal)
                    self.followBtn.backgroundColor = .green
                }else{
                    print(error.debugDescription)
                }
            })
        }else{
            guard user != nil else {return}
            
            AVUser.current()?.unfollow(user.objectId!, andCallback: {(success:Bool,error:Error?) in
                if success{
                    self.followBtn.setTitle("关 注", for: .normal)
                    self.followBtn.backgroundColor = .lightGray
                }else{
                    print(error.debugDescription)
                }
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //布局设置
        let width = UIScreen.main.bounds.width
        
        avaImg.frame = CGRect(x:10,y:10,width:width/5.3,height:width/5.3)
        usernameLbl.frame = CGRect(x:avaImg.frame.width + 20,y:30,width:width/3.2,height:30)
        followBtn.frame = CGRect(x:width - width / 3.5 - 20, y: 30, width:width / 3.5,height:30)
        //将头像变成圆形
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}