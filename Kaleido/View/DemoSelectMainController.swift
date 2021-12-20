//
//  DemoSelectMainController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/17.
//

import Foundation

class DemoSelectMainController {
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    private var orderData: Order?
    public func getOrderData() -> Order? {
        return orderData
    }
    
    public func setOrderInfo(data: Order) {
        orderData = data
    }
    
    public func getOrderInforStr(data: Order?) -> String{
        var retStr = ""
        guard let orderDetail = data else {
            return retStr
        }
        let uId = orderDetail.user_id
        let pId = orderDetail.product_id
        let note = orderDetail.note ?? ""
        let doer = orderDetail.doer ?? ""
        let customer = entityGetter.getCustomer(id: uId)
        let product = entityGetter.getProductType(id: pId)
        if let customer = customer {
            retStr += customer.full_name ?? ""
            retStr += ", "
            retStr += customer.birthday ?? ""
            retStr += "\n"
        }
        if let prodType = product {
            switch prodType.name {
            case EntityNameDefine.productLashTop + "_" + EntityNameDefine.productLashBott:
                if let topData = self.getProductLashTop(id: prodType.ref_id_1) {
                    retStr += self.setTopData(data: topData)
                }
                if let bottData = self.getProductLashBott(id: prodType.ref_id_2) {
                    retStr += self.setBottData(data: bottData)
                }
            case EntityNameDefine.productLashTop:
                if let topData = self.getProductLashTop(id: prodType.ref_id_1) {
                    retStr += self.setTopData(data: topData)
                }
            case EntityNameDefine.productLashBott:
                if let bottData = self.getProductLashBott(id: prodType.ref_id_1) {
                    retStr += self.setBottData(data: bottData)
                }
            default:
                print("Product type name incorrect")
            }
        }
        retStr += "\n備註：\(note), \(doer), "
        
        return retStr
    }
    
    public func setTopData(data: ProductLashTop) -> String {
        var retStr = "上睫毛：\n"
        if let topType = data.type {
            retStr += topType + ", "
        }
        if let topColor = data.color {
            retStr += topColor + ", "
        }
        if let topSize = data.top_size {
            retStr += topSize + ", "
        }
        if data.total_quantity != 0 {
            retStr += String(data.total_quantity) + "根, "
        }
        var tmpRetStr = ""
        if let left1 = data.left_1, left1 != "" {
            tmpRetStr += "左1: \(left1), "
        }
        if let left2 = data.left_2, left2 != ""  {
            tmpRetStr += "左2: \(left2), "
        }
        if let left3 = data.left_3, left3 != "" {
            tmpRetStr += "左3: \(left3), "
        }
        if let left4 = data.left_4, left4 != "" {
            tmpRetStr += "左4: \(left4), "
        }
        if let left5 = data.left_5, left5 != "" {
            tmpRetStr += "左5: \(left5), "
        }
        if let right1 = data.right_1, right1 != "" {
            tmpRetStr += "右1: \(right1), "
        }
        if let right2 = data.right_2, right2 != ""{
            tmpRetStr += "右2: \(right2), "
        }
        if let right3 = data.right_3, right3 != ""{
            tmpRetStr += "右3: \(right3), "
        }
        if let right4 = data.right_4, right4 != ""{
            tmpRetStr += "右4: \(right4), "
        }
        if let right5 = data.right_5, right5 != "" {
            tmpRetStr += "右5: \(right5), "
        }
        if tmpRetStr != "" {
            retStr += "\n\(tmpRetStr)"
        }
        return retStr
    }
    
    public func setBottData(data: ProductLashBott) -> String {
        var retStr = "下睫毛：\n"
        if let bottCurl = data.curl {
            retStr += bottCurl + ", "
        }
        if let bottSize = data.bott_size {
            retStr += bottSize + ", "
        }
        if let bottLen = data.length {
            retStr += bottLen + ", "
        }
        if data.total_quantity != 0 {
            retStr += String(data.total_quantity) + "根, "
        }
        return retStr
    }
    
    public func getProductLashTop(id: Int32) -> ProductLashTop? {
        return entityGetter.getProductTopLash(id: id)
    }
    
    public func getProductLashBott(id: Int32) -> ProductLashBott?{
        return entityGetter.getProductBottLash(id: id)
    }
}
