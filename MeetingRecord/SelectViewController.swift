//
//  SelectViewController.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/15.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit
import Alamofire
protocol Mydelegate{
    func delegateToDoSth(After:String,colorCode:String,isSosyo:Bool,tuikazokuseiFlag: String,colorName:String)
}
class SelectViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,selectColorDelegate {
    func delegateToChangeTheImage(Url: String, name: String, code: String) {
        let demo = self.rightDataArray[number] as! buzaiData
        demo.imageUrl = Url
        demo.ist204013 = name
        demo.irogaraCode = code
        self.changeValue(Array: self.rightDataArray,index: number)
        self.rightTable.reloadData()
        self.leftTable.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.str == "collor"{
//            return 1
//        }
//        return 2
        return self.titleCollectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.titleCollectionView.dequeueReusableCell(withReuseIdentifier: "tableTitle", for: indexPath) as! tableTitleCollectionViewCell
//        if indexPath.row == 0{
//            cell.nameLabel.text = "LIXIL"
//            if self.str == "collor"{
//                cell.nameLabel.text = "取手"
//            }
//        }else{
//            cell.nameLabel.text = "クリナップ"
//        }
        cell.nameLabel.text = self.titleCollectionArray[indexPath.row].ist203002
        if self.selectTitleArray[indexPath.row] == true{
            cell.sele.isHidden = false
            cell.nameLabel.textColor = UIColor.black
        }else{
            cell.sele.isHidden = true
            cell.nameLabel.textColor = UIColor.lightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 7777{
            return rightDataArray.count
            
        }
        return leftDataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 6666{
            let cell = self.leftTable.dequeueReusableCell(withIdentifier: "leftDataCell", for: indexPath) as! DataTableViewCell
            if self.leftDataArray[indexPath.row].ist204010 == "0"{
                cell.newImage.isHidden = true
            }else{
                cell.newImage.isHidden = false
            }
      
             if self.leftDataArray[indexPath.row].ist204011 == 1{
                cell.rankingImage.isHidden = false
                cell.rankingImage.image = UIImage.init(named: "11111")
                cell.ratioLabel.text = "\(self.leftDataArray[indexPath.row].ist204012)" + "%"
                cell.ratioLabel.isHidden = false
            }else if self.leftDataArray[indexPath.row].ist204011 == 2{
                cell.rankingImage.isHidden = false
                cell.rankingImage.image = UIImage.init(named: "22222")
                cell.ratioLabel.text = "\(self.leftDataArray[indexPath.row].ist204012)" + "%"
                cell.ratioLabel.isHidden = false
            }else if self.leftDataArray[indexPath.row].ist204011 == 3{
                cell.rankingImage.isHidden = false
                cell.rankingImage.image = UIImage.init(named: "33333")
                cell.ratioLabel.text = "\(self.leftDataArray[indexPath.row].ist204012)" + "%"
                cell.ratioLabel.isHidden = false
             }else{
                cell.rankingImage.isHidden = true
                cell.ratioLabel.isHidden = true
            }
//            if self.rightDataArray[indexPath.row].ist204012 == 0{
//                cell.ratioLabel.isHidden = true
//            }else{
//                cell.ratioLabel.text = "\(self.rightDataArray[indexPath.row].ist204012)" + "%"
//                cell.ratioLabel.isHidden = false
//            }
            cell.colorButton.isHidden = true
            cell.colorNameLabel.isHidden = true
            cell.selectionStyle = .none
            if self.leftDataArray[indexPath.row].ist204014 == "1"{
                if self.leftDataArray[indexPath.row].imageUrl == ""{
                    cell.headerImage.image = UIImage.init(named:"ic_palette_36pt_3x")
                }
                cell.colorNameLabel.isHidden = false
                cell.newLeft.constant = 11 + 5
                cell.newWidth.constant = 35 - 5
                cell.newTop.constant = 9
                cell.newHight.constant = 35 - 5
                
                cell.imgLeft.constant = 43 + 5
                cell.imageHight.constant = 9
                cell.imgBottom.constant = 9 + 5
                cell.imageWidth.constant = 100 - 28
                cell.colorButton.tag = 30000+indexPath.row
                cell.colorNameLabel.text = self.leftDataArray[indexPath.row].ist204013            }
            let url = URL(string: self.leftDataArray[indexPath.row].imageUrl)
            cell.headerImage.sd_setImage(with: url, placeholderImage: nil)
            //            let model = self.leftDataArray[indexPath.row] as! myClass
//            cell.nameLabel.text = model.vvv.name
//            cell.detailLabel.text = model.vvv.time
//            cell.classifyLabel.text = model.vvv.status
            cell.checkBox.isHidden = false
//            if isEidted{
                if self.selectDataArray[indexPath.row]{
                    cell.checkBox.image = UIImage.init(named: "000")
                }else{
                    cell.checkBox.image = UIImage.init(named: "111")
                }
                cell.tag = 20000 + indexPath.row
//            }else{
//                cell.checkBox.isHidden = true
//            }
            cell.checkBox.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(checkBox))
            cell.addGestureRecognizer(tap)
            if !isSosyo{
                cell.nameLabel.text = self.leftDataArray[indexPath.row].buzaiName
                cell.detailLabel.text = self.leftDataArray[indexPath.row].descriptionAbove
                cell.belowName.text = self.leftDataArray[indexPath.row].descriptionBelow
                cell.classifyLabel.text =  self.leftDataArray[indexPath.row].descriptionRight
                cell.classifyLabel.textColor = UIColor.lightGray
            }else{
                cell.nameLabel.text = self.leftDataArray[indexPath.row].buzaiName
                cell.detailLabel.text = self.leftDataArray[indexPath.row].descriptionAbove
                cell.classifyLabel.text = self.leftDataArray[indexPath.row].descriptionBelow
                cell.classifyLabel.textColor = UIColor.black
            }
//            cell.nameLabel.text = self.leftDataArray[indexPath.row].buzaiCode
            return cell
        }else{
            let cell = self.rightTable.dequeueReusableCell(withIdentifier: "rightDataCell", for: indexPath) as! DataTableViewCell
            if self.rightDataArray[indexPath.row].flag{
                cell.backgroundColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
            }else{
                cell.backgroundColor = UIColor.clear
            }
            if self.rightDataArray[indexPath.row].ist204015 == "2"{
                cell.backgroundColor = UIColor(displayP3Red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1.0)
            }
            if self.rightDataArray[indexPath.row].ist204010 == "0"{
                cell.newImage.isHidden = true
            }else{
                cell.newImage.isHidden = false
            }
            if self.rightDataArray[indexPath.row].ist204011 == 1{
                 cell.rankingImage.isHidden = false
                cell.rankingImage.image = UIImage.init(named: "11111")
                cell.ratioLabel.text = "\(self.rightDataArray[indexPath.row].ist204012)" + "%"
                cell.ratioLabel.isHidden = false
            }else if self.rightDataArray[indexPath.row].ist204011 == 2{
                cell.rankingImage.isHidden = false
                cell.rankingImage.image = UIImage.init(named: "22222")
                cell.ratioLabel.text = "\(self.rightDataArray[indexPath.row].ist204012)" + "%"
                cell.ratioLabel.isHidden = false
            }else if self.rightDataArray[indexPath.row].ist204011 == 3{
                cell.rankingImage.isHidden = false
                cell.rankingImage.image = UIImage.init(named: "33333")
                cell.ratioLabel.text = "\(self.rightDataArray[indexPath.row].ist204012)" + "%"
                cell.ratioLabel.isHidden = false
            }else{
                 cell.ratioLabel.isHidden = true
                cell.rankingImage.isHidden = true
            }
//            if self.rightDataArray[indexPath.row].ist204012 == 0{
//                 cell.ratioLabel.isHidden = true
//            }else{
//                cell.ratioLabel.text = "\(self.rightDataArray[indexPath.row].ist204012)" + "%"
//                cell.ratioLabel.isHidden = false
//            }
            cell.selectionStyle = .none
            cell.checkBox.isHidden = true
            cell.colorButton.isHidden = true
            cell.colorNameLabel.isHidden = true
            let url = URL(string: self.rightDataArray[indexPath.row].imageUrl)
            cell.headerImage.sd_setImage(with: url, placeholderImage: nil)
            if self.rightDataArray[indexPath.row].ist204014 == "1"{
            cell.colorButton.isHidden = false
                if self.rightDataArray[indexPath.row].imageUrl == ""{
                    cell.headerImage.image = UIImage.init(named:"ic_palette_36pt_3x")
                }
                cell.colorNameLabel.isHidden = false
                cell.colorNameLabel.isHidden = false
                cell.newLeft.constant = 11 + 5
                cell.newWidth.constant = 35 - 5
                cell.newTop.constant = 9
                cell.newHight.constant = 35 - 5
                
                cell.imgLeft.constant = 43 + 5
                cell.imageHight.constant = 9
                cell.imgBottom.constant = 9 + 5
                cell.imageWidth.constant = 100 - 28
                cell.colorButton.tag = 30000+indexPath.row
                cell.colorNameLabel.text = self.rightDataArray[indexPath.row].ist204013
                cell.colorButton.addTarget(self, action: #selector(showCollor), for: UIControlEvents.touchUpInside)
            }
//            let model = self.rightDataArray[indexPath.row] as! myClass
//            if !model.vvv.onOff{
//                cell.backgroundColor = UIColor.white
//            }else{
//                cellf.collerButton.backgroundColor = UIColor.yellow
//                cell.backgroundColor = UIColor.gray
//
//            }
//            cell.nameLabel.text = model.vvv.name
//            cell.checkBox.isHidden = true
//            cell.detailLabel.text = model.vvv.time
//            cell.classifyLabel.text = model.vvv.status
//            if self.str == "collor"{
//                cell.collerButton.isHidden = false
//                cell.collerButton.tag = 30000 + indexPath.row
//                cell.collerButton.addTarget(self, action: #selector(SelectViewController.showCollor), for: UIControlEvents.touchUpInside)
//                cell.detailLabel.isHidden = true
//                cell.classifhjyLabel.isHidden = true
//            }else{
//                cell.collerButton.isHidden = true
//            }
            
            if !isSosyo{
                cell.nameLabel.text = self.rightDataArray[indexPath.row].buzaiName
                cell.detailLabel.text = self.rightDataArray[indexPath.row].descriptionAbove
                cell.belowName.text = self.rightDataArray[indexPath.row].descriptionBelow
                cell.classifyLabel.text = self.rightDataArray[indexPath.row].descriptionRight
                 cell.classifyLabel.textColor = UIColor.lightGray
            }else{
                cell.nameLabel.text = self.rightDataArray[indexPath.row].buzaiName
                cell.detailLabel.text = self.rightDataArray[indexPath.row].descriptionAbove
                cell.classifyLabel.text = self.rightDataArray[indexPath.row].descriptionBelow
                cell.classifyLabel.textColor = UIColor.black
            }
            //new
            if self.rightDataArray[indexPath.row].ist204010 == "0"{
                cell.newImage.isHidden = true
            }else
            {
                cell.newImage.isHidden = false
            }
            return cell
        }
    }
    @objc func showCollor(btn:UIButton) {
        let colorVC = ColorViewController()
        colorVC.myDelegate = self
        number = btn.tag - 30000
        colorVC.ist209001 = self.rightDataArray[number].ist204001
        colorVC.ist209002 = self.rightDataArray[number].ist204002
          colorVC.myTitle = self.rightDataArray[number].buzaiName
        colorVC.returnText =  self.myTitle
        colorVC.ist204023 = self.rightDataArray[number].ist204023

        self.navigationController?.pushViewController(colorVC, animated: true)
    }
    @objc
    func checkBox(tap:UITapGestureRecognizer){
        let view = tap.view as! DataTableViewCell
       let number = view.tag - 20000
        self.selectDataArray[number] = !self.selectDataArray[number]
        var array = Array<Bool>()
        for value in self.selectDataArray{
            if value{
                array.append(value)
            }
        }

        if  array.count >= 1{
            self.brash.isHidden = false
             self.decesion.isHidden = false
               self.decesion.textColor = UIColor.black
               self.decesion.layer.borderColor = UIColor.black.cgColor
            self.brash.image = UIImage.init(named: "ic_delete_36pt")
        }else{
            self.brash.image = UIImage.init(named: "ic_delete_36pt_3x_gray")
//            self.brash.isHidden = true
//            self.decesion.isHidden = true
            self.decesion.textColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
            self.decesion.layer.borderColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0).cgColor
        }
        if array.count >= 2 || array.count == 0{
           self.decesion.textColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
            self.decesion.layer.borderColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0).cgColor
        }else{
            self.decesion.textColor = UIColor.black
            self.decesion.layer.borderColor = UIColor.black.cgColor
//            self.decesion.isHidden = false
            
        }
   
        
        self.leftTable.reloadData()
        print(self.selectDataArray)
    }
    var alamofireManager : SessionManager?
    @IBOutlet weak var rightTable: UITableView!
    @IBOutlet weak var leftTable: UITableView!
    
