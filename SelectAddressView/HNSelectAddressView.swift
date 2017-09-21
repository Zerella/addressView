//
//  HNSelectAddressView.swift
//  SelectAddressView
//
//  Created by Zerella on 2017/9/4.
//  Copyright © 2017年 Zerella. All rights reserved.
//

import UIKit
protocol HNExitAddressViewDelagate: NSObjectProtocol{
    func cancel()           // 取消
}
typealias cityDataBlock = (String)->()
typealias setAddressStrBlock = (HNAreaCommonModel,HNAreaCommonModel,HNAreaCommonModel)->()
class HNSelectAddressView: UIView,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{
    fileprivate let selectAddressCell = "HNSelectAddressCell"
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!     // 取消
    @IBOutlet weak var redLineView: UIView!     // 红线
    @IBOutlet weak var provinceBtn: UIButton!   // 省
    @IBOutlet weak var cityBtn: UIButton!       // 市
    @IBOutlet weak var areaBtn: UIButton!       //区
    @IBOutlet var tableView: UITableView!
    var delegate:HNExitAddressViewDelagate?
    var cityData:cityDataBlock?
    var block:setAddressStrBlock?               // block 回调
    var addressModel: HNAddressModel!
    var provinceModel: HNProvinceList!
    var cityModel: HNCityList!
    var areaModel: HNAreaList!
    var currentArray:Array<Any>?                // 当前数组
    var provinceArray:Array<Any>?
    var cityArray:Array<Any>?
    var areaArray:Array<Any>?

    static func newInstance() -> HNSelectAddressView? {
        let nibView = Bundle.main.loadNibNamed("HNSelectAddressView", owner: nil, options: nil)
        if let view = nibView?.first as? HNSelectAddressView {
            return view
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initAddressView(){
        // 注册 cell
        tableView.delegate = self
        tableView.dataSource = self
        cityBtn.isHidden = true
        areaBtn.isHidden = true
        let addressCellID = selectAddressCell
        let addressNibName = UINib(nibName: selectAddressCell, bundle: nil)
        tableView.register(addressNibName, forCellReuseIdentifier: addressCellID)
        self.loadData()
    }
    
    // 加载数据
    func loadData(){
        let path = Bundle.main.path(forResource:"cityes", ofType: "json")
        let url = URL(fileURLWithPath: path!)
            let data = try! Data(contentsOf: url)
            let json = try! JSONSerialization.jsonObject(with:data, options:JSONSerialization.ReadingOptions.allowFragments)
            let jsonDic = json as! Dictionary<String,Any>
            let jsonStr = getJSONStringFromDictionary(dictionary: jsonDic as NSDictionary)
            addressModel = HNAddressModel.deserialize(from: jsonStr)
            self.provinceArray = addressModel.data?.province_List
            self.currentArray = self.provinceArray
            
            self.tableView.reloadData()
    }
    
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }

    // 根据城市 id 返回城市参数
    func accordingProvinceID(provinceID:Int,cityID:Int,areaID:Int,cityData:cityDataBlock){
        let cityStr = NSMutableString()
        if provinceModel != nil {
            if provinceModel.name != nil{
                cityStr.append(provinceModel.name!)
            }
        }
        if cityModel != nil {
            if cityModel.name != nil {
                cityStr.append(cityModel.name!)
            }
        }
        if areaModel != nil {
            if areaModel.name != nil {
                cityStr.append(areaModel.name!)
            }
        }
        let temp:String? = cityStr as String
        var tempStr:String = (temp?.replacingOccurrences(of: " ", with: ""))!
        if tempStr.characters.count > 0 {
            cityData(cityStr as String)
        } else {
            cityData("")
        }
    }
    
    // tableViewdelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.currentArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HNSelectAddressCell = tableView.dequeueReusableCell(withIdentifier: selectAddressCell) as!HNSelectAddressCell
        let model:HNAreaCommonModel = currentArray![indexPath.row] as! HNAreaCommonModel
        cell.nameLab.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 当前等于省
        if currentArray?.count == provinceArray?.count {
            provinceModel  = currentArray![indexPath.row] as! HNProvinceList
            cityModel = nil
            areaModel = nil
            cityArray = provinceModel.city_list
            currentArray = cityArray
            self.tableView.reloadData()
            provinceBtn.setTitle(provinceModel.name, for: UIControlState.normal)
            cityBtn.isHidden = false
            self.layoutIfNeeded()
            self.redLineMoveAnimation(button: self.cityBtn)
            // 如果只有省数据,选择完毕后也退出
            if currentArray?.count == 0 {
                self.exitAddressView()
            }
        // 当前等于市
        } else if currentArray?.count == cityArray?.count {
            cityModel = cityArray![indexPath.row] as! HNCityList
            areaArray = cityModel.area_list
            areaModel = nil
            currentArray = areaArray
            self.tableView.reloadData()
            cityBtn.setTitle(cityModel.name, for: UIControlState.normal)
            areaBtn.isHidden = false
            self.layoutIfNeeded()
            self.redLineMoveAnimation(button: self.areaBtn)
            
            if areaArray?.count == 0 {
                self.exitAddressView()
            }
        // 当前等于区
        } else if currentArray?.count == areaArray?.count {
            areaModel = areaArray![indexPath.row] as! HNAreaList
            areaBtn.setTitle(areaModel.name, for: UIControlState.normal)
            self.layoutIfNeeded()
            self.exitAddressView()
        }
    }
    
    // 取消
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.delegate?.cancel()
    }
    
    // 省
    @IBAction func provinceBtnAction(_ sender: Any) {
        self.redLineMoveAnimation(button:sender as! UIButton)
        currentArray = provinceArray
        self.tableView.reloadData()
    }

    // 市
    @IBAction func cityBtnAction(_ sender: Any) {
        self.redLineMoveAnimation(button: sender as! UIButton)
        currentArray = cityArray
        self.tableView.reloadData()
    }
    
    // 区
    @IBAction func areaBtnAction(_ sender: Any) {
        self.redLineMoveAnimation(button: sender as! UIButton)
        currentArray = areaArray
        self.tableView.reloadData()
    }
    
    // 红线移动动画
    func redLineMoveAnimation(button:UIButton){
        UIView.animate(withDuration: 0.3, animations: {
            self.redLineView.frame = CGRect(x:button.frame.origin.x,y:button.frame.origin.y + 33,width:button.frame.width,height:1)
        })
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    // 离开当前界面
    func exitAddressView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform.init(translationX: 0, y: self.frame.size.height - 366)
            self.layoutIfNeeded()
        }) { (finished:Bool) in
            if finished {
                self.block!(self.provinceModel,self.cityModel,self.areaModel)
                self.delegate?.cancel()
            }
        }
    }
    
}
