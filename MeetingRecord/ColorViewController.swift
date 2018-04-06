//
//  ColorViewController.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/19.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit
import Alamofire
protocol selectColorDelegate{
    func delegateToChangeTheImage(Url:String,name:String,code:String)
}
class ColorViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    @IBOutlet weak var collection: UICollectionView!
    
    
    @IBOutlet weak var myPageControl: UIPageControl!
    var irogaraListData = Array<iroData>()
    var collectionCount = 0
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < self.irogaraListData.count {
            let cell = self.collection.dequeueReusableCell(withReuseIdentifier: "menu", for: indexPath) as! ColorCollectionViewCell
            cell.myNameLabel.text = self.irogaraListData[indexPath.row].ist209005
            let url = URL(string: self.irogaraListData[indexPath.row].imageUrl)
            cell.myImageView.sd_setImage(with: url, placeholderImage: nil)
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor(displayP3Red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1).cgColor
            return cell
        }else{
            let cell = self.collection.dequeueReusableCell(withReuseIdentifier: "me", for: indexPath)
            return cell
            
        }
  
//        if indexPath.row % 5 == 0{
//            cell.myImageView.backgroundColor = UIColor.yellow
//
//        }else if  indexPath.row % 5 == 1{
//            cell.myImageView.backgroundColor = UIColor.blue
//
//        }else if  indexPath.row % 5 == 2{
//            cell.myImageView.backgroundColor = UIColor.red
//
//        }else if  indexPath.row % 5 == 3{
//            cell.myImageView.backgroundColor = UIColor.cyan
//        }else if  indexPath.row % 5 == 4{
//            cell.myImageView.backgroundColor = UIColor.green
//        }
//        cell.myImageView.image = UIImage.init(named: self.menuArray[indexPath.row])
        
    }
    var myTitle: String!
    var returnText: String!
    var myDelegate:selectColorDelegate!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.myTitle
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        let dict:NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font : UIFont.init(name: "HiraginoSans-W3", size: 16)]
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : AnyObject]
        label.font = UIFont.init(name: "HiraginoSans-W3", size: 16)
        label.text = "< " + self.returnText
        let leftBar = UIBarButtonItem(customView: label)
        self.navigationItem.leftBarButtonItem = leftBar
        label.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(ColorViewController.pop))
        label.addGestureRecognizer(backTap)

        let scrollLayout = LWLCollectionViewHorizontalLayout()
        scrollLayout.itemCountPerRow = 4
        scrollLayout.rowCount = 3
        scrollLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4, height: 640/3)
        print("czsize",UIScreen.main.bounds.size.width/4)
        //        scrollLayout.itemSize = CGSize(width: (UIScreen.main.bounds.size.height - 64-68-68-2-64)/3 , height: UIScreen.main.bounds.size.width/5 )
        scrollLayout.scrollDirection = .horizontal
        scrollLayout.minimumLineSpacing = 0
        scrollLayout.minimumInteritemSpacing = 0
  
        self.collection.setCollectionViewLayout(scrollLayout, animated: true)
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.isPagingEnabled = true
        self.collection.register(UINib.init(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menu")
        self.collection.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "me")

        self.collection.showsHorizontalScrollIndicator = false
        // Do any additional setup after loading the view.
        print("hight",self.collection.frame.size.height)
        self.myPageControl.numberOfPages = 0
        self.myPageControl.pageIndicatorTintColor = UIColor.gray
        self.myPageControl.currentPageIndicatorTintColor = UIColor.blue
        self.myPageControl.addTarget(self, action: #selector(pageChange), for: UIControlEvents.touchUpInside)
        self.getData()
    }
    var alamofireManager : SessionManager?
    var ist209001 = ""
    var ist209002 = ""
    var ist204023 = ""
    func pleasWaiting(){
        var imagesArray = Array<UIImage>()
        for i in 0...21 {
            imagesArray.append(UIImage(named: "loading_\(i)")!)
        }
        self.pleaseWaitWithImages(imagesArray, timeInterval: 50)
    }

    func getData(){
        let dic = [ "ist209001": self.ist209001,
                    "ist209002": self.ist209002,
             "ist204023": self.ist204023] as [String : Any]
        self.pleasWaiting()
        let url = URL.init(string: helper().api+"issat/select/irogara/")
        print("dic",dic)
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
                    let data = iroGaraData(dic: val)
                    self.irogaraListData = data.data.irogaraListData
                    self.collectionCount = self.irogaraListData.count
                    self.myPageControl.numberOfPages = self.irogaraListData.count/12
                    while self.collectionCount % 12 != 0{
                        self.collectionCount+=1
                    }
                     self.myPageControl.isHidden = false
                    self.collection.reloadData()
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
    let header = MdUtils.getAuthHeader()
    @objc
    func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc
    func pageChange(pageControl:UIPageControl){
        self.collection.contentOffset = CGPoint(x: self.collection.frame.size.width*CGFloat(pageControl.currentPage), y: 0)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            self.myPageControl.currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.irogaraListData.count {
            self.myDelegate.delegateToChangeTheImage(Url: irogaraListData[indexPath.row].imageUrl, name: irogaraListData[indexPath.row].ist209005, code: irogaraListData[indexPath.row].ist209003)
            self.navigationController?.popViewController(animated: true)
        }else{
            return
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
