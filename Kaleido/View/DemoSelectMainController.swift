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
        let customer = entityGetter.getCustomer(id: uId)
        let product = entityGetter.getProductType(id: pId)
        if let customer = customer {
            retStr += customer.full_name ?? ""
            retStr += ", "
            retStr += customer.birthday ?? ""
            retStr += "\n\n"
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
                if let bottData = self.getProductLashBott(id: prodType.ref_id_2) {
                    retStr += self.setBottData(data: bottData)
                }
            default:
                print("Product type name incorrect")
            }
        }
        
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
