//
//  FollowersVC.swift
//  MyIns
//
//  Created by xcl on 2017/6/4.
//  Copyright © 2017年 xcl. All rights reserved.
//

import UIKit
import AVOSCloud

class FollowersVC: UITableViewController {

    
    var show = String()
    var user = String()
    
    var followerArray = [AVUser]()
    
    func loadFollowers (){
        AVUser.current()?.getFollowees{(followers:[Any]?,error:Error?) in
            if error == nil && followers != nil{
                self.followerArray = followers! as! [AVUser]
                //刷新表格视图
                self.tableView.reloadData()
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    func loadFollowings() {
        AVUser.current()?.getFollowees{(followings:[Any]?,error:Error?) in
            if error == nil && followings != nil{
                self.followerArray = followings! as! [AVUser]
                //刷新表格视图
                self.tableView.reloadData()
            }else{
                print(error.debugDescription)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = show
        
        if show == "关注者"{
            loadFollowers()
        }else{
            loadFollowings()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //通过indexPath获取用户所单击的单元格的用户对象
        let cell = tableView.cellForRow(at: indexPath) as! FollowersCell
        
        //如果用户单击单元格，或者进入HomeVC或进入GuestVC
        if cell.usernameLbl.text == AVUser.current()?.username{
            let home = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(home, animated: true)
        }else{
            guestArray.append(followerArray[indexPath.row])
            let guest = storyboard?.instantiateViewController(withIdentifier: "GuestVC") as! GuestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return followerArray.count
    }

    

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FollowersCell
        
        cell.usernameLbl.text = followerArray[indexPath.row].username
        let ava = followerArray[indexPath.row].object(forKey:"ava") as! AVFile
        
        ava.getDataInBackground({(data:Data?,error:Error?) in
            if error == nil{
                cell.avaImg.image = UIImage(data:data!)
            }else{
                print(error.debugDescription)
            }
        })
        //利用按钮外观区分当前用户关注或未关注状态
        let query = followerArray[indexPath.row].followeeQuery()
        query.whereKey("user",equalTo:AVUser.current())
        query.whereKey("followee", equalTo: followerArray[indexPath.row])
        query.countObjectsInBackground({(count:Int,error:Error?) in
            //根据数量设置按钮风格
            if error == nil{
                if count == 0{
                    cell.followBtn.setTitle("关 注", for: .normal)
                    cell.followBtn.backgroundColor = .lightGray
                }else{
                    cell.followBtn.setTitle("√ 已关注", for: .normal)
                    cell.followBtn.backgroundColor = .green
                }
            }

            
            //为当前用户隐藏关注按钮
            if cell.usernameLbl.text == AVUser.current()?.username{
                cell.followBtn.isHidden = true
            }
        })
        
        //将关注人对象传递给FollowersCell
        cell.user = followerArray[indexPath.row]
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return self.view.frame.width / 4
    }
    
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
