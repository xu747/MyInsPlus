//
//  UploadVC.swift
//  MyIns
//
//  Created by xcl on 2017/6/10.
//  Copyright © 2017年 xcl. All rights reserved.
//

import UIKit
import AVOSCloud

class UploadVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    
    @IBAction func removeBtn_clicked(_ sender: AnyObject) {
        self.viewDidLoad()
        
    }
    
    
    
    
    @IBAction func publishBtn_clicked(_ sender: Any) {
        //隐藏键盘
        self.view.endEditing(true)
        
        let object = AVObject(className: "Posts")
        object["username"] = AVUser.current()?.username
        object["ava"] = AVUser.current()?.value(forKey: "ava") as! AVFile
        object["puuid"] = "\(AVUser.current()?.username!) \(NSUUID().uuidString)"
        
        //检验titleTxt是否为空
        if titleTxt.text.isEmpty{
            object["title"] = ""
        }else{
            object["title"] = titleTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        //生成照片数据
        let imageData = UIImageJPEGRepresentation(picImg.image!, 0.5)
        let imageFile = AVFile(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        
        //将数据存储到云端
        object.saveInBackground({(success:Bool, error:Error?) in
            if error == nil{
                //发送uploaded通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"uploaded"), object: nil)
                //将TapBar控制器中索引为0的子控制器，显示在手机屏幕上
                self.tabBarController!.selectedIndex = 0
                
                //reset一切
                self.viewDidLoad()
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //默认状态下禁用publishBtn按钮
        publishBtn.isEnabled = false
        publishBtn.backgroundColor = .lightGray
        
        //单击 Image View
        let picTap = UITapGestureRecognizer(target:self,action:#selector(selectImg))
        picTap.numberOfTapsRequired = 1
        self.picImg.isUserInteractionEnabled = true
        self.picImg.addGestureRecognizer(picTap)
        
        //隐藏移除按钮
        removeBtn.isHidden = true
        
        picImg.image = UIImage(named:"pbg.jpg")
        titleTxt.text = ""

        // Do any additional setup after loading the view.
    }
    
    func selectImg(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    //缩放照片
    func zoomImg() {
        //放大后的Image View的位置
        let zoomed = CGRect(x:0, y:self.view.center.y - self.view.center.x, width: self.view.frame.width, height: self.view.frame.width)
        //Image View 还原到初始位置
        let unzoomed = CGRect(x: 15, y:self.navigationController!.navigationBar.frame.height + 35, width: self.view.frame.width / 4.5, height: self.view.frame.width / 4.5)
        //如果Image View是初始大小
        if picImg.frame == unzoomed{
            UIView.animate(withDuration: 0.3, animations: {
                self.picImg.frame = zoomed
                
                self.view.backgroundColor = .black
                self.titleTxt.alpha = 0
                self.publishBtn.alpha = 0
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.picImg.frame = unzoomed
                
                self.view.backgroundColor = .white
                self.titleTxt.alpha = 1
                self.publishBtn.alpha = 1
            })
        }
        
    }
    //将选择的照片放入picImg，并销毁照片获取器
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        //显示移除按钮
        removeBtn.isHidden = false
        
        //允许 publish btn
        publishBtn.isEnabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0 / 255.0, green: 169.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        
        //实现第二次单击放大图片
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomImg))
        zoomTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
