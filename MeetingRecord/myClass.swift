//
//  myClass.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/16.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit
@objc
class myClass: NSObject {
    //    var name = ""
    //    var time = ""
    //    var status = ""
    //    var onOff = true
    //    var image = ""
    var data:myData!
    init(dic:Dictionary<String, Any>){
        super.init()
        //        self.vvv.setValuesForKeys(dic)
        self.data = myData(dic: dic)
        print("self.data",self.data)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class myData: NSObject {
    @objc var buibunruiList = Array<Any>()
    @objc var myBuibunruiList = Array<buibunruiData>()
    @objc var ist101001 = 0
    @objc var ist101016 = ""
    
    init(dic:Dictionary<String, Any>){
        super.init()
        //                self.setValuesForKeys(dic)
        //        self.name = dic["name"] as! String
        setValuesForKeys(dic)
                for data in self.buibunruiList{
                    let dat = buibunruiData(dic: data as! Dictionary<String, Any>)
                    self.myBuibunruiList.append(dat)
                }
        print("list",ist101001)
        print("list",ist101016)
        print("list",buibunruiList)
        
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class buibunruiData: NSObject {
   @objc var decisionRate = 0
   @objc var imageUrl = ""
   @objc var ist206001 = ""
   @objc var ist206002 = ""
   @objc var ist206003 = ""
   @objc var ist206004 = ""
    init(dic:Dictionary<String, Any>){
        super.init()
        //                self.setValuesForKeys(dic)
        //        self.name = dic["name"] as! String
        setValuesForKeys(dic)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class mySubClass: NSObject {
    //    var name = ""
    //    var time = ""
    //    var status = ""
    //    var onOff = true
    //    var image = ""
    var data:mySubData!
    init(dic:Dictionary<String, Any>){
        super.init()
        //        self.vvv.setValuesForKeys(dic)
        self.data = mySubData(dic: dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class mySubData: NSObject {

    @objc var buiList:Array<Any>!
    @objc var myBuiList = Array<buiData>()
    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        for data in self.buiList{
            let dat = buiData(dic: data as! Dictionary<String, Any>)
            self.myBuiList.append(dat)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class buiData: NSObject {
    @objc var decisionRate = 0
    @objc var ist207001 = ""
    @objc var ist207002 = ""
    @objc var ist207003 = ""
    @objc var ist207004 = ""
    @objc var ist207005 = ""
    @objc var ist207006 = ""

    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class myMenuClass: NSObject {
    //    var name = ""
    //    var time = ""
    //    var status = ""
    //    var onOff = true
    //    var image = ""
    var data:myMenuData!
    init(dic:Dictionary<String, Any>){
        super.init()
        //        self.vvv.setValuesForKeys(dic)
        self.data = myMenuData(dic: dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class myMenuData: NSObject {
    @objc var ist201020 = 0
    @objc var ist201021 = ""
    @objc var buibunruiDecisionRate = 0
    @objc var buiDecisionRate = 0
    @objc var buibunruiIconUrl = ""
    @objc var zokuseiList:Array<Any>?
    @objc var myZokuseiList = Array<zukuseiData>()
    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        if (self.zokuseiList != nil){
            for data in self.zokuseiList!{
                let dat = zukuseiData(dic: data as! Dictionary<String, Any>)
                self.myZokuseiList.append(dat)
            }
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class zukuseiData: NSObject {
    @objc var imageUrl = ""
    @objc var ist201001 = ""
    @objc var ist201002 = ""
    @objc var ist201003 = ""
    @objc var ist201004 = ""
    @objc var ist201005 = ""
    @objc var ist201006 = ""
    @objc var ist201007 = ""
    @objc var ist201008 = ""
    @objc var ist201017 = ""
    @objc var ist201018 = ""
    @objc var ist201019 = ""
    @objc var nameAbove = ""
    @objc var nameBelow = ""

    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class zokuseSelectData: NSObject {

    @objc var data:zokuseSelectListData!
    
    init(dic:Dictionary<String, Any>){
        super.init()
//        setValuesForKeys(dic)
        self.data = zokuseSelectListData(dic: dic)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class zokuseSelectListData: NSObject {
    @objc var zokuseitiList:Array<Any>!
    @objc var ist001002 = ""
    @objc var zokuseitiDataList = Array<zokuseiItitData>()

    
    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        for data in self.zokuseitiList{
            let dat = zokuseiItitData(dic: data as! Dictionary<String, Any>)
            self.zokuseitiDataList.append(dat)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class zokuseiItitData: NSObject {
    @objc var ist203001 = ""
    @objc var ist203002 = ""
    @objc var buzaiList:Array<Any>!
    @objc var buzaiDataList = Array<buzaiData>()

    
    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        for data in self.buzaiList{
            let dat = buzaiData(dic: data as! Dictionary<String, Any>)
            self.buzaiDataList.append(dat)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class buzaiData: NSObject {
    
    @objc var buzaiCode = ""
    @objc var buzaiName = ""
    @objc var descriptionAbove = ""
    @objc var descriptionBelow = ""
    @objc var descriptionRight = ""
    @objc var ist204001 = ""
    @objc var ist204002 = ""
    @objc var ist204010 = ""
    @objc var ist204011 = 0
    @objc var ist204012 = 0.0
    @objc var imageUrl = ""
    @objc var ist204013 = ""
    @objc var ist204014 = ""
    @objc var ist204015 = ""
    @objc var ist204023 = ""
    @objc var flag = false
    @objc var irogaraCode = ""

    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class iroGaraData: NSObject {
    
    @objc var data:irogaraListData!
    
    init(dic:Dictionary<String, Any>){
        super.init()
        //        setValuesForKeys(dic)
        self.data = irogaraListData(dic: dic)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class irogaraListData: NSObject {
    
    @objc var irogaraList:Array<Any>!
    @objc var irogaraListData = Array<iroData>()
    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        for data in self.irogaraList{
            let dat = iroData(dic: data as! Dictionary<String, Any>)
            self.irogaraListData.append(dat)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class iroData: NSObject {

    @objc var ist209003 = ""
    @objc var ist209005 = ""
    @objc var imageUrl = ""
    
    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class addData: NSObject {
    
    @objc var data:addListData!
    
    init(dic:Dictionary<String, Any>){
        super.init()
        //        setValuesForKeys(dic)
        self.data = addListData(dic: dic)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class addListData: NSObject {
    
    @objc var buiList = Array<Any>()
    @objc var addListData = Array<ListData>()
    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        
        for data in self.buiList{
            let dat = ListData(dic: data as! Dictionary<String, Any>)
            self.addListData.append(dat)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class ListData: NSObject {
    
    @objc var ist202001 = ""
    @objc var ist202002 = ""
    
    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

@objc
class confirmData: NSObject {
    
    @objc var data:confirmListData!
    
    init(dic:Dictionary<String, Any>){
        super.init()
        //        setValuesForKeys(dic)
        self.data = confirmListData(dic: dic)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class confirmListData: NSObject {
    
    @objc var kakuninList:Array<Any>!
    @objc var kakuninData = Array<myConfirmData>()
    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        for data in self.kakuninList{
            let dat = myConfirmData(dic: data as! Dictionary<String, Any>)
            self.kakuninData.append(dat)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
@objc
class myConfirmData: NSObject {
    
    @objc var ist003006 = ""
    
    init(dic:Dictionary<String, Any>){
        super.init()
        setValuesForKeys(dic)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

