

//
//  MainViewController.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/10.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit
import PDFReader
import Alamofire
import SDWebImage
class MainViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,Mydelegate,UITableViewDelegate,UITableViewDataSource,messageDelegate{
   var isMessageDelegate = false
   func delegateToRefresh() {
      self.isMessageDelegate = true
      self.getMenuData(Index: self.myindex)
   }
   var myindex = IndexPath(row: 0, section: 0)
   var soushouCodeBefore = ""
   var meisaiCodeBefore = ""
   var isFirst = false
   func delegateToDoSth(After: String, colorCode: String, isSosyo: Bool, tuikazokuseiFlag: String,colorName: String) {
      var dic:[String : Any]!
      self.pleasWaiting()
      if isSosyo{
          dic = [ "ist102001": self.number,
                     "ist102002": self.ist207001,
                     "ist102003": self.ist207002,
                     "ist102004": self.ist207003,
                     "ist102005": self.ist207004,
                     "ist102006": self.ist207005,
                     "ist101016": self.cojiNumber,
                     "soushouCodeBefore":self.menuArray[0].ist201006,
                     "soushouCodeAfter":After,
                     "meisaiCodeBefore":"0000000",
                     "meisaiCodeAfter":"0000000",
                     "ist102045": ""
                     ]
         
      }else{
         dic = [ "ist102001": self.number,
                 "ist102002": self.ist207001,
                 "ist102003": self.ist207002,
                 "ist102004": self.ist207003,
                 "ist102005": self.ist207004,
                 "ist102006": self.ist207005,
                 "ist101016": self.cojiNumber,
                 "soushouCodeBefore":self.menuArray[0].ist201006,
                 "soushouCodeAfter":self.menuArray[0].ist201006,
                 "meisaiCodeBefore":meisaiCodeBefore,
                 "meisaiCodeAfter":After,
                 "ist102045":colorCode,
                 "ist102046":colorName,
            "tuikazokuseiFlag":tuikazokuseiFlag
         ]
      }
      //       print("menuData",dic)
      //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
      //            print(json)
      //        }
      let url = URL.init(string: helper().api+"issat/update/buzai/")
      print("url",url)
      let config = URLSessionConfiguration.default
      config.timeoutIntervalForRequest = 15
      alamofireManager = SessionManager(configuration: config)
      
      alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
         switch response.result {
         case.success(let value):
            self.clearAllNotice()
            print("uuuu",value)
            let val = value as! Dictionary<String,Any>
            if val["error"] == nil{
               let model = myMenuClass(dic: value as! Dictionary<String, Any>)
               self.menuArray = model.data.myZokuseiList
               if self.menuArray.count > 0{
                  self.menuCollection.isHidden = false
                  self.myPageControl.isHidden = false
               }
               self.menuCount = self.menuArray.count + 1
               while self.menuCount % 15 != 0{
                  self.menuCount+=1
               }
               for value in self.menuArray{
                  if  value.ist201018 == "0"{
                     self.hasDeleted = true
                  }
               }
               if self.hasDeleted{
                  self.deleteLabel.isHidden = false
               }else{
                  self.deleteLabel.isHidden = true
               }
               
               self.myPageControl.numberOfPages = self.menuCount/15
               //変えてない
//               self.ist207001 = self.subHeaderArray[Index.row].ist207001
//               self.ist207002 = self.subHeaderArray[Index.row].ist207002
//               self.ist207003 = self.subHeaderArray[Index.row].ist207003
//               self.ist207004 = self.subHeaderArray[Index.row].ist207004
//               self.ist207005 = self.subHeaderArray[Index.row].ist207005
               let index = IndexPath(item: self.HeaderNum, section: 0)
               let cell = self.NaviCollection.cellForItem(at: index) as! NaviCollectionViewCell
               cell.progress.setProgress(model.data.buibunruiDecisionRate, animated: true)
               
               let myIndex = IndexPath(item: self.subHeaderNum, section: 0)

               let myCell = self.subNaviCollection.cellForItem(at: myIndex) as! SubNaviCollectionViewCell
               
               self.headerArray[self.HeaderNum].decisionRate = model.data.buibunruiDecisionRate
               self.subHeaderArray[self.subHeaderNum].decisionRate = model.data.buiDecisionRate
               if model.data.buiDecisionRate == 1{
                  self.isPerFect = true
               }else{
                  self.isPerFect = false
               }
               if self.isPerFect{
                  self.imageView1.image = UIImage.init(named: "ic_insert_drive_file_36pt")
                  let url = URL(string: model.data.buibunruiIconUrl)
                  cell.header.sd_setImage(with: url, placeholderImage: nil)
               }else{
                  self.imageView1.image = UIImage.init(named: "")
               }
               if self.subHeaderArray[self.subHeaderNum].decisionRate == 1{
                  myCell.backgroundColor = UIColor(displayP3Red: 241/255.0, green: 249/255.0, blue:  254/255.0, alpha: 1.0)

               }else
               {
                  myCell.backgroundColor = UIColor.clear
               }
               self.menuCollection.reloadData()
            }else{
               let status = val["status"] as! Int
               if status == 401{
                  self.showTokenError()
                  return
               }
               let alertController = UIAlertController(title: "\(val["status"] ?? "error")",
                  message: val["message"] as? String, preferredStyle: .alert)
               let okAction = UIAlertAction(title: "はい", style: .default, handler: {
                  action in
                  print("点击了确定")
               })
               alertController.addAction(okAction)
               self.present(alertController, animated: true, completion: nil)
            }
            print("self.menuArray",self.menuArray.count)
            
            
         case.failure(let error):
            self.clearAllNotice()
            print("aaaaaaa",error)
         }
      }
   }
   
   var tableDataArray = Array<ListData>()
   var myTableDataArray = Array<myConfirmData>()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if isAdd{
         return tableDataArray.count + 1

      }else{
         return myTableDataArray.count + 1
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = self.popTable.dequeueReusableCell(withIdentifier: "popHeader", for: indexPath) as! popHeaderTableViewCell
         if isAdd{
            cell.headerTitle.text = "追加する属性の選択"
//            cell.textLabel?.isHidden = true
            cell.myTextLabel.isHidden = true
         }else{
            cell.headerTitle.text = "確認事項"
            cell.myTextLabel.isHidden = false
         }
         cell.selectionStyle = .none
            return cell
        }else{
            let cell = self.popTable.dequeueReusableCell(withIdentifier: "popTable", for: indexPath) as! popTableViewCell
            cell.selectionStyle = .none
         if isAdd{
            cell.nameLabel.text = self.tableDataArray[indexPath.row - 1].ist202002
         }else{
            cell.nameLabel.text = self.myTableDataArray[indexPath.row - 1].ist003006
         }
            return cell
        }
    }
    var HaveBeenDone = false
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if isAdd{
         self.popTable.removeFromSuperview()
         self.backView.removeFromSuperview()
//         self.menuCollection.reloadData()
         if indexPath.row == 0{
            return
         }
         self.getDetailData(num: indexPath.row)
      }

      
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0{
//            if isAdd{
//                return 1
//            }else{
//                return 70
//            }
//        }else{
//            return 90
//        }
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if indexPath.row == 0{
         if isAdd {
            return 20
         }
                return 60
        }else{
                return 70
        }
    }
    
    func delegateToDoSth() {
        self.num = 50
        self.NaviCollection.reloadData()
        let index = NSIndexPath(index: 0)
        let myindex = IndexPath(row: 0, section: 0)
        self.isDelegate = true
//        let ite = NaviCollection.cellForItem(at: myindex) as! NaviCollectionViewCell
//        ite.sele.isHidden = false
//        self.NaviCollection.selectItem(at: myindex, animated: true, scrollPosition: UICollectionViewScrollPosition(rawValue: 0))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(collectionView.tag)
        if collectionView.tag == 1000{
            return self.headerArray.count
        }else if collectionView.tag == 1001{
            return self.subHeaderArray.count
        }
        else if collectionView.tag == 1002{
            print("aaa",self.menuArray.count)
         if isSetting{
            return 1
         }else{
            return self.menuCount

         }
        }
        return 10
    }
    var headerArray = Array<buibunruiData>()
    var selectArray = Array<Bool>()
    var subHeaderArray = Array<buiData>()
    var subSelectArray = Array<Bool>()
    var menuArray = Array<zukuseiData>()
    var menuSelectArray = Array<Bool>()
    var menuCount = 0
    var nameArray = ["キッチン","浴室","洗面室","洗濯機置き場","トイレ(1F)","トイレ(2F)"]
      var name1Array = ["システムキッチン","キッチン水栓","浄水器","キッチン廻壁仕上材","カップポード","収納部材"]
    var popTableArray = ["開口配慮","排水経路","PS","リモコン位置"]
    var isDelegate = false
    var num = 0
    var lastNum = -1
    var unreadCount = 0
   var isSetting = false
    var isDeleting = false
   var isPerFect = false
   var hasDeleted = false
    @IBOutlet weak var deleteLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var deleteImage: UIImageView!
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1000{
            let cell = self.NaviCollection.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! NaviCollectionViewCell
            cell.name.text = self.headerArray[indexPath.row].ist206004
//            cell.header.image = UIImage.init(named: self.headerArray[indexPath.row])
         
            let url = URL(string: self.headerArray[indexPath.row].imageUrl)
            cell.header.sd_setImage(with: url, placeholderImage: nil)
         //            cell.name.text = self.nameArray[indexPath.row]
            cell.sele.isHidden = !self.selectArray[indexPath.row]
         if self.selectArray[indexPath.row]{
            cell.name.textColor = UIColor.black
         }else{
             cell.name.textColor = UIColor.lightGray
         }
//          to do select
           cell.progress.setProgress(self.headerArray[indexPath.row].decisionRate, animated: false)
//            if indexPath.row == 0{
//                if isDelegate {
//                    cell.sele.isHidden = false
//                }
//                 cell.progress.setProgress(cell.progress.progress + num, animated: true)
//            }else{
//                 cell.progress.setProgress(0, animated: true)
//            }
         
            return cell
        }else if collectionView.tag == 1001 {
            let cell = self.subNaviCollection.dequeueReusableCell(withReuseIdentifier: "sub", for: indexPath) as! SubNaviCollectionViewCell
            cell.sele.isHidden = !self.subSelectArray[indexPath.row]
         if self.subSelectArray[indexPath.row]{
            cell.nameLabel.textColor = UIColor.black
         }else{
            cell.nameLabel.textColor = UIColor.lightGray
         }

            cell.nameLabel.text = self.subHeaderArray[indexPath.row].ist207006
         if self.subHeaderArray[indexPath.row].decisionRate == 0{
            cell.backgroundColor = UIColor.clear

         }else
         {
            cell.backgroundColor = UIColor(displayP3Red: 241/255.0, green: 249/255.0, blue:  254/255.0, alpha: 1.0)
         }

            return cell
        }
        else if collectionView.tag == 1002 {
         if !isSetting{
            if indexPath.row < self.menuArray.count{
                let cell = self.menuCollection.dequeueReusableCell(withReuseIdentifier: "menu", for: indexPath) as! MenuCollectionViewCell
                cell.layer.borderWidth = 0.5
                cell.layer.borderColor = UIColor(displayP3Red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1).cgColor
                cell.namelabel.text = self.menuArray[indexPath.row].nameAbove
                //            cell.myImageView.image = UIImage.init(named: self.menuArray[indexPath.row])
                //test
               if self.menuArray[indexPath.row].ist201006 == "" && self.menuArray[indexPath.row].ist201007 == ""{
                     cell.imageHight.constant = 144 - 90
                  cell.leftMargin.constant = 30 + 45
                  cell.rightMargin.constant = 30 + 45
                  cell.TopMargin.constant = 45
                  cell.nameLabelTopMargin.constant = 20
                  cell.subName.isHidden = true
                  cell.backGroud.isHidden = true
                  cell.namelabel.textAlignment = .center
                  cell.subName.textAlignment = .center
                  cell.namelabel.font = UIFont.systemFont(ofSize: 16)
               }else{
                  cell.subName.isHidden = false
                  cell.imageHight.constant = 144 - 30
                  cell.leftMargin.constant = 30
                  cell.rightMargin.constant = 30
                  cell.nameLabelTopMargin.constant = 3
                  cell.TopMargin.constant = 0
                  cell.subName.text = self.menuArray[indexPath.row].nameBelow
                  cell.backGroud.isHidden = false
                  cell.namelabel.textAlignment = .left
                  cell.subName.textAlignment = .left
                  cell.namelabel.font = UIFont.systemFont(ofSize: 11)
               }
                cell.backgroundColor = UIColor.white
//                cell.myImageView.backgroundColor = UIColor.clear
                let url = URL(string: self.menuArray[indexPath.row].imageUrl)
                cell.myImageView.sd_setImage(with: url, placeholderImage: nil)
               cell.susume.tag = 30000+indexPath.row
               
                if self.menuArray[indexPath.row].ist201002 == "0" && self.menuArray[indexPath.row].ist201003 == "0"{
                    cell.susume.isHidden = true
                }else if self.menuArray[indexPath.row].ist201002 == "1"{
                    cell.susume.isHidden = false
                    cell.susume.layer.cornerRadius = 8
                    cell.susume.layer.borderColor = UIColor.blue.cgColor
                    cell.susume.setTitle("なし", for: .normal)
                    cell.susume.backgroundColor = UIColor.lightGray
                  cell.susume.addTarget(self, action: #selector(MainViewController.nasiTap(sender:)), for: UIControlEvents.touchUpInside)
                }else if self.menuArray[indexPath.row].ist201002 == "2"{
                    cell.susume.isHidden = false
                    cell.susume.layer.cornerRadius = 8
                    cell.susume.layer.borderColor = UIColor.blue.cgColor
                    cell.susume.setTitle("なし", for: .normal)
                    cell.susume.backgroundColor =  UIColor(displayP3Red: 0/255.0,green: 112/255.0, blue: 192/255.0, alpha: 1)
                  cell.susume.addTarget(self, action: #selector(MainViewController.nasiTap(sender:)), for: UIControlEvents.touchUpInside)
                }else if self.menuArray[indexPath.row].ist201003 == "1"{
                    cell.susume.isHidden = false
                    cell.susume.layer.cornerRadius = 8
                    cell.susume.layer.borderColor = UIColor.blue.cgColor
                    cell.susume.setTitle("推奨", for: .normal)
                    cell.susume.backgroundColor = UIColor.lightGray
                  cell.susume.addTarget(self, action: #selector(MainViewController.susumeTap(sender:)), for: UIControlEvents.touchUpInside)
                }else if self.menuArray[indexPath.row].ist201003 == "2"{
                    cell.susume.isHidden = false
                    cell.susume.layer.cornerRadius = 8
                    cell.susume.layer.borderColor = UIColor.blue.cgColor
                    cell.susume.setTitle("推奨", for: .normal)
                    cell.susume.backgroundColor =  UIColor(displayP3Red: 0/255.0,green: 112/255.0, blue: 192/255.0, alpha: 1)
                  cell.susume.addTarget(self, action: #selector(MainViewController.susumeTap(sender:)), for: UIControlEvents.touchUpInside)
                }else if self.menuArray[indexPath.row].ist201003 == "3"{
                  cell.susume.isHidden = false
                  cell.susume.layer.cornerRadius = 8
                  cell.susume.layer.borderColor = UIColor.blue.cgColor
                  cell.susume.setTitle("推奨", for: .normal)
                  cell.susume.backgroundColor =  UIColor(displayP3Red: 0/255.0,green: 112/255.0, blue: 192/255.0, alpha: 1)
                  cell.susume.addTarget(self, action: #selector(MainViewController.susumeTap(sender:)), for: UIControlEvents.touchUpInside)
                }
                else{
                  cell.susume.isHidden = true
               }
               if self.menuArray[indexPath.row].ist201008 == ""{
                  cell.colorLabel.isHidden = true
               }else{
                  cell.colorLabel.isHidden = false
               }
               if self.menuArray[indexPath.row].ist201004 == "0"{
                  cell.confirmBtn.isHidden = true
               }else if self.menuArray[indexPath.row].ist201004 == "1"{
                  cell.confirmBtn.isHidden = false
                  cell.confirmBtn.setImage(UIImage.init(named: "ic_more_horiz_36pt_3x_pink"), for: .normal)

               }else if self.menuArray[indexPath.row].ist201004 == "2"{
                  cell.confirmBtn.isHidden = false
                  cell.confirmBtn.setImage(UIImage.init(named: "ic_more_horiz_36pt"), for: .normal)
               }
               cell.confirmBtn.tag = 40000 + indexPath.row
               cell.confirmBtn.addTarget(self, action: #selector(MainViewController.confirmTap(sender:)), for: UIControlEvents.touchUpInside)
               
               cell.checkBox.isHidden = true
               cell.checkBox.isUserInteractionEnabled = true
               cell.checkBox.tag = 40000+indexPath.row
               let checkBTap = UITapGestureRecognizer(target: self, action: #selector(checkBoxTap(sender:)))
               cell.checkBox.addGestureRecognizer(checkBTap)
                if isDeleting{
                    if self.menuArray[indexPath.row].ist201018 == "0"{
                    if self.menuSelectArray[indexPath.row]{
                        cell.checkBox.image = UIImage.init(named: "000")
                    }else{
                     cell.checkBox.image = UIImage.init(named: "111")

                     }
                        cell.checkBox.isHidden = false
                     
                    }else{
                     cell.checkBox.isHidden = true
                    }
                }
                return cell
            }
            else if indexPath.row == self.menuArray.count{
               let cell = self.menuCollection.dequeueReusableCell(withReuseIdentifier: "plus", for: indexPath)
               return cell
            }
            else{
                 let cell = self.menuCollection.dequeueReusableCell(withReuseIdentifier: "me", for: indexPath)
                return cell
            }
         }else{
            let cell = self.menuCollection.dequeueReusableCell(withReuseIdentifier: "set", for: indexPath)
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor(displayP3Red: 217/255.0, green:  217/255.0, blue:  217/255.0, alpha: 1.0).cgColor
            return cell
         }
         

        }
        let cell = self.NaviCollection.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath)
        return cell
    }
   @objc
   func checkBoxTap(sender:UITapGestureRecognizer){
      let view = sender.view
      let tag = (view?.tag)! - 40000
      self.menuSelectArray[tag] = !self.menuSelectArray[tag]
      self.menuCollection.reloadData()
      var i = 0
      for value in self.menuSelectArray{
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
    @objc
   func confirmTap(sender:UIButton){
      let num = sender.tag - 40000
         isAdd = false
         backView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.3
        backView.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backVTap))
        backView.addGestureRecognizer(backTap)
        self.view.addSubview(backView)
        self.view.addSubview(self.popTable)
      
      let dic = [ "ist102001": self.number,
                  "ist102002": self.subHeaderArray[self.subHeaderNum].ist207001,
                  "ist102003": self.subHeaderArray[self.subHeaderNum].ist207002,
                  "ist102004": self.subHeaderArray[self.subHeaderNum].ist207003,
                  "ist102005": self.subHeaderArray[self.subHeaderNum].ist207004,
                  "ist102006": self.subHeaderArray[self.subHeaderNum].ist207005,
                  "ist102007": self.menuArray[num].ist201006,
                  "ist105007": self.menuArray[num].ist201001,
                ] as [String : Any]
      //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
      //            print(json)
      //        }
      print("susumeTap",dic)
      let url = URL.init(string: helper().api+"issat/update/kakuninkomoku/")
      let str = self.getJSONStringFromDictionary(dictionary: dic)
      let config = URLSessionConfiguration.default
      config.timeoutIntervalForRequest = 15
      alamofireManager = SessionManager(configuration: config)
      
      alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
         switch response.result {
         case.success(let value):
                        print("confirm",value)
            let val = value as! Dictionary<String,Any>
            if val["error"] == nil{
               let model = confirmData(dic: value as! Dictionary<String, Any>)
               self.myTableDataArray = model.data.kakuninData
               self.menuArray[num].ist201004 = "2"
               self.popTable.reloadData()
               self.menuCollection.reloadData()
            }else{
               let status = val["status"] as! Int
               if status == 401{
                  self.showTokenError()
                  return
               }
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
            print("aaaaaaa",error)
         }
      }
      
      self.menuCollection.reloadData()
      

    }
    @objc
    func backVTap(){
        self.popTable.removeFromSuperview()
        self.backView.removeFromSuperview()
    }
    @objc
    func nasiTap(){
        self.isNasi = !self.isNasi
//        if !self.isNasi{
//            menuArray = ["321","13","14","15","12","13","14","15","12","13","14","15","12","13"]
//        }else{
//            menuArray = ["","","","","","","","","","","","","",""]
//        }
        self.menuCollection.reloadData()
    }
    @objc func nasiTap(sender:UIButton){
      let num = sender.tag - 30000
      var flag = -1
      if self.menuArray[num].ist201002 == "1"{
         flag = 1
      }
      if self.menuArray[num].ist201002 == "2"{
         flag = 0
      }
      let dic = [ "ist107001": self.number,
                  "ist107002": self.subHeaderArray[self.subHeaderNum].ist207001,
                  "ist107003": self.subHeaderArray[self.subHeaderNum].ist207002,
                  "ist107004": self.subHeaderArray[self.subHeaderNum].ist207003,
                  "ist107005": self.subHeaderArray[self.subHeaderNum].ist207004,
                  "ist107006": self.subHeaderArray[self.subHeaderNum].ist207005,
                  "nasiFlag":flag] as [String : Any]
      let url = URL.init(string: helper().api+"issat/update/nasi/")
      print("dicdicdic",dic)
      let str = self.getJSONStringFromDictionary(dictionary: dic)
      let config = URLSessionConfiguration.default
      config.timeoutIntervalForRequest = 15
      alamofireManager = SessionManager(configuration: config)
      
      alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
         switch response.result {
         case.success(let value):
//            print("value",value)
            let val = value as! Dictionary<String,Any>
            if val["error"] == nil{
               let model = myMenuClass(dic: value as! Dictionary<String, Any>)
               self.menuArray = model.data.myZokuseiList
               if self.menuArray.count > 0{
                  self.menuCollection.isHidden = false
                  self.myPageControl.isHidden = false
               }
               self.menuCount = self.menuArray.count + 1
               while self.menuCount % 15 != 0{
                  self.menuCount+=1
               }
               self.myPageControl.numberOfPages = self.menuCount/15
                let index = IndexPath(item: self.HeaderNum, section: 0)
                let cell = self.NaviCollection.cellForItem(at: index) as! NaviCollectionViewCell
                cell.progress.setProgress(model.data.buibunruiDecisionRate, animated: true)
                
                let myIndex = IndexPath(item: self.subHeaderNum, section: 0)
                
                let myCell = self.subNaviCollection.cellForItem(at: myIndex) as! SubNaviCollectionViewCell
                
                self.headerArray[self.HeaderNum].decisionRate = model.data.buibunruiDecisionRate
                self.subHeaderArray[self.subHeaderNum].decisionRate = model.data.buiDecisionRate
                if model.data.buiDecisionRate == 1{
                    self.isPerFect = true
                }else{
                    self.isPerFect = false
                }
                if self.isPerFect{
                    self.imageView1.image = UIImage.init(named: "ic_insert_drive_file_36pt")
                    let url = URL(string: model.data.buibunruiIconUrl)
                    cell.header.sd_setImage(with: url, placeholderImage: nil)
                }else{
                    self.imageView1.image = UIImage.init(named: "")
                }
                if self.subHeaderArray[self.subHeaderNum].decisionRate == 1{
                    myCell.backgroundColor = UIColor(displayP3Red: 241/255.0, green: 249/255.0, blue:  254/255.0, alpha: 1.0)
                    
                }else
                {
                    myCell.backgroundColor = UIColor.clear
                }
                
               self.menuCollection.reloadData()
            }else{
               let status = val["status"] as! Int
               if status == 401{
                  self.showTokenError()
                  return
               }
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
            print("aaaaaaa",error)
         }
      }
   }
   @objc func susumeTap(sender:UIButton){
      let nu = sender.tag - 30000
      if self.menuArray[nu].ist201003 == "3"{
         return
      }
      self.pleasWaiting()
      let num = sender.tag - 30000
      var flag = -1
      if self.menuArray[num].ist201003 == "1"{
         flag = 1
      }
      if self.menuArray[num].ist201003 == "2"{
         flag = 0
      }
      let dic = [ "ist106001": self.number,
                  "ist106002": self.subHeaderArray[self.subHeaderNum].ist207001,
                  "ist106003": self.subHeaderArray[self.subHeaderNum].ist207002,
                  "ist106004": self.subHeaderArray[self.subHeaderNum].ist207003,
                  "ist106005": self.subHeaderArray[self.subHeaderNum].ist207004,
                  "ist106006": self.subHeaderArray[self.subHeaderNum].ist207005,
                  "ist106007": self.menuArray[0].ist201006,
                  "ist102008": self.menuArray[num].ist201007,
                  "ist106008": self.menuArray[num].ist201001,
                  "suishouhinFlag":flag] as [String : Any]
      //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
      //            print(json)
      //        }
      print("susumeTap",dic)
      let url = URL.init(string: helper().api+"issat/update/suishouhin/")
      let str = self.getJSONStringFromDictionary(dictionary: dic)
      let config = URLSessionConfiguration.default
      config.timeoutIntervalForRequest = 15
      alamofireManager = SessionManager(configuration: config)
      
      alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
         switch response.result {
         case.success(let value):
            self.clearAllNotice()
//            print("value",value)
                       let val = value as! Dictionary<String,Any>
            if val["error"] == nil{
               print("susumeTap",value)
               let model = myMenuClass(dic: value as! Dictionary<String, Any>)
               self.menuArray = model.data.myZokuseiList
               if self.menuArray.count > 0{
                  self.menuCollection.isHidden = false
                  self.myPageControl.isHidden = false
               }
               self.menuCount = self.menuArray.count
               while self.menuCount % 15 != 0{
                  self.menuCount+=1
               }
               self.myPageControl.numberOfPages = self.menuCount/15
               let index = IndexPath(item: self.HeaderNum, section: 0)
               let cell = self.NaviCollection.cellForItem(at: index) as! NaviCollectionViewCell
               cell.progress.setProgress(model.data.buibunruiDecisionRate, animated: true)
               
               let myIndex = IndexPath(item: self.subHeaderNum, section: 0)
               
               let myCell = self.subNaviCollection.cellForItem(at: myIndex) as! SubNaviCollectionViewCell
               
               self.headerArray[self.HeaderNum].decisionRate = model.data.buibunruiDecisionRate
               self.subHeaderArray[self.subHeaderNum].decisionRate = model.data.buiDecisionRate
               if model.data.buiDecisionRate == 1{
                  self.isPerFect = true
               }else{
                  self.isPerFect = false
               }
               if self.isPerFect{
                  self.imageView1.image = UIImage.init(named: "ic_insert_drive_file_36pt")
                  let url = URL(string: model.data.buibunruiIconUrl)
                  cell.header.sd_setImage(with: url, placeholderImage: nil)
               }else{
                  self.imageView1.image = UIImage.init(named: "")
               }
               if self.subHeaderArray[self.subHeaderNum].decisionRate == 1{
                  myCell.backgroundColor = UIColor(displayP3Red: 241/255.0, green: 249/255.0, blue:  254/255.0, alpha: 1.0)
                  
               }else
               {
                  myCell.backgroundColor = UIColor.clear
               }
               self.menuCollection.reloadData()
            }else{
               self.clearAllNotice()
               let status = val["status"] as! Int
               if status == 401{
                  self.showTokenError()
                  return
               }
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
        
        self.menuCollection.reloadData()
        
    }
    //test
    var isSusume = false
    var isTwo = false
    var isNasi = false
    var popTable : UITableView!
    var backView : UIView!
   
    @IBOutlet weak var test: OProgressView!
    @IBOutlet weak var NaviCollection: UICollectionView!
    @IBOutlet weak var subNaviCollection: UICollectionView!
    @IBOutlet weak var menuCollection: UICollectionView!
    
    @IBOutlet weak var myPageControl: UIPageControl!
    
//    @IBOutlet weak var writeImage: UIImageView!
    @IBOutlet weak var writeImage: UILabel!
    
    @IBOutlet weak var moneyImage: UIImageView!
    
    @IBOutlet weak var setImage: UILabel!
    
    @IBOutlet weak var secondLine: UIView!
    var subHeaderNum = -1
   var HeaderNum = -1

   var ist207001 = ""
   var ist207002 = ""
   var ist207003 = ""
   var ist207004 = ""
   var ist207005 = ""
   
   var ist201006 = ""
   var imageView1 = UIImageView()
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    func pleasWaiting(){
      var imagesArray = Array<UIImage>()
      for i in 0...21 {
         imagesArray.append(UIImage(named: "loading_\(i)")!)
      }
      self.pleaseWaitWithImages(imagesArray, timeInterval: 50)
   }
    var isBuiTap = false
    override func viewDidLoad() {
        super.viewDidLoad()
      self.setImage.isHidden = true
      self.writeImage.isHidden = true
      self.countLabel.isHidden = true
        if #available(iOS 11.0, *) {
            //高于 iOS 9.0
            self.topMargin.constant = 65

        }
        else {
         self.topMargin.constant = 0
         self.navigationController?.navigationBar.isTranslucent = false
//            self.topMargin.constant = 44
            //低于 iOS 9.0

        }
//      self.pleasWaiting()
//      UserDefaults.standard.set(TokenStr, forKey: "TokenStr")
//      UserDefaults.standard.set(custCoRStr, forKey: "custCoRStr")
//      UserDefaults.standard.set(custNStr, forKey: "custNStr")
      if let string :String = UserDefaults.standard.string(forKey: "TokenStr"){
         let a :String = UserDefaults.standard.string(forKey: "custCoRStr")!
         let b :String = UserDefaults.standard.string(forKey: "custNStr")!
         self.navigationItem.title = b
         header = MdUtils.getAuthHeader()
//         let alertController = UIAlertController(title: a, message: b, preferredStyle:  .alert)
//         let okAction = UIAlertAction(title: "はい", style: .default, handler: {
//            action in
//            print("点击了确定")
//         })
//         alertController.addAction(okAction)
//         self.present(alertController, animated: true, completion: nil)
      }
      
      
        let dict:NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font : UIFont.init(name: "HiraginoSans-W6", size: 28)]
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : AnyObject]
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        label.text = "< ICANVAS"
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.image = UIImage.init(named: "ic_description_36pt")
        imageView.isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.imageTap))
        imageView.addGestureRecognizer(imageTap)
        imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView1.image = UIImage.init(named: "")
        imageView1.isUserInteractionEnabled = true
        let moneyTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.moneyTap))
        imageView1.addGestureRecognizer(moneyTap)
        let rightBar = UIBarButtonItem(customView: imageView)
        let leftBar = UIBarButtonItem(customView: imageView1)
//        self.navigationItem.leftBarButtonItem = leftBar
      let string  = "Please Click Here"
      let range = (string as NSString).range(of: "Click", options: .caseInsensitive)
      let star = "\(range.upperBound)"
      print("star",star)
      let value = Int(star)!
      print("god", value)
      //        self.navigationItem.rightBarButtonItem = rightBar
        self.navigationItem.rightBarButtonItems = [rightBar,leftBar]
        // Do any additional setup after loading the view.
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        flow.itemSize = CGSize(width: 196, height: 92)
        self.NaviCollection.setCollectionViewLayout(flow, animated: true)
        self.NaviCollection.delegate = self
        self.NaviCollection.dataSource = self
        self.NaviCollection.register(UINib.init(nibName: "NaviCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collection")
        self.NaviCollection.showsHorizontalScrollIndicator = false
        let subflow = UICollectionViewFlowLayout()
        subflow.scrollDirection = .horizontal
        subflow.itemSize = CGSize(width: 196, height: 57)
        subflow.minimumInteritemSpacing = 0
        subflow.minimumLineSpacing = 0
        self.subNaviCollection.setCollectionViewLayout(subflow, animated: true)
        self.subNaviCollection.delegate = self
        self.subNaviCollection.dataSource = self
//        self.subNaviCollection.register(UINib.init(nibName: "SubNaviCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "subCollection")
        self.subNaviCollection.register(UINib.init(nibName: "SubNaviCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sub")
      
        self.subNaviCollection.showsHorizontalScrollIndicator = false
        
        let scrollLayout = LWLCollectionViewHorizontalLayout()
        scrollLayout.itemCountPerRow = 5
        scrollLayout.rowCount = 3
        scrollLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/5, height: 501/3)
//        scrollLayout.itemSize = CGSize(width: (UIScreen.main.bounds.size.height - 64-68-68-2-64)/3 , height: UIScreen.main.bounds.size.width/5 )


        scrollLayout.scrollDirection = .horizontal
        scrollLayout.minimumLineSpacing = 0
        scrollLayout.minimumInteritemSpacing = 0
//        scrollLayout.headerReferenceSize = CGSize(width: 0, height: 0)
        self.menuCollection.setCollectionViewLayout(scrollLayout, animated: true)
        self.menuCollection.delegate = self
        self.menuCollection.dataSource = self
        self.menuCollection.register(UINib.init(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menu")
      self.menuCollection.register(UINib.init(nibName: "plusButtonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "plus")
      self.menuCollection.register(UINib.init(nibName: "isSetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "set")


        self.menuCollection.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "me")
        self.menuCollection.isPagingEnabled = true
        self.myPageControl.numberOfPages = 2
        self.myPageControl.pageIndicatorTintColor = UIColor.gray
        self.myPageControl.currentPageIndicatorTintColor = UIColor.blue
        self.myPageControl.addTarget(self, action: #selector(pageChange), for: UIControlEvents.touchUpInside)
        self.setImage.layer.borderWidth = 1
        self.setImage.layer.borderColor = UIColor.black.cgColor
        self.setImage.layer.cornerRadius = 10
         self.setImage.layer.masksToBounds = true
      
        self.writeImage.layer.borderWidth = 1
        self.writeImage.layer.borderColor = UIColor.black.cgColor
        self.writeImage.layer.cornerRadius = 10
        self.writeImage.layer.masksToBounds = true
        
        self.setImage.isUserInteractionEnabled = true
        self.writeImage.isUserInteractionEnabled = true
        let setTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.setTap))
        self.setImage.addGestureRecognizer(setTap)
        let writeTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.writeTap))
        self.writeImage.addGestureRecognizer(writeTap)
        
        self.subNaviCollection.isHidden = true
        self.menuCollection.isHidden = true
        self.myPageControl.isHidden = true
        self.countLabel.layer.cornerRadius = 15
        self.countLabel.layer.masksToBounds = true
//        let moneyTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.moneyTap))
//        moneyImage.addGestureRecognizer(moneyTap)
        
         popTable = UITableView(frame: CGRect(x: UIScreen.main.bounds.size.width/2 - 200, y: 90, width: 400, height: 600))
        popTable.delegate = self
        popTable.dataSource = self
        popTable.register(UINib.init(nibName: "popHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "popHeader")
        popTable.register(UINib.init(nibName: "popTableViewCell", bundle: nil), forCellReuseIdentifier: "popTable")
      
        self.deleteLabel.isUserInteractionEnabled = true
        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(self.deleteTap))
        self.deleteLabel.addGestureRecognizer(deleteTap)
        
        self.deleteImage.isUserInteractionEnabled = true
        let deleteImageTap = UITapGestureRecognizer(target: self, action: #selector(self.deleteImageTap))
        self.deleteImage.addGestureRecognizer(deleteImageTap)
      if isFirst{
         self.getData()

      }
      else{
         self.showAlert()
      }
      self.deleteImage.isHidden = true
    }
    @objc
    func deleteTap(){
        self.menuSelectArray.removeAll()
        for _ in self.menuArray {
            self.menuSelectArray.append(false)
      }
      
        if isDeleting{
            self.deleteLabel.text = "編集"
             self.deleteLabel.textColor = UIColor(displayP3Red: 60/255.0, green: 130/255.0, blue: 255/255.0, alpha: 1)
         self.isDeleting = false
         self.deleteImage.isHidden = true
            
        }else{
   self.deleteLabel.text = "完了"
            self.deleteLabel.textColor = UIColor.lightGray
          self.isDeleting = true
         deleteImage.image = UIImage.init(named: "ic_delete_36pt_3x_gray")
         self.deleteImage.isHidden = false

        }
      self.menuCollection.reloadData()
    }
    @objc
    func deleteImageTap(){
     //
      var a = 0
      for value in self.menuSelectArray{
         if value{
            a += 1
         }
      }
      if a == 0{
         return
      }
      var i = 0
      var array = Array<Any>()
      
      for bool in self.menuSelectArray{
         if bool{
            let dic = [ "ist102001": self.number,
                        "ist102002": self.subHeaderArray[self.subHeaderNum].ist207001,
                        "ist102003": self.subHeaderArray[self.subHeaderNum].ist207002,
                        "ist102004": self.subHeaderArray[self.subHeaderNum].ist207003,
                        "ist102005": self.subHeaderArray[self.subHeaderNum].ist207004,
                        "ist102006": self.subHeaderArray[self.subHeaderNum].ist207005,
                        "ist102007": self.menuArray[i].ist201006,
                        "ist001001": self.menuArray[i].ist201001,
                        "ist102008": self.menuArray[i].ist201007,
                        ] as [String : Any]
            array.append(dic)
         }
         i += 1
      }
      let dic = ["deleteZokuseiList":array]
     
      let url = URL.init(string: helper().api+"issat/delete/tuikazokusei/")
      print("dicdicdic",array)
      let str = self.getJSONStringFromDictionary(dictionary: dic)
      let config = URLSessionConfiguration.default
      config.timeoutIntervalForRequest = 15
      alamofireManager = SessionManager(configuration: config)
      
      alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
         switch response.result {
         case.success(let value):
            //            print("value",value)
            let val = value as! Dictionary<String,Any>
            if val["error"] == nil{
               let model = myMenuClass(dic: value as! Dictionary<String, Any>)
               self.menuArray = model.data.myZokuseiList
               if self.menuArray.count > 0{
                  self.menuCollection.isHidden = false
                  self.myPageControl.isHidden = false
               }
               self.menuCount = self.menuArray.count + 1
               while self.menuCount % 15 != 0{
                  self.menuCount+=1
               }
               self.myPageControl.numberOfPages = self.menuCount/15
//               self.menuCollection.reloadData()
               self.deleteTap()
            }else{
               let status = val["status"] as! Int
               if status == 401{
                  self.showTokenError()
                  return
               }
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
            print("aaaaaaa",error)
         }
      }
      
        
    }
   var PdfName = ""
    @objc
    func moneyTap(){
      if !isPerFect{
         return
      }
      self.pleasWaiting()
      let dic = [ "ist102001": self.number,
                  "ist102002": self.ist207001,
                  "ist102003": self.ist207002,
                  "ist102004": self.ist207003,
                  "ist102005": self.ist207004,
                  "ist102006": self.ist207005,
                  "buibunruiName": self.headerArray[self.HeaderNum].ist206004,
                  "buiName": self.subHeaderArray[self.myindex.row].ist207006,
                  "fileName": "\(self.number)" + "_gaisan.pdf"
         ] as [String : Any]
      //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
      //            print(json)
      //        }
      print("moneyTap",dic)
      let url = URL.init(string: helper().api+"issat/report/siyou/")
//      let str = self.getJSONStringFromDictionary(dictionary: dic)
//      let config = URLSessionConfiguration.default
//      config.timeoutIntervalForRequest = 15
//      alamofireManager = SessionManager(configuration: config)
//
//      alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
//         switch response.result {
//         case.success(let value):
//            //            print("value",value)
//            let val = value as! Dictionary<String,Any>
//            if val["error"] == nil{
//               let model = myMenuClass(dic: value as! Dictionary<String, Any>)
//               self.menuArray = model.data.myZokuseiList
//               if self.menuArray.count > 0{
//                  self.menuCollection.isHidden = false
//                  self.myPageControl.isHidden = false
//               }
//               self.menuCount = self.menuArray.count
//               while self.menuCount % 15 != 0{
//                  self.menuCount+=1
//               }
//               self.myPageControl.numberOfPages = self.menuCount/15
//               self.menuCollection.reloadData()
//            }else{
//
//               let alertController = UIAlertController(title: "\(val["status"] ?? "error")",
//                  message: val["error"] as? String, preferredStyle: .alert)
//               let okAction = UIAlertAction(title: "はい", style: .default, handler: {
//                  action in
//                  print("点击了确定")
//               })
//               alertController.addAction(okAction)
//               self.present(alertController, animated: true, completion: nil)
//            }
//         case.failure(let error):
//            print("aaaaaaa",error)
//         }
//      }
      //
      let destination: DownloadRequest.DownloadFileDestination = { _, _ in
         let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
         let fileURL = documentsURL.appendingPathComponent("test.pdf")
         return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
      }
//      let remotePDFDocumentURLPath = helper().api + "issat/report_pdf/87705001/87705005/"
      
      alamofireManager?.download(url!, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: header, to: destination).response { (response) in
         if response.error == nil, let pdfPath = response.destinationURL?.path {
//            print("pdfPath::::\(pdfPath)")
            print("response",response)
            let url = URL(fileURLWithPath: pdfPath)
            let document = PDFDocument(url: url)
            self.clearAllNotice()
            self.PdfName =  "\(self.number)" + "_gaisan.pdf"
            if document == nil{
                  let alertController = UIAlertController(title: "帳票出力ができませんでした。", message: "", preferredStyle: .alert)
                  let okAction = UIAlertAction(title: "はい", style: .default, handler: {
                     action in
                  })
                  alertController.addAction(okAction)
                  self.present(alertController, animated: true, completion: nil)
               
            }else{
               self.showDocument(document!)
            }
         }
      }
    }

    @objc
    func imageTap(){
//        let insanelyLargePDFDocumentName = "99"
//        if let doc = document(insanelyLargePDFDocumentName) {
//            showDocument(doc)
//        } else {
//            print("Document named \(insanelyLargePDFDocumentName) not found in the file system")
//        }
      self.pleasWaiting()
      let dic = [ "ist102001": self.number,
                  "fileName": "\(self.number)" + "_setubi.pdf"
         ] as [String : Any]
      //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
      //            print(json)
      //        }
      print("imageTap",dic)
      let url = URL.init(string: helper().api+"issat/report/setsubi/")
      //      let str = self.getJSONStringFromDictionary(dictionary: dic)
      //      let config = URLSessionConfiguration.default
      //      config.timeoutIntervalForRequest = 15
      //      alamofireManager = SessionManager(configuration: config)
      //
      //      alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
      //         switch response.result {
      //         case.success(let value):
      //            //            print("value",value)
      //            let val = value as! Dictionary<String,Any>
      //            if val["error"] == nil{
      //               let model = myMenuClass(dic: value as! Dictionary<String, Any>)
      //               self.menuArray = model.data.myZokuseiList
      //               if self.menuArray.count > 0{
      //                  self.menuCollection.isHidden = false
      //                  self.myPageControl.isHidden = false
      //               }
      //               self.menuCount = self.menuArray.count
      //               while self.menuCount % 15 != 0{
      //                  self.menuCount+=1
      //               }
      //               self.myPageControl.numberOfPages = self.menuCount/15
      //               self.menuCollection.reloadData()
      //            }else{
      //
      //               let alertController = UIAlertController(title: "\(val["status"] ?? "error")",
      //                  message: val["error"] as? String, preferredStyle: .alert)
      //               let okAction = UIAlertAction(title: "はい", style: .default, handler: {
      //                  action in
      //                  print("点击了确定")
      //               })
      //               alertController.addAction(okAction)
      //               self.present(alertController, animated: true, completion: nil)
      //            }
      //         case.failure(let error):
      //            print("aaaaaaa",error)
      //         }
      //      }
      //
      let destination: DownloadRequest.DownloadFileDestination = { _, _ in
         let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
         let fileURL = documentsURL.appendingPathComponent("Image.pdf")
         return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
      }
      //      let remotePDFDocumentURLPath = helper().api + "issat/report_pdf/87705001/87705005/"
      
      alamofireManager?.download(url!, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: header, to: destination).response { (response) in
         if response.error == nil, let pdfPath = response.destinationURL?.path {
            print("pdfPath::::\(pdfPath)")
            let url = URL(fileURLWithPath: pdfPath)
            let document = PDFDocument(url: url)
            self.clearAllNotice()
            self.PdfName =  "\(self.number)" + "_setubi.pdf"
            self.showDocument(document!)
         }
         
      }
    }
   private func document(_ remoteURL: URL) -> PDFDocument? {
      return PDFDocument(url: remoteURL)
   }
    private func document(_ name: String) -> PDFDocument? {
        guard let documentURL = Bundle.main.url(forResource: name, withExtension: "") else { return nil }
     print("documentURL",documentURL)
      print("fuck",name)
      return PDFDocument(url: documentURL)
    }
   @objc func imageVtap(){
      let a :String = UserDefaults.standard.string(forKey: "custCoRStr") ?? ""

      let dic = [ "ist101014": a,
                  "fileName": self.PdfName
                  ] as [String : Any]
      //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
      //            print(json)
      //        }
      print("imageVtap",dic)
      let url = URL.init(string: helper().api+"issat/report/save/")
      let config = URLSessionConfiguration.default
      config.timeoutIntervalForRequest = 15
      alamofireManager = SessionManager(configuration: config)
      
      alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
         switch response.result {
         case.success(let value):
            print("confirm",value)
            let val = value as! Dictionary<String,Any>
            if val["error"] == nil{
               let alertController = UIAlertController(title: "",
                                                       message: "お客様BOXに保存しました。", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "はい", style: .default, handler: {
                  action in
                  print("点击了确定")
               })
               alertController.addAction(okAction)
               self.present(alertController, animated: true, completion: nil)
            }else{
               let status = val["status"] as! Int
               if status == 401{
                     self.showTokenError()
                  return
               }
               
               
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
            print("aaaaaaa",error)
         }
      }
   }
    private func showDocument(_ document: PDFDocument) {
        let image = UIImage(named: "ic_file_upload_36pt_3x")
      let imageV = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 90, height: 50))
      imageV.image = image
      imageV.contentMode = .scaleAspectFit
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        label.text = "< 戻る"
//      let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
//      label2.text = "fuckU"
        let leftBar = UIBarButtonItem(customView: label)
        label.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.pop))
        label.addGestureRecognizer(backTap)
      let imageTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.imageVtap))
      imageV.addGestureRecognizer(imageTap)
      let r = UIBarButtonItem(customView: imageV)

