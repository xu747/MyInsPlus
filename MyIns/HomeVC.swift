//
//  HomeVC.swift
//  MyIns
//
//  Created by xcl on 2017/5/19.
//  Copyright © 2017年 xcl. All rights reserved.
//

import UIKit
import AVOSCloud

class HomeVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    //刷新控件
    var refresher : UIRefreshControl!
    
    //每页载入帖子（图片）的数量
    var page : Int = 12
    
    var puuidArray = [String]()
    var picArray = [AVFile]()
    
    //响应单击方法
    //单击帖子数后调用的方法
    func postsTap(_recognizer:UITapGestureRecognizer){
        if !picArray.isEmpty{
            let index = IndexPath(item:0,section:0)
            self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    //单击关注者数后调用的方法
    func followersTap(_recognizer:UITapGestureRecognizer){
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        followers.user = (AVUser.current()?.username)!
        followers.show = "关注者"
        
        self.navigationController?.pushViewController(followers, animated: true)
    }
    //单击关注数后调用的方法
    func followingsTap(_recognizer:UITapGestureRecognizer){
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        followings.user = (AVUser.current()?.username)!
        followings.show = "关 注"
        
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    func refresh() {
        collectionView?.reloadData()
        
        //停止刷新动画
        refresher.endRefreshing()
    }
    
    func loadPosts(){
        let query = AVQuery(className:"Posts")
        query.whereKey("username",equalTo:AVUser.current()?.username)
        query.limit = page
        query.findObjectsInBackground({ (objects:[Any]?,error:Error?) in             //查询成功
            if error == nil{
                //清空两个数组
                self.puuidArray.removeAll(keepingCapacity:false)
                self.picArray.removeAll(keepingCapacity:false)
                self.picArray.removeAll(keepingCapacity:false)
                
                for object in objects!{
                    self.puuidArray.append((object as AnyObject).value(forKey:"puuid") as! String)
                    self.picArray.append((object as AnyObject).value(forKey:"pic") as! AVFile)
                }
                
                self.collectionView?.reloadData()
            }
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //设置集合视图在垂直方向上有反弹的效果
        self.collectionView?.alwaysBounceVertical = true
        
        self.navigationItem.title = AVUser.current()?.username?.uppercased()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        //从EditVC类接收Notification
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        //从UploadVC类接收Notification
        NotificationCenter.default.addObserver(self, selector: #selector(uploaded(notification:)), name: NSNotification.Name(rawValue:"uploaded"), object: nil)
        
        
        loadPosts()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

/*    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
*/


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return picArray.count * 20
        return picArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
        
        header.fullnameLbl.text = (AVUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webTxt.text = AVUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = AVUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        
        let avaQuery = AVUser.current()?.object(forKey: "ava") as! AVFile
        avaQuery.getDataInBackground{(data:Data?,error:Error?) in
            if data == nil{
                print(error.debugDescription)
            }else{
                header.avaImg.image = UIImage(data:data!)
            }
        }
            
            
            
            
            /*
            if error == nil {header.avaImg.image = UIImage(data: data!)}
            else{
                
                let details = error.debugDescription
                let alert = UIAlertController(title: "Error", message: ""+details!, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert,animated: true,completion: nil)
                
            }
            */
            
            //header.avaImg.image = UIImage(data:data!)
        
        
        let currentUser:AVUser = AVUser.current()!
        
        let postsQuery = AVQuery(className:"Posts")
        postsQuery.whereKey("username", equalTo: currentUser.username)
        postsQuery.countObjectsInBackground({(count:Int,error:Error?) in
            if error == nil{
                header.posts.text = String(count)
            }
        })
        
        
        let followersQuery = AVQuery(className:"_Follower")
        followersQuery.whereKey("user",equalTo:currentUser)
        followersQuery.countObjectsInBackground({(count:Int,error:Error?) in
            if error == nil{
                header.followers.text = String(count)
            }
        })
        
        let followeesQuery = AVQuery(className:"_Followee")
        followeesQuery.whereKey("user", equalTo: currentUser)
        followeesQuery.countObjectsInBackground({(count:Int,error:Error?) in
            if error == nil{
                header.followings.text = String(count)
            }
        })
        
        //实现单击手势,有修改
        //单击帖子数
        let postsTap = UITapGestureRecognizer(target: self, action: #selector (postsTap(_recognizer:)))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        //单击关注者数
        let followersTap = UITapGestureRecognizer(target:self, action: #selector (followersTap(_recognizer:)))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        
        //单击关注数
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(followingsTap(_recognizer:)))
        followingsTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
        
        
        
        return header
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCell
        picArray[0].getDataInBackground{ (data:Data?,error:Error?) in
            if error == nil{
                cell.picImg.image = UIImage(data:data!)
                self.collectionView?.reloadData()
            }else{
                print(error.debugDescription)
            }
        }
        // Configure the cell
    
        return cell
    }
    
    //单击退出登录
    @IBAction func logout(_ sender: AnyObject) {
        //退出用户登录
        AVUser.logOut()
        
        //从UserDefaults中移除用户登录记录
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.synchronize()
        
        //设置应用程序的rootViewController为登录控制器
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = signIn
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: self.view.frame.width / 3, height:self.view.frame.width / 3)
        return size
    }
    
    func reload (notification:Notification) {
        collectionView?.reloadData()
    }
    
    func uploaded(notification: Notification) {
        loadPosts()
    }
    
    
    
    
    
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    

}
