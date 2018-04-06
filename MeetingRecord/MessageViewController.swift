//
//  MessageViewController.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/19.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit
import Alamofire
protocol messageDelegate{
    func delegateToRefresh()
}
class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.textDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! messageTableViewCell
        cell.messageLabel.text = self.textDataArray[indexPath.row]
        cell.selectionStyle = .none
        if !isEidted{
            cell.checkBox.isHidden = true
        }else{
            cell.checkBox.isHidden = false
            if self.selectDataArray[indexPath.row]{
                cell.checkBox.image = UIImage.init(named: "000")
            }else{
                cell.checkBox.image = UIImage.init(named: "111")
            }
//            cell.checkBox.isUserInteractionEnabled = true
//            cell.checkBox.tag = 30000 + indexPath.row
//            let checkTap = UITapGestureRecognizer(target: self, action: #selector(MessageViewController.checkTap))
//            cell.checkBox.addGestureRecognizer(checkTap)
        }
        return cell
    }
    func showTokenError(){
        let alertController = UIAlertController(title: "認証情報の有効期限切れ、もしくは認証エラーです。\n iCANVASにて再度ログインし起動してください。",
                                                message:"", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: {
            action in
            let url = URL(string:"SFCiCANVAS://？caller=MeetingRecords")
            UIApplication.shared.open(url!, options: [:]) { (bool) in
            }
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @objc
    func checkTap(tap:UITapGestureRecognizer) {
        let view = tap.view as! UIImageView
        let number = view.tag - 30000
        self.selectDataArray[number] = !self.selectDataArray[number]
        self.table.reloadData()
        var i = 0
        for value in self.selectDataArray{
            if value{
                i += 1
            }
        }
        if i > 0{
            deleteImage.image = UIImage.init(named: "ic_delete_36pt")
        }else{
            deleteImage.image = UIImage.init(named: "ic_delete_36pt_3x_gray")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEidted{
         
            self.selectDataArray[indexPath.row] = !self.selectDataArray[indexPath.row]
            var i = 0
            for value in self.selectDataArray{
                if value{
                    i += 1
                }
            }
            if i > 0{
                deleteImage.image = UIImage.init(named: "ic_delete_36pt")
            }else{
                deleteImage.image = UIImage.init(named: "ic_delete_36pt_3x_gray")
            }
            self.table.reloadData()
        }else{
            self.isSelected = true
            self.selectedNum = indexPath.row
            self.textView.text = self.textDataArray[indexPath.row]
        }

    }
    var alamofireManager : SessionManager?
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveImage: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var deleteImage: UIImageView!

    @IBOutlet weak var newImage: UILabel!
    var myDelegate:messageDelegate!

    var ist103001 = 0
    var ist103002 = ""
    var ist103003 = ""
    var ist103004 = ""
    var ist103005 = ""
    var ist103006 = ""
    var ist103007 = ""

    var pushDataArray = Array<Dictionary<String, Any>>()
    var textDataArray = Array<String>()
    var selectDataArray = Array<Bool>()
    var isEidted = false
    var isSelected = false
    var selectedNum = 0
    var str = ""
    @IBOutlet weak var decesionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            //高于 iOS 9.0
        }
        else {
            self.navigationController?.navigationBar.isTranslucent = false
            //            self.topMargin.constant = 44
            //低于 iOS 9.0
            
        }
        self.decesionLabel.isHidden = true
        self.decesionLabel.isUserInteractionEnabled = true
        let decesionTap = UITapGestureRecognizer(target: self, action: #selector(self.myPop))
        self.decesionLabel.addGestureRecognizer(decesionTap)
        self.decesionLabel.layer.borderColor = UIColor.black.cgColor
        self.decesionLabel.layer.cornerRadius = 10
        self.decesionLabel.layer.borderWidth = 1
        self.saveImage.layer.borderWidth = 1
        self.saveImage.layer.borderColor = UIColor.black.cgColor
        self.saveImage.layer.cornerRadius = 10
        self.backLabel.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(MessageViewController.pop))
        self.backLabel.addGestureRecognizer(backTap)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.register(UINib.init(nibName: "messageTableViewCell", bundle: nil), forCellReuseIdentifier: "message")
        self.saveImage.isUserInteractionEnabled = true
        let saveTap =  UITapGestureRecognizer(target: self, action: #selector(MessageViewController.save))
        self.saveImage.addGestureRecognizer(saveTap)
        self.editLabel.isUserInteractionEnabled = true
        let editTap =  UITapGestureRecognizer(target: self, action: #selector(MessageViewController.editTap))
        self.editLabel.addGestureRecognizer(editTap)
        self.deleteImage.isUserInteractionEnabled = true
        let deleteTap =  UITapGestureRecognizer(target: self, action: #selector(MessageViewController.deletedCell))
        self.deleteImage.addGestureRecognizer(deleteTap)
        self.newImage.layer.borderWidth = 1
        self.newImage.layer.borderColor = UIColor.black.cgColor
        self.newImage.layer.cornerRadius = 10
        self.newImage.isUserInteractionEnabled = true
        let newTap =  UITapGestureRecognizer(target: self, action: #selector(MessageViewController.newTap))
        self.newImage.addGestureRecognizer(newTap)
        // Do any additional setup after loading the view.
        if self.str == "isSet"{
            self.textView.text = "[設定外/特注品]  詳細は別紙御見積書参照"
        }
        self.textView.font =  UIFont.init(name: "HiraginoSans-W3", size: 16)
        self.getData()
    }
    func getData(){
        let dic = ["ist103001":self.ist103001,
                   "ist103002":self.ist103002,
                   "ist103003":self.ist103003,
                   "ist103004":self.ist103005,
                   "ist103005":self.ist103004,
                   "ist103006":self.ist103006
            ] as [String : Any]
        
        
//        print("xxxxx",dic)
        //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
        //            print(json)
        //        }
        let url = URL.init(string:helper().api+"issat/select/tyuki/")
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        alamofireManager = SessionManager(configuration: config)
        
        alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers:header).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                
                if let val = value as? Dictionary<String, Any>{
                    if let status = val["status"] as! Int?{
                    if status == 401{
                        self.showTokenError()
                        return
                    }
                }
                    let va = val["tyuiList"] as? Array<Dictionary<String, String>>
                    for dem in va!{
                            self.textDataArray.append(dem["ist103009"]!)
                        }
                    if self.textDataArray.count > 0{
                        self.decesionLabel.isHidden = false
                    }
                    
                }else
                {
                    // nil
                    print(value)
                }
                self.table.reloadData()
            case.failure(let error):
                print("aaaaaaa",error)
            }
        }
    }
    let header = MdUtils.getAuthHeader()

    @objc
    func newTap(){
        self.isSelected = false
        self.textView.text = ""
        self.textView.becomeFirstResponder()
    }
    @objc
    func deletedCell(){
        var a = 0
        for value in self.selectDataArray{
            if value{
                a += 1
            }
        }
        if a == 0{
            return
        }
        var i = self.textDataArray.count - 1
        for _ in self.selectDataArray{
            let a = self.selectDataArray[i]
            if a == true{
                self.textDataArray.remove(at: i)
            }
            i -= 1
        }
         self.pushDataArray.removeAll()
        for str in self.textDataArray {
            let dic = ["ist103009":str]
            self.pushDataArray.append(dic)
        }
        var flg = 0
        if self.str == "isSet"
        {
            flg = 1
        }
        let dic = ["ist103001":self.ist103001,
                   "ist103002":self.ist103002,
                   "ist103003":self.ist103003,
                   "ist103004":self.ist103005,
                   "ist103005":self.ist103004,
                   "ist103006":self.ist103006,
                   "ist102007":self.ist103007,
                   "setteigaiFlag":flg,
                   "keijouTyukiUpdateList":self.pushDataArray
            ] as [String : Any]
        
        
        print("xxxxx",dic)
        //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
        //            print(json)
        //        }
        let url = URL.init(string:helper().api+"issat/update/tyuki/")
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        alamofireManager = SessionManager(configuration: config)
        
        alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                self.textDataArray.removeAll()
                if let val = value as? Dictionary<String, Any>{
                    if let status = val["status"] as! Int?{
                        if status == 401{
                            self.showTokenError()
                            return
                        }
                    }
                 
                    let va = val["tyuiList"] as? Array<Dictionary<String, String>>
                    for dem in va!{
                        self.textDataArray.append(dem["ist103009"]!)
                    }
                    if self.textDataArray.count > 0{
                        self.decesionLabel.isHidden = false
                    }else{
                        self.decesionLabel.isHidden = true
                    }
                }else
                {
                    // nil
                    if self.textDataArray.count > 0{
                        self.decesionLabel.isHidden = false
                    }else{
                        self.decesionLabel.isHidden = true
                    }
                    print(value)
                }
                self.table.reloadData()
            case.failure(let error):
                print("aaaaaaa",error)
            }
        }
        
        self.editTap()
    }
    @objc
    func editTap(){
        self.selectDataArray.removeAll()
        self.textView.resignFirstResponder()
        self.textView.text = ""
        if !isEidted{
            self.isEidted = true
            //            self.edit.textColor = UIColor.black
            self.decesionLabel.layer.borderColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0).cgColor
            self.decesionLabel.textColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)

            self.editLabel.text = "完了"
            self.deleteImage.isHidden = false
            for _ in self.textDataArray{
                self.selectDataArray.append(false)
            }
            deleteImage.image = UIImage.init(named: "ic_delete_36pt_3x_gray")
            self.textView.isEditable = false
            
        }else{
            self.decesionLabel.layer.borderColor = UIColor.black.cgColor
             self.decesionLabel.textColor = UIColor.black
            self.isEidted = false
            self.editLabel.text = "編集"
            //            self.edit.textColor = UIColor.gray
            self.deleteImage.isHidden = true
            self.textView.isEditable = true
        }
        self.table.reloadData()