    @IBOutlet weak var titleCollectionView: UICollectionView!
    var titleCollectionArray = Array<zokuseiItitData>()
    @IBOutlet weak var edit: UILabel!
    @IBOutlet weak var brash: UIImageView!
    
    var myDelegate:Mydelegate!
    var number = 0
    
    var isEidted = false
    var dataArray1 = Array<Any>()
    var dataArray2 = Array<Any>()
    var leftDataArray = Array<buzaiData>()
    var rightDataArray = Array<buzaiData>()
    var allDataArray = Array<Any>()
    var selectDataArray = Array<Bool>()
    var selectTitleArray =  Array<Bool>()
    var str = ""

    var ist102001 = 0
    var ist102002 = ""
    var ist102003 = ""
    var ist102004 = ""
    var ist102005 = ""
    var ist102006 = ""

    var ist101016 = ""
    var ist201006 = ""
    var ist201001 = ""
    var ist201019 = 0
    
    var ist201007 = ""
    var isSosyo = false
    var tuikazokuseiFlag = ""
    var myTitle = ""
    var hasSelect = false
    @IBOutlet weak var ListTitleLabel: UILabel!
    @IBOutlet weak var decesion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.decesion.isHidden = true
        self.decesion.isUserInteractionEnabled = true
        let decesionTap = UITapGestureRecognizer(target: self, action: #selector(SelectViewController.decesionTap))
        self.decesion.addGestureRecognizer(decesionTap)
        self.decesion.layer.borderColor = UIColor.black.cgColor
        self.decesion.layer.cornerRadius = 10
        self.decesion.layer.borderWidth = 1
        self.navigationItem.title = myTitle
        self.decesion.textColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
        self.decesion.layer.borderColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0).cgColor
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        label.font = UIFont.init(name: "HiraginoSans-W3", size: 16)
        label.text = "< システムキッチン"
        let leftBar = UIBarButtonItem(customView: label)
        self.navigationItem.leftBarButtonItem = leftBar
        label.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(SelectViewController.pop))
        label.addGestureRecognizer(backTap)
        // Do any additional setup after loading the view.
        self.titleCollectionView.delegate = self
        self.titleCollectionView.dataSource = self
        let subflow = UICollectionViewFlowLayout()
        subflow.scrollDirection = .horizontal
        subflow.itemSize = CGSize(width: 135, height: 50)
        self.titleCollectionView.setCollectionViewLayout(subflow, animated: true)
        self.titleCollectionView.register(UINib.init(nibName: "tableTitleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tableTitle")
        self.leftTable.register(UINib.init(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "leftDataCell")
        self.leftTable.delegate = self
        self.leftTable.dataSource = self
        self.rightTable.register(UINib.init(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "rightDataCell")
        self.rightTable.delegate = self
        self.rightTable.dataSource = self
        //
//        self.test()
//        self.edit.isUserInteractionEnabled = true
//        let editTap = UITapGestureRecognizer(target: self, action: #selector(SelectViewController.editTap))
//        edit.addGestureRecognizer(editTap)
//        self.brash.isHidden = true
        self.brash.isUserInteractionEnabled = true
        let brashTap = UITapGestureRecognizer(target: self, action: #selector(SelectViewController.deletedCell))
        self.brash.addGestureRecognizer(brashTap)
        self.getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        let dict:NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font : UIFont.init(name: "HiraginoSans-W3", size: 16)]
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : AnyObject]
    }
    let header = MdUtils.getAuthHeader()
    func pleasWaiting(){
        var imagesArray = Array<UIImage>()
        for i in 0...21 {
            imagesArray.append(UIImage(named: "loading_\(i)")!)
        }
        self.pleaseWaitWithImages(imagesArray, timeInterval: 50)
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
    func getData(){
        self.pleasWaiting()
        let dic = [
                   "ist102001":ist102001,
                   "ist102002":ist102002,
                   "ist102003":ist102003,
                   "ist102004":ist102004,
                   "ist102005":ist102005,
                   "ist102006":ist102006,
//                   "ist101016":self.ist101016,
                   "ist201006":self.ist201006,
                   "ist201001":self.ist201001,
                   "ist201019":ist201019,
            "ist201007":ist201007,
            "tuikazokuseiFlag":tuikazokuseiFlag
            ] as [String : Any]
        print("dicdic",dic)
        //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
        //            print(json)
        //        }f
        let url = URL.init(string:helper().api+"issat/select/zokuseiti/")
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        alamofireManager = SessionManager(configuration: config)
        
        alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                self.clearAllNotice()
                let val = value as! Dictionary<String,Any>
                if val["error"] == nil{
                    print("Dictionary",value)
                    let model = zokuseSelectData(dic: val)
                    self.myTitle = model.data.ist001002
                    self.navigationItem.title = self.myTitle
                    print("zokuseimei",model.data.ist001002)
                    self.titleCollectionArray = model.data.zokuseitiDataList
                    self.selectTitleArray.removeAll()
                    for _ in self.titleCollectionArray{
                        self.selectTitleArray.append(false)
                    }
                    var i = 0
                    for titleDemo in self.titleCollectionArray{
                        let buzaiList = titleDemo.buzaiDataList
                        for dem in buzaiList{
                            if dem.ist204015 == "1"
                            {
                                self.leftDataArray.append(dem)
                                dem.flag = true
                                self.hasSelect = true
                                self.selectTitleArray[i] = true
                                self.rightDataArray = self.titleCollectionArray[i].buzaiDataList
                            }
                        }
                        i+=1
                    }
                    if !self.hasSelect{
                        self.selectTitleArray[0] = true
                        self.rightDataArray = self.titleCollectionArray[0].buzaiDataList
                    }
                            self.selectDataArray.removeAll()
                    
                            for _ in self.leftDataArray{
                            self.selectDataArray.append(false)
                    }
                    
                    self.titleCollectionView.reloadData()
                    self.rightTable.reloadData()
                    self.leftTable.reloadData()
                    
                }else{
                    let status = val["status"] as! Int
                    if status == 401{
                        self.showTokenError()
                        return
                    }
                    print("error",val)
                    let alertController = UIAlertController(title: "\(val["status"] ?? "error")",
                        message: val["message"] as? String, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "はい", style: .default, handler: {
                        action in
                        print("点击了确定")
                    })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            case.failure(let error):
                self.clearAllNotice()
                print("aaaaaaa",error)
            }
        }
    }
    @objc
    func decesionTap(){
        var x = 0
        for bo in self.selectDataArray{
            if bo{
                    x += 1
            }
        }
        if x > 1{
            return
        }
        var i = 0
        for bo in self.selectDataArray{
            if bo{
                let demo = self.leftDataArray[i]
                self.navigationController?.popViewController(animated: true)
                if self.myDelegate != nil{
                    var myCode = ""
                    if isSosyo{
                        myCode = demo.ist204001
                    }else{
                        myCode = demo.ist204002
                    }
                    var colorCode =  demo.irogaraCode
                    
                    var ist204013 = demo.ist204013
                    self.myDelegate.delegateToDoSth(After: myCode, colorCode:colorCode, isSosyo: isSosyo, tuikazokuseiFlag: tuikazokuseiFlag, colorName: ist204013)
                }
            }

            i += 1
        }
    }
    @objc
   func deletedCell(){
        var a = 0
     
        var i = 0
        for bo in self.selectDataArray{
            if bo{
                let demo = self.leftDataArray[i]
                demo.flag = false
//                demo.vvv.onOff = false
//                print(demo.vvv.name)
            }
            i += 1
        }
        
        self.leftDataArray.removeAll()
        for titleDemo in self.titleCollectionArray{
            let buzaiList = titleDemo.buzaiDataList
            for dem in buzaiList{
                if dem.flag
                {
                    self.leftDataArray.append(dem)
                }
            }
            i+=1
        }
//        var array = Array<Bool>()
//        for value in self.selectDataArray{
//            if !value{
//                array.append(value)
//            }
//        }
//
//        if  array.count >= 1{
//            self.brash.isHidden = false
//            self.decesion.isHidden = false
//        }else{
//            self.brash.isHidden = true
//        }
//        if array.count >= 2 || array.count == 0{
//            self.decesion.isHidden = true
//        }else{
//            self.decesion.isHidden = false
//        }
//
//         self.decesion.isHidden = true
//         self.brash.isHidden = true
        self.selectDataArray.removeAll()
        
        for _ in self.leftDataArray{
            self.selectDataArray.append(false)
        }
//        for dem in self.allDataArray{
//
//            let m = dem as! myClass
////            if m.vvv.onOff == true{
////                self.leftDataArray.append(dem)
////            }
//        }
//        if self.leftDataArray.count > 0
//        {
//            self.ListTitleLabel.textColor = UIColor.black
//        }else{
//            self.ListTitleLabel.textColor = UIColor.lightGray
//        }
        self.brash.image = UIImage.init(named: "ic_delete_36pt_3x_gray")
        //            self.brash.isHidden = true
        //            self.decesion.isHidden = true
        self.decesion.textColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
        self.decesion.layer.borderColor = UIColor(displayP3Red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0).cgColor
        self.leftTable.reloadData()
        self.rightTable.reloadData()
//        self.editTap()
    }
//    @objc
//    func editTap(){
//        self.selectDataArray.removeAll()
//        if !isEidted{
//            self.isEidted = true
////            self.edit.textColor = UIColor.black
//            self.edit.text = "完了"
//            self.brash.isHidden = false
//            for _ in self.leftDataArray{
//                self.selectDataArray.append(false)
//            }
//
//        }else{
//            self.isEidted = false
//            self.edit.text = "編集"
//
////            self.edit.textColor = UIColor.gray
//            self.brash.isHidden = true
//        }
//        self.leftTable.reloadData()
//    }
    func test(){
        var dic1 = ["name":"LDSKシリーズ","time":"16年6月設定","status":"LIXIL","onOff":false,"image":"1"] as [String : Any]
        var dic4 = ["name":"LDAKシリーズ","time":"18年6月設定","status":"LIXIL","onOff":false, "image":"2"] as [String : Any]
        var dic2 = ["name":"LCPKシリーズ","time":"※標準扉仕様※17年10月一部改廃","status":"クリナップ","onOff":false,"image":"3"] as [String : Any]
        var dic3 = ["name":"LRKKシリーズ","time":"※標準扉仕様※16年6月設定","status":"クリナップ","onOff":false,"image":"4"] as [String : Any]
           var dic5 = ["name":"LRKAシリーズ","time":"※標準扉仕様※16年9月設定","status":"クリナップ","onOff":false,"image":"4"] as [String : Any]
        if self.str == "collor"{
             dic1 = ["name":"扉色柄(バー取手)","time":"16年6月設定","status":"LIXIL","onOff":false,"image":"1"] as [String : Any]
             dic4 = ["name":"扉色柄(ライン取手)","time":"18年6月設定","status":"LIXIL","onOff":false, "image":"2"] as [String : Any]        }
        let demo1 = myClass(dic: dic1)
        let demo2 = myClass(dic: dic4)
        let demo3 = myClass(dic: dic2)
        let demo4 = myClass(dic: dic3)
        let demo5 = myClass(dic: dic5)

        self.dataArray1.append(demo1)
        self.dataArray1.append(demo2)
        self.dataArray2.append(demo3)
        self.dataArray2.append(demo4)
        self.dataArray2.append(demo5)
        self.allDataArray.append(contentsOf: self.dataArray1)
        self.allDataArray.append(contentsOf: self.dataArray2)
}
    
    @objc
    func pop(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            self.rightDataArray = self.dataArray1
//        }else{
//            self.rightDataArray = self.dataArray2
//        }
//        let ite = collectionView.cellForItem(at: indexPath) as! tableTitleCollectionViewCell
//        ite.sele.isHidden = false
////        self.changeValue(Array: self.rightDataArray,index: indexPath.row)
////        self.leftTable.reloadData()
//        self.rightTable.reloadData()
        self.selectTitleArray.removeAll()
        for _ in self.titleCollectionArray{
            self.selectTitleArray.append(false)
        }
        self.selectTitleArray[indexPath.row] = true
      
        self.titleCollectionView.reloadData()
        self.rightDataArray = self.titleCollectionArray[indexPath.row].buzaiDataList
        self.rightTable.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let ite = collectionView.cellForItem(at: indexPath) as! tableTitleCollectionViewCell
//        ite.sele.isHidden = true
    }
    func changeValue(Array:Array<Any>,index:Int){
        let demo = Array[index] as! buzaiData
        demo.flag = true
        self.leftDataArray.removeAll()
//        self.titleCollectionArray[indexPath.row].buzaiDataList
        for titleDemo in self.titleCollectionArray{
            let buzaiList = titleDemo.buzaiDataList
            for dem in buzaiList{
                if dem.flag == true
                {
                    self.leftDataArray.append(dem)
                }
            }
        }
//                self.selectDataArray.removeAll()
//            for _ in self.leftDataArray{
                self.selectDataArray.append(false)
//            }
        if self.leftDataArray.count > 0
        {
            self.ListTitleLabel.textColor = UIColor.black
        }else{
            self.ListTitleLabel.textColor = UIColor.lightGray
        }
        self.leftTable.reloadData()
   
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 7777 {
            if self.rightDataArray[indexPath.row].ist204015 == "2"{
                return
            }
            if !isEidted{
                self.changeValue(Array: self.rightDataArray,index: indexPath.row)
            }
            self.rightTable.reloadData()
        }else{
            return
            if isEidted{
                self.selectDataArray[indexPath.row] = !self.selectDataArray[indexPath.row]
                self.leftTable.reloadData()
                print(self.selectDataArray)
            }else{
                self.navigationController?.popViewController(animated: true)
                if self.myDelegate != nil{
                    var myCode = ""
                    if isSosyo{
                        myCode = self.leftDataArray[indexPath.row].ist204001
                    }else{
                        myCode = self.leftDataArray[indexPath.row].ist204002
                    }
                    var colorCode =  self.leftDataArray[indexPath.row].irogaraCode
                    
                    var ist204013 =  self.leftDataArray[indexPath.row].ist204013
                    self.myDelegate.delegateToDoSth(After: myCode, colorCode:colorCode, isSosyo: isSosyo, tuikazokuseiFlag: tuikazokuseiFlag, colorName: ist204013)
                }
            }
        }
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
