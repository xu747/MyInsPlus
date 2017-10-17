//
//  ResetPasswordVC.swift
//  MyIns
//
//  Created by xcl on 2017/4/28.
//  Copyright © 2017年 xcl. All rights reserved.
//

import UIKit
import AVOSCloud

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func resetBtn_clicked(_ sender: UIButton) {
        //隐藏键盘
        self.view.endEditing(true)
        
        if emailTxt.text!.isEmpty{
            let alert = UIAlertController(title:"请注意",message:"电子邮件不能为空",preferredStyle:.alert)
            let ok = UIAlertAction(title:"OK",style:.cancel,handler:nil)
            alert.addAction(ok)
            self.present(alert,animated: true,completion: nil)
            
            return
        }
        
        AVUser.requestPasswordResetForEmail(inBackground: emailTxt.text!){(success:Bool,error:Error?) in
            if success
            {
                let alert = UIAlertController(title:"成功",message:"重置密码连接已经发送到您的电子邮箱！",preferredStyle:.alert)
                let ok  = UIAlertAction(title:"OK",style:.default,handler:{(_) in
                    self.dismiss(animated: true, completion: nil)})
                    alert.addAction(ok)
                    self.present(alert,animated: true,completion: nil)
            }
            else
            {
                print("-------密码重置错误！！！-------")
                print(error.debugDescription)
                let alert = UIAlertController(title:"错误",message:"请检查邮箱是否输入错误！",preferredStyle:.alert)
                let ok  = UIAlertAction(title:"OK",style:.default)
                alert.addAction(ok)
                self.present(alert,animated: true,completion: nil)
            }
        }
    }
    
    @IBAction func cancelBtn_clicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
