//
//  ViewController.swift
//  KeyChain_Demo
//
//  Created by xyj on 2017/5/2.
//  Copyright © 2017年 xyjw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...1 {
            
            print(XYJKeyChain.add(key: XYJKeyChain.key, userId: "userid\(i)", data: "保存的数据\(i)".data(using: .utf8)!))
            guard let a = XYJKeyChain.get(key: XYJKeyChain.key, userId: "userid\(i)") else {
                return
            }
            print(String.init(data: a, encoding: .utf8) ?? "默认")
            
            print(XYJKeyChain.delete(key: XYJKeyChain.key, userId: "userid\(i)"))
        }
    }
}

