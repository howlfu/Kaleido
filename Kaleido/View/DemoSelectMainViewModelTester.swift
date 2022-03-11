//
//  DemoSelectMainViewModelTester.swift
//  Kaleido
//
//  Created by Howlfu on 2022/3/10.
//

import Foundation

class DemoSelectMainViewModelTester: DemoSelectMainViewModel {
    var productType: ProductType?
    var customer: Customer?
    var productLashTop: ProductLashTop?
    var productLashBott: ProductLashBott?
    
    public func setTestProductType(data: ProductType) {
        self.productType = data
    }
    
    public func setTestCustomer(data: Customer) {
        self.customer = data
    }
    
    public func setTestProductLashTop(data: ProductLashTop) {
        self.productLashTop = data
    }
    
    public func setTestProductLashBott(data: ProductLashBott) {
        self.productLashBott = data
    }
    
    override func getProductTypeById(id: Int64) -> ProductType? {
        return self.productType
    }
    
    override func getCustomerById(id: Int32) -> Customer?{
        return self.customer
    }
    
    override func getProductLashTop(id: Int32) -> ProductLashTop? {
        return self.productLashTop
    }
    
    override func getProductLashBott(id: Int32) -> ProductLashBott?{
        return self.productLashBott
    }
}
