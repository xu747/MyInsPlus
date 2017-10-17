//
//  EditVC.swift
//  MyIns
//
//  Created by xcl on 2017/6/9.
//  Copyright © 2017年 xcl. All rights reserved.
//

import UIKit
import AVOSCloud

class EditVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var telTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    
    
    //单击保存按钮的实现代码
    @IBAction func save_clicked(_ sender: AnyObject) {
        //检查Email有效性
        func validateEmail(email:String) -> Bool {
            let regex = "\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}"
            let range = email.range(of: regex, options: .regularExpression)
            let result = range != nil ? true : false
            return result
        }
        //检查Web有效性
        func validateWeb(web:String) -> Bool{
            let regex = "www\\.[A-Za-z0-9._%+-]+\\.[A-Za-z]{2,14}"
            let range = web.range(of: regex, options: .regularExpression)
            let result = range != nil ? true : false
            return result
        }
        //检查手机号码有效性
        func validateMobilePhoneNumber(mobilePhoneNumber: String) -> Bool{
            let regex = "0?(13|14|15|18)[0-9]{9}"
            let range = mobilePhoneNumber.range(of: regex, options: .regularExpression)
            let result = range != nil ? true : false
            return result
        }
        
        if !validateEmail(email: emailTxt.text!){
            alert(error: "错误的Email地址", message: "请输入正确的电子邮箱地址")
            return
        }
        
        if !validateWeb(web: webTxt.text!){
            alert(error: "错误的网页链接", message: "请输入正确的网址")
            return
        }
        
        if !telTxt.text!.isEmpty{
            if !validateMobilePhoneNumber(mobilePhoneNumber: telTxt.text!){
                alert(error: "错误的手机号码", message: "请输入正确的手机号码")
                return
            }
        }
        
        //保存filed信息到服务器中
        let user = AVUser.current()
        user?.username = usernameTxt.text?.lowercased()
        user?.email = emailTxt.text?.lowercased()
        user?["fullname"] = fullnameTxt.text?.lowercased()
        user?["web"] = webTxt.text?.lowercased()
        user?["bio"] = bioTxt.text
        
        if telTxt.text!.isEmpty{
            user?.mobilePhoneNumber = ""
        }else{
            user?.mobilePhoneNumber = telTxt.text
        }
        
        if genderTxt.text!.isEmpty{
            user?["gender"] = ""
        }else{
            user?["gender"] = genderTxt.text
        }
        
        //发送用户信息到服务器
        user?.saveInBackground({(success:Bool,error:Error?) in
            if success{
                //隐藏键盘
                self.view.endEditing(true)
                
                //退出EditVC控制器
                self.dismiss(animated: true, completion: nil)
                
                NotificationCenter.default.post(name:NSNotification.Name(rawValue:"reload"),object:nil)
            }else{
                print(error.debugDescription)
            }
        })
        
        
    }
    
    //单击取消按钮的实现代码
    @IBAction func cancel_clicked(_ sender: AnyObject) {
        //隐藏虚拟键盘
        self.view.endEditing(true)
        //销毁个人信息编辑控制器
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取用户信息
        information()
        
        //在视图中创建PickerView
        genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderPicker.showsSelectionIndicator = true
        genderTxt.inputView = genderPicker
        
        //检测键盘消失或出现的状态
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        //单击控制器后让键盘消失
        let hideTap = UITapGestureRecognizer(target:self,action:#selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //单击image view
        let imgTap = UITapGestureRecognizer(target:self,action:#selector(loadImg))
        imgTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(imgTap)
        
        //调用布局方法
        alignment()

        // Do any additional setup after loading the view.
    }
    

    //界面布局
    func alignment(){
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        scrollView.frame = CGRect(x:0,y:0,width:width,height:height)
        
        avaImg.frame = CGRect(x:width-68-10,y:15,width:68,height:68)
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
        
    }
    
    //PickerView和PickerData
    var genderPicker:UIPickerView!
    let genders = ["男","女"]
    
    var keyboard = CGRect()
    
    //获取器方法
    //设置获取器的组件数量
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //设置获取器中选项的数量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    //设置获取器的选项Title
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    //从获取器中得到用户选择的Item
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxt.text = genders[row]
        self.view.endEditing(true)
    }
    
    //隐藏视图中的虚拟键盘
    func hideKeyboardTap(recognizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func showKeyboard(notification:Notification){
        //定义keyboard大小
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        //虚拟键盘出现后，滚动视图高度变化
        UIView.animate(withDuration:0.4){
            self.scrollView.contentSize.height = self.view.frame.height + self.keyboard.height / 2
        }
    }
    
    func hideKeyboard(notification:Notification){
    //虚拟键盘消失后，滚动视图高度变化
        UIView.animate(withDuration:0.4){
            self.scrollView.contentSize.height = 0
        }
    }
    
    //调出照片获取器选择照片
    func loadImg(recognizer:UITapGestureRecognizer)  {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
    }
    
    //关联选择好的照片图像到image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
    }
    
    //获取用户信息
    func information(){
        let ava = AVUser.current()?.object(forKey: "ava") as! AVFile
        ava.getDataInBackground{(data:Data?,error:Error?) in
            self.avaImg.image = UIImage(data:data!)
        }
        //接收个人用户的文本信息
        usernameTxt.text = AVUser.current()?.username
        fullnameTxt.text = AVUser.current()?.object(forKey: "fullname") as? String
        bioTxt.text = AVUser.current()?.object(forKey: "bio") as? String
        webTxt.text = AVUser.current()?.object(forKey: "web") as? String
        emailTxt.text = AVUser.current()?.email
        telTxt.text = AVUser.current()?.mobilePhoneNumber
        genderTxt.text = AVUser.current()?.object(forKey: "gender") as? String
    }
    
    func alert (error:String,message:String){
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK",style: .cancel,handler: nil)
        alert.addAction(ok)
        self.present(alert,animated: true,completion: nil)
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


