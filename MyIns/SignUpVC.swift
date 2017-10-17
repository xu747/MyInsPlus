//
//  SignUpVC.swift
//  MyIns
//
//  Created by xcl on 2017/4/28.
//  Copyright © 2017年 xcl. All rights reserved.
//

import UIKit
import AVOSCloud


class SignUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var UserNameText: UITextField!
    @IBOutlet weak var PassWordText: UITextField!
    @IBOutlet weak var RepeatPassWordText: UITextField!
    @IBOutlet weak var EmailText: UITextField!
    
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var BioText: UITextField!
    @IBOutlet weak var WebsiteText: UITextField!
    
    @IBOutlet weak var SignUpBtn: UIButton!
    @IBOutlet weak var CancelBtn: UIButton!
    
    @IBAction func SignUpBtn_Clicked(_ sender: UIButton) {
    self.view.endEditing(true)
    
    if UserNameText.text!.isEmpty || PassWordText.text!.isEmpty || RepeatPassWordText.text!.isEmpty || EmailText.text!.isEmpty || NameText.text!.isEmpty || BioText.text!.isEmpty || WebsiteText.text!.isEmpty
        {
            let alert = UIAlertController(title:"请注意", message :"请填写好所有的内容",preferredStyle:.alert)
            let ok = UIAlertAction(title:"OK",style:.cancel,handler:nil)
            alert.addAction(ok)
            self.present(alert,animated: true,completion: nil)
            
            return
            
        }
        
    if PassWordText.text != RepeatPassWordText.text
        {
            let alert = UIAlertController(title:"请注意",message:"两次输入的密码不一致",preferredStyle:.alert)
            let ok = UIAlertAction(title:"OK",style:.cancel,handler:nil)
            alert.addAction(ok)
            self.present(alert,animated: true,completion: nil)
            return
        }
        
        let user = AVUser()
        user.username = UserNameText.text?.lowercased()
        user.email = EmailText.text?.lowercased()
        user.password = PassWordText.text
        
        user["fullname"] = NameText.text?.lowercased()
        user["bio"] = BioText.text
        user["web"] = WebsiteText.text?.lowercased()
        user["gender"] = ""
        
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = AVFile(name:"ava.jpg", data:avaData!)
        user["ava"] = avaFile
        
        user.signUpInBackground{(success:Bool, error:Error?) in
            if success{
                print("用户注册成功！")
                AVUser.logInWithUsername(inBackground: user.username!, password: user.password!, block: { (user:AVUser?,error:Error?) in
                    if let user = user{
                        //记住登录的用户
                        UserDefaults.standard.set(user.username,forKey:"username")
                        UserDefaults.standard.synchronize()
                        
                        //从AppDelegate类中调用login方法
                        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.login()
                    }
                })
            }else{
                print(error.debugDescription)
            }
        }
    }

    @IBAction func CancelBtn_Clicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    var scrollViewHeight:CGFloat = 0
    var keyboard:CGRect = CGRect()
    
    func showKeyboard(notification:Notification) {
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        UIView.animate(withDuration:0.4){
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.size.height
        }
    }
    
    func hideKeyboard(notification:Notification) {
        UIView.animate(withDuration: 0.4){
        self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    func hideKeyboardTap(recognizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func loadImg(recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info:[String:Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = self.view.frame.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        let hideTap = UITapGestureRecognizer(target: self,action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        let imgTap = UITapGestureRecognizer(target: self , action:#selector(loadImg))
        imgTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(imgTap)
        
        //change the style of avaImg to circle
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
        

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
