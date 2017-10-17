//
//  SignInVC.swift
//  MyIns
//
//  Created by xcl on 2017/4/28.
//  Copyright © 2017年 xcl. All rights reserved.
//

import UIKit
import AVOSCloud

class SignInVC: UIViewController {
    
    @IBOutlet weak var UserNameText: UITextField!
    @IBOutlet weak var PassWordText: UITextField!
    
    @IBOutlet weak var SignInBtn: UIButton!
    @IBOutlet weak var SignUpBtn: UIButton!
    @IBOutlet weak var ForgetPassWordBtn: UIButton!
    
    
    
    @IBAction func SignInBtn_Clicked(_ sender: UIButton) {
        print("登录按钮被按下")
        
        //隐藏键盘
        self.view.endEditing(true)
        
        //判断用户的用户名和密码是否都输入了
        if UserNameText.text!.isEmpty || PassWordText.text!.isEmpty{
            let alert = UIAlertController(title:"请注意",message:"请填好所有的字段",preferredStyle:.alert)
            let ok = UIAlertAction(title:"OK",style:.cancel,handler:nil)
            alert.addAction(ok)
            self.present(alert,animated: true,completion: nil)
            return
        }
        //实现用户登录功能
        AVUser.logInWithUsername(inBackground:UserNameText.text!,password:PassWordText.text!){(user:AVUser?,error:Error?)in
            if error == nil{
                print("登录处理完毕")
                //记住用户
                UserDefaults.standard.set(user!.username,forKey: "username")
                UserDefaults.standard.synchronize()
                //调用AppDelegate类的login方法
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            }else{
                print(error.debugDescription)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加隐藏虚拟键盘的手势识别代码
        let hideTap = UITapGestureRecognizer(target:self,action:#selector(hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)

        // Do any additional setup after loading the view.
    }
    
    func hideKeyboard(recognizer:UITapGestureRecognizer)
    {
        self.view.endEditing(true)
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
