//
//  WeatherVC.swift
//  MyIns
//
//  Created by Charles Xu on 17/10/2017.
//  Copyright © 2017 xcl. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftyJSON



extension String {
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1)->String {
        var len = length
        if len == -1 {
            len = characters.count - start
        }
        let st = characters.index(startIndex, offsetBy:start)
        let en = characters.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}

class WeatherVC: UIViewController,CLLocationManagerDelegate{

    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var nowImg: UIImageView!
    @IBOutlet weak var nowWeatherLabel: UILabel!
    @IBOutlet weak var nowTemperatureLabel: UILabel!
    @IBOutlet weak var tomorrowImg: UIImageView!
    @IBOutlet weak var dayAfterTomorrowImg: UIImageView!
    @IBOutlet weak var tomorrowWeatherLabel: UILabel!
    @IBOutlet weak var dayAfterTomorrowWeatherLabel: UILabel!
    @IBOutlet weak var tomorrowTemperatureLabel: UILabel!
    @IBOutlet weak var dayAfterTomorrowTemperatureLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var myLocationManager :CLLocationManager!
    
    //刷新
    func handleSingleTap(_recognizer: UITapGestureRecognizer) {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        myLocationManager.startUpdatingLocation()
    }
    
    
    
    func getWeatherInfoNow(coordinate: CLLocationCoordinate2D)
    {
        let urlString = "https://api.seniverse.com/v3/weather/now.json?key=leyaeuyvcfu72htg&location=\(coordinate.latitude):\(coordinate.longitude)&language=zh-Hans&unit=c"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlString!)
        let session  = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {
            (data,responder,error) in
            
            if error == nil{
                let json = JSON(data: data!)
                print(json)
                
                let cityName = json["results"][0]["location"]["name"].string
                let weatherNowText = json["results"][0]["now"]["text"].string
                let weatherNowCode = json["results"][0]["now"]["code"].string
                let weatherNowTemperature = json["results"][0]["now"]["temperature"].string
                let weatherNowUpdateTime = json["results"][0]["last_update"].string
            
                
                self.cityNameLabel.text = cityName
                self.nowImg.image = UIImage(named:weatherNowCode!)
                self.nowWeatherLabel.text = weatherNowText
                self.nowTemperatureLabel.text = String(weatherNowTemperature!+"℃")
                self.lastUpdateLabel.text = String("最后更新时间:"+(weatherNowUpdateTime?.subString(start: 11, length: 5))!)
                
                
                }
        })
        task.resume()
        
        
        let url2String = "https://api.seniverse.com/v3/weather/daily.json?key=leyaeuyvcfu72htg&location=\(coordinate.latitude):\(coordinate.longitude)&language=zh-Hans&unit=c"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url2 = URL(string: url2String!)
        let session2  = URLSession.shared
        
        let task2 = session2.dataTask(with: url2!, completionHandler: {
            (data,responder,error) in
            
            if error == nil{
                let json = JSON(data: data!)
                print(json)
                
                let weatherTomorrowText = json["results"][0]["daily"][1]["text_day"].string
                let weatherTomorrowCode = json["results"][0]["daily"][1]["code_day"].string
                let weatherTomorrowTemperatureLow = json["results"][0]["daily"][1]["low"].string
                let weatherTomorrowTemperatureHigh = json["results"][0]["daily"][1]["high"].string
                
                self.tomorrowWeatherLabel.text = weatherTomorrowText
                self.tomorrowImg.image = UIImage(named:weatherTomorrowCode!)
                self.tomorrowTemperatureLabel.text = String(weatherTomorrowTemperatureLow!+"~"+weatherTomorrowTemperatureHigh!+"℃")
                
                let weatherDayAfterTomorrowText = json["results"][0]["daily"][2]["text_day"].string
                let weatherDayAfterTomorrowCode = json["results"][0]["daily"][2]["code_day"].string
                let weatherDayAfterTomorrowTemperatureLow = json["results"][0]["daily"][2]["low"].string
                let weatherDayAfterTomorrowTemperatureHigh = json["results"][0]["daily"][2]["high"].string
                
                self.dayAfterTomorrowWeatherLabel.text = weatherDayAfterTomorrowText
                self.dayAfterTomorrowImg.image = UIImage(named:weatherDayAfterTomorrowCode!)
                self.dayAfterTomorrowTemperatureLabel.text = String(weatherDayAfterTomorrowTemperatureLow!+"~"+weatherDayAfterTomorrowTemperatureHigh!+"℃")
                
            }
        })
        task2.resume()

        
        
    }
    
    func refresh()
    {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.startAnimating()
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector (handleSingleTap(_recognizer:)))
        singleFingerTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(singleFingerTap)
        
        // Do any additional setup after loading the view.
        
        // 建立一個 CLLocationManager
        myLocationManager = CLLocationManager()
        
        // 設置委任對象
        myLocationManager.delegate = self
        
        // 取得自身定位位置的精確度
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        // 印出目前所在位置座標
        let currentLocation :CLLocation = locations[0] as CLLocation
        getWeatherInfoNow(coordinate: currentLocation.coordinate)
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        myLocationManager.stopUpdatingLocation();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(
                alertController,
                animated: true, completion: nil)
        }
            // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
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