//        if self.textDataArray.count > 0{
//            self.decesionLabel.isHidden = false
//        }
    }
    @objc
    func save(){
        if self.textView.text == ""{
            return
        }else{
            if !isSelected{
            self.textDataArray.append(self.textView.text)
            self.textView.text = ""
            self.table.reloadData()
            }else{
                self.textDataArray[selectedNum] = self.textView.text
                self.textView.text = ""
                self.table.reloadData()
            }
        }
        var flg = 0
        if self.str == "isSet"
        {
            flg = 1
        }
        self.pushDataArray.removeAll()
        for str in self.textDataArray {
            let dic = ["ist103009":str]
            self.pushDataArray.append(dic)
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: pushDataArray, options: .prettyPrinted)
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
        let dic = ["ist103001":self.ist103001,
                  "ist103002":self.ist103002,
                  "ist103003":self.ist103003,
                  "ist103004":self.ist103005,
                  "ist103005":self.ist103004,
                  "ist103006":self.ist103006,
                  "ist102007":self.ist103007,
                  "setteigaiFlag":flg,
                  "keijouTyukiUpdateList":self.pushDataArray
                   ] as [String : Any]
     
        
        print("xxxxx",dic)
        //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
        //            print(json)
        //        }
        let url = URL.init(string:helper().api+"issat/update/tyuki/")
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        alamofireManager = SessionManager(configuration: config)
        
        alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                self.textDataArray.removeAll()
                if let val = value as? Dictionary<String, Any>{
                    print("what the fuck ",val)
                    if val["error"] != nil{
                        let alertController = UIAlertController(title: "\(val["status"] ?? "error")",
                            message: val["message"] as? String, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "はい", style: .default, handler: {
                            action in
                            print("点击了确定")
                        })
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        if let status = val["status"] as! Int?{
                            if status == 401{
                                self.showTokenError()
                                return
                            }
                        }
                        let va = val["tyuiList"] as? Array<Dictionary<String, String>>
                        for dem in va!{
                            self.textDataArray.append(dem["ist103009"]!)
                        }
                        if self.textDataArray.count > 0{
                            self.decesionLabel.isHidden = false
                        }else{
                            self.decesionLabel.isHidden = true
                        }
                    }
                }else
                {
                    // nil
                    print(value)
                }
                self.table.reloadData()
            case.failure(let error):
                print("aaaaaaa",error)
            }
        }
        
    }
    @objc
    func pop(){
        self.navigationController?.popViewController(animated: true)
        self.myDelegate.delegateToRefresh()
        self.textView.text = ""
    }
    @objc
    func myPop(){
        if isEidted{
            return
        }
        self.navigationController?.popViewController(animated: true)
        self.myDelegate.delegateToRefresh()
        self.textView.text = ""
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
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
