//
//  CusViewController.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/24.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit

class CusViewController: UINavigationController {
    var myBoolean = true
    var myOrientationMask:UIInterfaceOrientationMask = .allButUpsideDown
    var surport:UIInterfaceOrientationMask = .landscape
    
    override var shouldAutorotate: Bool{
        return myBoolean
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return surport
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeLeft
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
