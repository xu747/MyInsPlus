//
//  HeaderView.swift
//  MyIns
//
//  Created by xcl on 2017/5/19.
//  Copyright © 2017年 xcl. All rights reserved.
//

import UIKit
import AVOSCloud

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var postsTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func followBtn_clicked(_ sender: Any) {
        let title = button.title(for: .normal)
        
        //获取当前的访客对象
        let user = guestArray.last
        
        if title == "关 注"{
            guard let user = user else { return }
            AVUser.current()?.follow(user.objectId!, andCallback: {(success:Bool,error:Error?) in
                if success {
                    self.button.setTitle("√ 已关注", for: .normal)
                    self.button.backgroundColor = .green
                }else{
                    print(error.debugDescription)
                }
            })
        }else{
            guard let user = user else {return}
            
            AVUser.current()?.unfollow(user.objectId!, andCallback: {(success:Bool,error:Error?) in
                if success{
                    self.button.setTitle("关 注", for: .normal)
                    self.button.backgroundColor = .lightGray
                }else{
                    print(error.debugDescription)
                }
            })
        }
    }
    
    /*
    //从GuestVC单击关注按钮
    @IBAction func followBtn_clicked(_ sender: Any) {
        let title = button.title(for: .normal)
        
        //获取当前的访客对象
        let user = guestArray.last
        
        if title == "关 注"{
            guard let user = user else { return }
            AVUser.current()?.follow(user.objectId!, andCallback: {(success:Bool,error:Error?) in
                if success {
                    self.button.setTitle("√ 已关注", for: .normal)
                    self.button.backgroundColor = .green
                }else{
                    print(error.debugDescription)
                }
            })
        }else{
            guard let user = user else {return}
            
            AVUser.current()?.unfollow(user.objectId!, andCallback: {(success:Bool,error:Error?) in
                if success{
                    self.button.setTitle("关 注", for: .normal)
                    self.button.backgroundColor = .lightGray
                }else{
                    print(error.debugDescription)
                }
            })
        }
    }
    */
 
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //对齐
        let width = UIScreen.main.bounds.width
        //对头像进行布局
        avaImg.frame = CGRect(x: width / 16, y: width / 16, width: width / 4, height: width / 4)
        //对三个统计数据进行布局
        posts.frame = CGRect(x: width / 2.5, y: avaImg.frame.origin.y, width: 50, height: 30)
        followers.frame = CGRect(x: width / 1.6, y: avaImg.frame.origin.y, width: 50, height: 30)
        followings.frame = CGRect(x: width / 1.2, y: avaImg.frame.origin.y, width: 50, height: 30)
        //设置三个统计数据Title的布局
        postsTitle.center = CGPoint(x: posts.center.x, y: posts.center.y + 20)
        followersTitle.center = CGPoint(x:followers.center.x, y:followers.center.y + 20)
        followingsTitle.center = CGPoint(x:followings.center.x, y:followings.center.y + 20)
        //设置按钮的布局
        //button.frame = CGRect(x: postsTitle.frame.origin.x, y:postsTitle.center.y + 20, width: width - postsTitle.frame.origin.x - 10, height: 30)
        fullnameLbl.frame = CGRect(x: avaImg.frame.origin.x, y:avaImg.frame.origin.y + avaImg.frame.height, width: width - 30, height: 30)
        webTxt.frame = CGRect(x: avaImg.frame.origin.x - 5, y: fullnameLbl.frame.origin.y + 15, width: width - 30, height: 30 )
        bioLbl.frame = CGRect(x: avaImg.frame.origin.x, y: webTxt.frame.origin.y + 30, width: width - 30, height: 30)
    }
    */
    
    
    
    
    
        
}
