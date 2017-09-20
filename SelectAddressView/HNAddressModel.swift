//
//  HNAddressModel.swift
//  Merchant
//
//  Created by yangzhilan on 2017/9/4.
//  Copyright © 2017年 huanniu. All rights reserved.
//

import UIKit
import HandyJSON

// 城市三级联动
class HNAreaCommonModel:HandyJSON  {
    var id: Int?                //  省、市、区的ID
    var area_code: String?
    var name: String?           //  省、市、区的名字
    var up_id: Int?             //  上一级别的ID
    var depth: Int?
    var sort: Int?
    var path: String?
    var pinyin: String?
    var cross_area: Int?
    var merchants: Int?
    var users: Int?
    var charges: String?
    var created_at: String?
    var updated_at: String?
    var all_yg_give: String?

    required init() {}
}

// 省
class HNProvinceList: HNAreaCommonModel {
    var city_list: Array<HNCityList>?
}

// 市
class HNCityList: HNAreaCommonModel {
    var area_list: Array<HNAreaList>?
}

// 区
class HNAreaList: HNAreaCommonModel {

}

class HNAddressData: HandyJSON {
    var province_List: Array<HNProvinceList>?
    
    required init() {}
}

class HNAddressModel: HandyJSON {
    var data: HNAddressData?
    
    required init() {}
}