//      image.addGestureRecognizer(imageTap)
      
//         let controller = PDFViewController.createNew(with: document, title: "打ち合わせ記録", actionButtonImage: image, actionStyle: .activitySheet, backButton: leftBar)
      let controller = PDFViewController.createNew(with: document, title: "打ち合わせ記録", actionButtonImage: image, actionStyle: .activitySheet, backButton: leftBar, isThumbnailsEnabled: false, startPageIndex: 0, mybBackButton: imageV)
//        let controller = PDFViewController.createNew(with: document, title: "打ち合わせ記録", actionButtonImage: image, actionStyle: .activitySheet)
        navigationController?.pushViewController(controller, animated: true)
        let nv = self.navigationController as! CusViewController
        nv.surport = .all
        
        isSetPdf = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = true
    }
    var isSetPdf = false
   var isAdd = false
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if isSetPdf{
            return .all
        }else{
            return.landscape
        }
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeLeft
    }
   func showAlert(){
      let a :String = UserDefaults.standard.string(forKey: "custCoRStr") ?? ""
      if a == ""{
         let alertController = UIAlertController(title: "注意", message: "直接アプリを起動することは\nできません。\niCANVASよりログインし\n起動してください。", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "はい", style: .default, handler: {
            action in
            
            let url = URL(string:"SFCiCANVAS://?caller=MeetingRecords")
            UIApplication.shared.open(url!, options: [:]) { (bool) in
            }
         })
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
      }
   }
    override func viewWillAppear(_ animated: Bool) {
//      self.pleasWaiting()
        isSetPdf = false
      if self.hasDeleted{
         self.deleteLabel.isHidden = false
      }else{
         self.deleteLabel.isHidden = true
      }
   
        // to do delegate  
//        let nv = self.navigationController as! CusViewController
//        nv.interfaceOrientation = .UIInterfaceOrientationLandscapeLeft
//        nv.interfaceOrientation
//     UIDevice.current.setValue("UIInterfaceOrientationLandscapeRight", forKey: "orientation")
//     UIViewController.attemptRotationToDeviceOrientation()
        let nv = self.navigationController as! CusViewController
        nv.surport = .landscape
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.blockRotation = false
        let dict:NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font : UIFont.init(name: "HiraginoSans-W3", size: 18)]
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : AnyObject]
//        self.navigationItem.title = "OOOO様"
//      self.navigationItem.title = "ist101014"
        self.navigationController?.navigationBar.isHidden = false



    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
    UIApplication.shared.statusBarOrientation = .landscapeLeft
        // api
    }
     var alamofireManager : SessionManager?
    var number = 0
    var cojiNumber = ""
   var header = MdUtils.getAuthHeader()

    func getData(){
      self.pleasWaiting()
       let a :String = UserDefaults.standard.string(forKey: "custCoRStr") ?? ""
        let dic = ["ist101014":a]
 
      

      if a == ""{
         let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "はい", style: .default, handler: {
            action in
            print("点击了确定")
         })
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
      }
