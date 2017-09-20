//
//  ViewController.swift
//  SelectAddressView
//
//  Created by Zerella on 2017/9/20.
//  Copyright © 2017年 Zerella. All rights reserved.
//

import UIKit

class ViewController: UIViewController,HNExitAddressViewDelagate {
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var addressLab: UILabel!
    var addressView:HNSelectAddressView?
    var addressStr = ""
    var bgView :UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // 灰色背景视图
        bgView = UIView()
        bgView?.frame = self.view.bounds
        bgView?.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
    }

    @IBAction func addressBtnAction(_ sender: Any) {
        self.view.addSubview(bgView!)
        addressView = Bundle.main.loadNibNamed("HNSelectAddressView", owner: nil, options: nil)?.first as? HNSelectAddressView
        addressView?.frame = CGRect(x:0,y:self.view.frame.size.height,width:self.view.frame.size.width,height:0)
        addressView?.initAddressView()
        self.addressView?.delegate = self
        self.view.addSubview(addressView!)
        
        UIView.animate(withDuration: 0.3) {
            self.addressView?.frame = CGRect(x:0,y:self.view.frame.size.height - 366,width:self.view.frame.size.width,height:366)
        }
        // 添加移除手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
        bgView?.addGestureRecognizer(tapGesture)
        
        addressView?.block = {province,city,area in
            self.addressStr = String(format:"%@ %@ %@",province.name!,city.name!,area.name!)
            self.addressLab.text = self.addressStr
        }
    }
    
    // 移除动画
    func hideView() {
        // 收回选择区域动画
        UIView.animate(withDuration: 0.3) {
            self.addressView?.frame = CGRect(x:0,y:self.view.frame.size.height,width:self.view.frame.size.width,height:0)
            self.addressView?.removeFromSuperview()
            self.bgView?.removeFromSuperview()
        }
    }
    
    // 选择区域取消
    func cancel() {
        self.hideView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