//        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
//            print(json)
//        }
        let url = URL.init(string:helper().api+"issat/select/buibunrui/")
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        alamofireManager = SessionManager(configuration: config)

        alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case.success(let value):
//               self.clearAllNotice()
               print("getData",value)
               let val = value as! Dictionary<String,Any>
               if val["error"] == nil{
                  let model = myClass(dic: value as! Dictionary<String, Any>)
                  self.headerArray = model.data.myBuibunruiList
                  for _ in self.headerArray{
                     self.selectArray.append(false)
                  }
                  self.NaviCollection.reloadData()
                  self.number = model.data.ist101001
                  self.cojiNumber = model.data.ist101016
                  
                  print("cojiNumebr",self.cojiNumber)
                  let index = IndexPath(item: 0, section: 0)
                  if  self.selectArray.count > 0{
                     self.selectArray[0] = true
                     self.getSubNaviData(Index: index)
                     
                  }
               }else{
                  self.clearAllNotice()
                  let status = val["status"] as! Int
                  if status == 401{
                     self.showTokenError()
                     return
                  }
               }
           
//
            case.failure(let error):
               self.clearAllNotice()
                print("aaaaaaa",error)
            }
        }
    }
   func showTokenError(){
      let alertController = UIAlertController(title: "認証情報の有効期限切れ、もしくは認証エラーです。\n iCANVASにて再度ログインし起動してください。",
         message:"", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "はい", style: .default, handler: {
         action in
         let url = URL(string:"SFCiCANVAS://?caller=MeetingRecords")
         UIApplication.shared.open(url!, options: [:]) { (bool) in
         }
      })
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
   }
    func getJSONStringFromDictionary(dictionary:Dictionary<String, Any>) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    func getSubNaviData(Index:IndexPath) {
//      self.pleasWaiting()
        let dic = [ "ist102001": self.number,
                    "ist102002": self.headerArray[Index.row].ist206001,
                    "ist102003": self.headerArray[Index.row].ist206002,
                    "ist102004": self.headerArray[Index.row].ist206003] as [String : Any]
        //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
        //            print(json)
        //        }
        let url = URL.init(string: helper().api+"issat/select/bui/")
        let str = self.getJSONStringFromDictionary(dictionary: dic)
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        alamofireManager = SessionManager(configuration: config)
        
        alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case.success(let value):
//               self.clearAllNotice()
               print("subValue",value)
               let val = value as! Dictionary<String,Any>
               if val["error"] == nil{
                  let model = mySubClass(dic: value as! Dictionary<String, Any>)
                  self.subHeaderArray = model.data.myBuiList
                  self.subSelectArray.removeAll()
                  for _ in self.subHeaderArray{
                     self.subSelectArray.append(false)
                  }
                  if self.subSelectArray.count > 0{
                     self.subNaviCollection.isHidden = false
                     self.secondLine.isHidden = false
                  }else{
                     self.subNaviCollection.isHidden = true
                     self.secondLine.isHidden = true
                  }
                  self.HeaderNum = Index.row
                  self.subNaviCollection.reloadData()
                  //               if self.isFirst{
                  let index = IndexPath(item: 0, section: 0)
                  self.getMenuData(Index: index)
                  self.subSelectArray[0] = true
                  //               }
               }else{
                  let status = val["status"] as! Int
                  if status == 401{
                     self.showTokenError()
                     return
                  }
               }
            
            case.failure(let error):
               self.clearAllNotice()
                print("aaaaaaa",error)
            }
        }
    }
    func getMenuData(Index:IndexPath) {
        let dic = [ "ist102001": self.number,
                    "ist102002": self.subHeaderArray[Index.row].ist207001,
                    "ist102003": self.subHeaderArray[Index.row].ist207002,
                    "ist102004": self.subHeaderArray[Index.row].ist207003,
                    "ist102005": self.subHeaderArray[Index.row].ist207004,
                    "ist102006": self.subHeaderArray[Index.row].ist207005,] as [String : Any]
       print("menuData",dic)
      self.pleasWaiting()
      
        //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
        //            print(json)
        //        }
        let url = URL.init(string: helper().api+"issat/select/zokusei/")
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        alamofireManager = SessionManager(configuration: config)
        
        alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                print("valuevalue",value)
                self.myindex = Index
                self.clearAllNotice()
                let val = value as! Dictionary<String,Any>
                if val["error"] == nil{
                    let model = myMenuClass(dic: value as! Dictionary<String, Any>)
                    self.menuArray = model.data.myZokuseiList
                    if self.menuArray.count > 0{
                        self.menuCollection.isHidden = false
                        self.myPageControl.isHidden = false
                    }
                    self.menuCount = self.menuArray.count + 1
                    while self.menuCount % 15 != 0{
                        self.menuCount+=1
                    }
                    self.myPageControl.numberOfPages = self.menuCount/15
                  self.ist207001 = self.subHeaderArray[Index.row].ist207001
                  self.ist207002 = self.subHeaderArray[Index.row].ist207002
                  self.ist207003 = self.subHeaderArray[Index.row].ist207003
                  self.ist207004 = self.subHeaderArray[Index.row].ist207004
                  self.ist207005 = self.subHeaderArray[Index.row].ist207005
                  if model.data.myZokuseiList.count > 0{
                     self.ist201006 =  model.data.myZokuseiList[0].ist201006
                  }
                  self.subHeaderNum = Index.row
                  self.unreadCount = model.data.ist201020
                  if self.unreadCount > 0{
                     self.countLabel.isHidden = false
                  }else{
                     self.countLabel.isHidden = true
                  }
                  if model.data.ist201021 == "0"{
                     self.isSetting = false
                  }else{
                     self.isSetting = true
                  }
                  if self.isSetting {
                     self.setImage.backgroundColor = UIColor(displayP3Red: 0/255.0, green: 112/255.0, blue: 192/255.0, alpha: 1.0)
                     self.setImage.textColor = UIColor.white
                     self.setImage.layer.borderWidth = 0
                  }else{
                     self.setImage.backgroundColor = UIColor.white
                     self.setImage.textColor = UIColor.black
                     self.setImage.layer.borderWidth = 1

                  }

                  if model.data.buiDecisionRate == 1{
                     self.isPerFect = true
                  }else{
                     self.isPerFect = false
                  }
                  if self.isPerFect{
                     self.imageView1.image = UIImage.init(named: "ic_insert_drive_file_36pt")
                  }else{
                     self.imageView1.image = UIImage.init(named: "")
                  }
                  self.hasDeleted = false
                  for value in self.menuArray{
                     if  value.ist201018 == "0"{
                        self.hasDeleted = true
                     }
                  }
                  if self.hasDeleted{
                     self.deleteLabel.isHidden = false
                  }else{
                     self.deleteLabel.isHidden = true
                  }
                  
                  self.countLabel.text = "\(self.unreadCount)"
                  if self.isFirst{
                     self.isFirst = false
                     self.subSelectArray[0] = true
                  }
                  // delegate
                  if self.isMessageDelegate{
                     let index = IndexPath(item: self.HeaderNum, section: 0)
                     let cell = self.NaviCollection.cellForItem(at: index) as! NaviCollectionViewCell
                     cell.progress.setProgress(model.data.buibunruiDecisionRate, animated: true)
                     
                     let myIndex = IndexPath(item: self.subHeaderNum, section: 0)
                     
                     let myCell = self.subNaviCollection.cellForItem(at: myIndex) as! SubNaviCollectionViewCell
                     
                     self.headerArray[self.HeaderNum].decisionRate = model.data.buibunruiDecisionRate
                     self.subHeaderArray[self.subHeaderNum].decisionRate = model.data.buiDecisionRate
                     if model.data.buiDecisionRate == 1{
                        self.isPerFect = true
                     }else{
                        self.isPerFect = false
                     }
                     if self.isPerFect{
                        self.imageView1.image = UIImage.init(named: "ic_insert_drive_file_36pt")
                        let url = URL(string: model.data.buibunruiIconUrl)
                        cell.header.sd_setImage(with: url, placeholderImage: nil)
                     }else{
                        self.imageView1.image = UIImage.init(named: "")
                     }
                     if self.subHeaderArray[self.subHeaderNum].decisionRate == 1{
                        myCell.backgroundColor = UIColor(displayP3Red: 241/255.0, green: 249/255.0, blue:  254/255.0, alpha: 1.0)
                        
                     }else
                     {
                        myCell.backgroundColor = UIColor.clear
                     }
                     self.isDelegate = false
                  }
                    self.menuCollection.reloadData()
                  self.setImage.isHidden = false
                  self.writeImage.isHidden = false
                  self.menuCollection.isHidden = false
                  
                }else{
                  let status = val["status"] as! Int
                  if status == 401{
                     self.showTokenError()
                     return
                  }
                    let alertController = UIAlertController(title: "\(val["status"] ?? "error")",
                                                            message: val["message"] as? String, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "はい", style: .default, handler: {
                        action in
                        print("点击了确定")
                    })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                print("self.menuArray",self.menuArray.count)
             
            
            case.failure(let error):
               self.clearAllNotice()
                print("aaaaaaa",error)
            }
        }
    }
  
   func getDetailData(num:Int){
      var a = num
      if a == 0 {
         a = 1
      }else{
         a = 0
      }
      // add
      if isAdd{
         a = 0
      }
      let VC = SelectViewController()
      VC.ist102001 = self.number
      VC.ist102002 = self.ist207001
      VC.ist102003 = self.ist207002
      VC.ist102004 = self.ist207003
      VC.ist102005 = self.ist207004
      VC.ist102006 = self.ist207005
      VC.ist101016 = self.cojiNumber
      VC.ist201006 = self.menuArray[0].ist201006
      VC.ist201001 = self.menuArray[num].ist201001
      VC.ist201019 = a
      VC.ist201007 = self.menuArray[num].ist201007
      if isAdd{
         VC.ist201001 = self.tableDataArray[num - 1].ist202001
         VC.tuikazokuseiFlag = "1"
      }else{
         VC.tuikazokuseiFlag = "0"
      }
      if a == 1{
         VC.isSosyo = true
      }
      VC.myDelegate = self
      self.soushouCodeBefore = self.menuArray[num].ist201006
      self.meisaiCodeBefore = self.menuArray[num].ist201007
      self.navigationController?.pushViewController(VC, animated: true)
//      self.indexNum = num
//      let dic = ["ist101016":self.cojiNumber,
//                 "ist201006":self.menuArray[num].ist201006,
//                 "ist201001":self.menuArray[num].ist201001,
//                 "ist201019":a] as [String : Any]
//      print("dic",dic)
//        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
//            print(json)
//        }
//      let url = URL.init(string:helper().api+"webapi/select/zokuseiti/")
//      let config = URLSessionConfiguration.default
//      config.timeoutIntervalForRequest = 15
//      alamofireManager = SessionManager(configuration: config)
//
//      alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
//         switch response.result {
//         case.success(let value):
//            let val = value as! Dictionary<String,Any>
//            if val["error"] == nil{
//               print(value)
//            }else{
//
//               let alertController = UIAlertController(title: "\(val["status"] ?? "error")",
//                  message: val["error"] as? String, preferredStyle: .alert)
//               let okAction = UIAlertAction(title: "はい", style: .default, handler: {
//                  action in
//                  print("点击了确定")
//               })
//               alertController.addAction(okAction)
//               self.present(alertController, animated: true, completion: nil)
//            }
//         case.failure(let error):
//            print("aaaaaaa",error)
//         }
//      }
   }
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc
    func writeTap(){
        let MessageVC = MessageViewController()
         MessageVC.myDelegate = self
         MessageVC.ist103001 = self.number
         MessageVC.ist103002 = self.subHeaderArray[self.subHeaderNum].ist207001
         MessageVC.ist103003 = self.subHeaderArray[self.subHeaderNum].ist207002
         MessageVC.ist103004 = self.subHeaderArray[self.subHeaderNum].ist207003
         MessageVC.ist103005 = self.subHeaderArray[self.subHeaderNum].ist207004
         MessageVC.ist103006 = self.subHeaderArray[self.subHeaderNum].ist207005
         MessageVC.ist103007 = self.menuArray[num].ist201006

        self.navigationController?.pushViewController(MessageVC, animated: true)
    }
    @objc
    func setTap(){
      
      if !isSetting{
         let alertController = UIAlertController(title: "設定外品指定すると、現在選択している部材・色柄がリセットされます。よろしいですか？",
                                                 message: "", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "設定外品にする", style: .default, handler: {
            action in
            
            let MessageVC = MessageViewController()
            MessageVC.myDelegate = self
            MessageVC.str = "isSet"
            MessageVC.ist103001 = self.number
            MessageVC.ist103002 = self.subHeaderArray[self.subHeaderNum].ist207001
            MessageVC.ist103003 = self.subHeaderArray[self.subHeaderNum].ist207002
            MessageVC.ist103004 = self.subHeaderArray[self.subHeaderNum].ist207003
            MessageVC.ist103005 = self.subHeaderArray[self.subHeaderNum].ist207004
            MessageVC.ist103006 = self.subHeaderArray[self.subHeaderNum].ist207005
            MessageVC.ist103007 = self.menuArray[self.num].ist201006
            self.navigationController?.pushViewController(MessageVC, animated: true)
            
         })
         let cancelAction = UIAlertAction(title: "キャンセル", style: .default, handler: {
            action in
            print("点击了确定")
         })
         alertController.addAction(okAction)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
        
      }else{
         let dic = ["ist103001":self.number,
                    "ist103002":self.subHeaderArray[self.subHeaderNum].ist207001,
                    "ist103003":self.subHeaderArray[self.subHeaderNum].ist207002,
                    "ist103004":self.subHeaderArray[self.subHeaderNum].ist207004,
                    "ist103005":self.subHeaderArray[self.subHeaderNum].ist207003,
                    "ist103006":self.subHeaderArray[self.subHeaderNum].ist207005,
                    "ist102007":self.ist201006,
                    "setteigaiFlag":1,
                    "keijouTyukiUpdateList":[]
            ] as [String : Any]
         self.pleasWaiting()
         
         print("xxxxx",dic)
         //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
         //            print(json)
         //        }
         let url = URL.init(string:helper().api+"issat/update/tyuki/")
         let config = URLSessionConfiguration.default
         config.timeoutIntervalForRequest = 15
         self.alamofireManager = SessionManager(configuration: config)
         self.alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: self.header).responseJSON { (response) in
            switch response.result {
            case.success(let value):
               self.clearAllNotice()
               let val = value as! Dictionary<String,Any>
               
               if val["error"] == nil{
                  let model = myMenuClass(dic: value as! Dictionary<String, Any>)
                  self.menuArray = model.data.myZokuseiList
                  if self.menuArray.count > 0{
                     self.menuCollection.isHidden = false
                     self.myPageControl.isHidden = false
                  }
                  self.menuCount = self.menuArray.count + 1
                  while self.menuCount % 15 != 0{
                     self.menuCount+=1
                  }
                  self.myPageControl.numberOfPages = self.menuCount/15
                  //                  self.ist207001 = self.subHeaderArray[Index.row].ist207001
                  //                  self.ist207002 = self.subHeaderArray[Index.row].ist207002
                  //                  self.ist207003 = self.subHeaderArray[Index.row].ist207003
                  //                  self.ist207004 = self.subHeaderArray[Index.row].ist207004
                  //                  self.ist207005 = self.subHeaderArray[Index.row].ist207005
                  //                  self.subHeaderNum = Index.row
                  self.unreadCount = model.data.ist201020
                  if self.unreadCount > 0{
                     self.countLabel.isHidden = false
                  }else{
                     self.countLabel.isHidden = true
                  }
                  if model.data.ist201021 == "0"{
                     self.isSetting = false
                  }else{
                     self.isSetting = true
                  }
                  if self.isSetting {
                     self.setImage.backgroundColor = UIColor(displayP3Red: 0/255.0, green: 112/255.0, blue: 192/255.0, alpha: 1.0)
                     self.setImage.textColor = UIColor.white
                     self.setImage.layer.borderWidth = 0
                  }else{
                     self.setImage.backgroundColor = UIColor.white
                     self.setImage.textColor = UIColor.black
                     self.setImage.layer.borderWidth = 1
                     
                  }
                  let index = IndexPath(item: self.HeaderNum, section: 0)
                  let cell = self.NaviCollection.cellForItem(at: index) as! NaviCollectionViewCell
                  cell.progress.setProgress(model.data.buibunruiDecisionRate, animated: true)
                  
                  let myIndex = IndexPath(item: self.subHeaderNum, section: 0)
                  
                  let myCell = self.subNaviCollection.cellForItem(at: myIndex) as! SubNaviCollectionViewCell
                  
                  self.headerArray[self.HeaderNum].decisionRate = model.data.buibunruiDecisionRate
                  self.subHeaderArray[self.subHeaderNum].decisionRate = model.data.buiDecisionRate
                  if model.data.buiDecisionRate == 1{
                     self.isPerFect = true
                  }else{
                     self.isPerFect = false
                  }
                  if self.isPerFect{
                     self.imageView1.image = UIImage.init(named: "ic_insert_drive_file_36pt")
                     let url = URL(string: model.data.buibunruiIconUrl)
                     cell.header.sd_setImage(with: url, placeholderImage: nil)
                  }else{
                     self.imageView1.image = UIImage.init(named: "")
                  }
                  if self.subHeaderArray[self.subHeaderNum].decisionRate == 1{
                     myCell.backgroundColor = UIColor(displayP3Red: 241/255.0, green: 249/255.0, blue:  254/255.0, alpha: 1.0)
                     
                  }else
                  {
                     myCell.backgroundColor = UIColor.clear
                  }
                  
                  
                  self.countLabel.text = "\(self.unreadCount)"
                  self.menuCollection.reloadData()
                  self.setImage.isHidden = false
                  self.writeImage.isHidden = false
                  self.menuCollection.isHidden = false
                  
               }else{
                  let status = val["status"] as! Int
                  if status == 401{
                     self.showTokenError()
                     return
                  }
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
      
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if isDeleting{
         return
      }
      
        if collectionView.tag == 1002{
         if indexPath.row > self.menuArray.count{
            return
         }
         if indexPath.row == self.menuArray.count{
            self.plus()
            return
         }
         if self.menuArray[indexPath.row].ist201002 == "2"{
            return
         }
         if self.menuArray[indexPath.row].ist201003 == "2"{
            return
         }
         if self.menuArray[indexPath.row].ist201003 == "3"{
            return
         }
         if isSetting {
            return
         }

         isAdd = false
               self.getDetailData(num:indexPath.row)
      
//            else if indexPath.row == 1{
//                let VC = SelectViewController()
//                VC.str = "collor"
//                self.navigationController?.pushViewController(VC, animated: true)
//            }
//            else if indexPath.row == 28{
//                if HaveBeenDone{
//                    return
//                }
//                self.doSomeSth()
//            }
         
         
        }else if collectionView.tag == 1000{
//            let ite = collectionView.cellForItem(at: indexPath) as! NaviCollectionViewCell
//            ite.sele.isHidden = false
//            self.subNaviCollection.isHidden = false
//            self.secondLine.isHidden = false
//            if indexPath.row != 0{
//                let myindex = IndexPath(row: 0, section: 0)
//                let myite = collectionView.cellForItem(at: myindex) as! NaviCollectionViewCell
//                myite.sele.isHidden = true
//            }
         self.setImage.isHidden = true
         self.writeImage.isHidden = true
         self.countLabel.isHidden = true
         self.menuCollection.isHidden = true
         imageView1.image = UIImage.init(named: "")
            self.NaviCollection.reloadData()
            self.selectArray.removeAll()
            for _ in self.headerArray{
                self.selectArray.append(false)
            }
            self.selectArray[indexPath.row] = true
            self.getSubNaviData(Index: indexPath)
            if indexPath.row != lastNum{
                self.menuArray.removeAll()
                self.menuCollection.reloadData()
                subSelectArray.removeAll()
                for _ in self.subHeaderArray{
                    self.subSelectArray.append(false)
                }
                self.subNaviCollection.reloadData()
                lastNum = indexPath.row
            }

        }else if collectionView.tag == 1001{
//            let ite = collectionView.cellForItem(at: indexPath) as! SubNaviCollectionViewCell
//            ite.sele.isHidden = false
//            self.menuCollection.isHidden = false
//            myPageControl.isHidden = false
//            if indexPath.row == 0{
//                if !HaveBeenDone{
//                    if isSusume{
//                        menuArray = ["321","13","14","15","","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","ic_add_box_36pt"]
//                    }else{
//                        menuArray = ["321","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","ic_add_box_36pt"]
//                    }
//                }else{
//                    if isSusume{
//                        menuArray = ["321","13","14","15","","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","77777","ic_add_box_36pt"]
//                    }else{
//                        menuArray = ["321","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","12","13","14","15","77777","ic_add_box_36pt"]
//                    }
//                }
//
//                self.myPageControl.numberOfPages = 2
//           isTwo = false
//            }else if indexPath.item == 1{
//                if isNasi{
//                    menuArray = ["","","","","","","","","","","","","",""]
//
//                }else{
//                    menuArray = ["321","13","14","15","12","13","14","15","12","13","14","15","12","13"]
//                }
//                self.myPageControl.numberOfPages = 1
//                isTwo = true
//            }
            subSelectArray.removeAll()
            for _ in self.subHeaderArray{
                self.subSelectArray.append(false)
            }
            self.subSelectArray[indexPath.row] = true
            self.subNaviCollection.reloadData()
            // to do net
            self.getMenuData(Index: indexPath)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.isDelegate = false
        if collectionView.tag == 1002{
            
        }else if collectionView.tag == 1000{
//            let ite = collectionView.cellForItem(at: indexPath) as! NaviCollectionViewCell
//            ite.sele.isHidden = true
          
        }else if collectionView.tag == 1001{
//            let ite = collectionView.cellForItem(at: indexPath) as! SubNaviCollectionViewCell
//            ite.sele.isHidden = true
        }
    }
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
         self.myPageControl.currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
      
   }
    func doSomeSth(){
        self.popTable.reloadData()
        backView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.3
        backView.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backVTap))
        backView.addGestureRecognizer(backTap)
        self.view.addSubview(backView)
        self.view.addSubview(self.popTable)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc
    func pageChange(pageControl:UIPageControl){
        
        self.menuCollection.contentOffset = CGPoint(x: self.menuCollection.frame.size.width*CGFloat(pageControl.currentPage), y: 0)
    }
   func plus(){
      self.pleasWaiting()
      let dic = [ "ist102001": self.number,
                  "ist102002": self.subHeaderArray[self.subHeaderNum].ist207001,
                  "ist102003": self.subHeaderArray[self.subHeaderNum].ist207002,
                  "ist102004": self.subHeaderArray[self.subHeaderNum].ist207003,
                  "ist102005": self.subHeaderArray[self.subHeaderNum].ist207004,
                  "ist102006": self.subHeaderArray[self.subHeaderNum].ist207005,
                  "ist102007": self.menuArray[num].ist201006,
                  ] as [String : Any]
      //        Alamofire.request("172.16.20.51:7001/webapi/select/buibunrui", method:HTTPMethod.get, parameters: dic, encoding:.json, headers: nil).responseJSON { (json) in
      //            print(json)
      //        }
      print("susumeTap",dic)
      let url = URL.init(string: helper().api+"issat/select/tuikazokusei/")
      let str = self.getJSONStringFromDictionary(dictionary: dic)
      let config = URLSessionConfiguration.default
      config.timeoutIntervalForRequest = 15
      alamofireManager = SessionManager(configuration: config)
      
      alamofireManager?.request(url!, method:.post, parameters: dic, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
         switch response.result {
         case.success(let value):
            self.clearAllNotice()
                        print("value",value)
            let val = value as! Dictionary<String,Any>
            if val["error"] == nil{
               let model = addData(dic: val)
               self.tableDataArray = model.data.addListData
               self.isAdd = true
               self.doSomeSth()
            }else{
               if let a = val["status"] {
                  let b = a as! Int
                  if b == 200{
                     let alertController = UIAlertController(title: "",
                        message: val["message"] as? String, preferredStyle: .alert)
                     let okAction = UIAlertAction(title: "はい", style: .default, handler: {
                        action in
                        print("")
                     })
                     alertController.addAction(okAction)
                     self.present(alertController, animated: true, completion: nil)
                  }
               }
               let status = val["status"] as! Int
               if status == 401{
                  self.showTokenError()
                  return
               }
               let alertController = UIAlertController(title: "\(val["status"] ?? "error")",
                  message: val["message"] as? String, preferredStyle: .alert)
               let okAction = UIAlertAction(title: "はい", style: .default, handler: {
                  action in
                  print("")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
