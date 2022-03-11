//
//  DemoBindingController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/20.
//

import Foundation
import UIKit

class DemoBindingViewModel {
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    lazy var entitySetter: EntitySetHelper = EntitySetHelper(entity: entitySerice, get: entityGetter)
//    var pathSelected = Observable<[String]>(value: [])
    var imageSelected: Dictionary<String, UIImage> = [:] {
        didSet {
            guard let closure = imageSelectedClosure else{
                return
            }
            closure()
        }
    }
    var imageSelectedClosure: (() -> ())?
    var orderData: Order?
    
    public func getOrderData() -> Order? {
        return self.orderData
    }
    
    public func setOrderInfo(data: Order) {
        self.orderData = data
    }
    
    public func saveImage(data: UIImage,forlder: String ,name: String) -> String {
        var retPath = ""
        do {
            
            if let rotateImage = data.correctImage(), let PNGImage = rotateImage.pngData() {
                let pathName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(forlder)
                let filePathWithName = pathName.appendingPathComponent(name)
                if !FileManager.default.fileExists(atPath: pathName.path){
                    do {
                        try FileManager.default.createDirectory(at: pathName, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print("Couldn't create document directory to \(pathName)")
                    }
                }
                try PNGImage.write(to: filePathWithName, options: .atomic)
                retPath = filePathWithName.path
           }
        } catch {
            print("error")
        }
        return retPath
    }
   
    public func getImageByPath(forlder: String, name: String) -> UIImage?{
        let forlderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(forlder)
        
        let pathName = forlderPath.appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: pathName.path) {
            let retImg = UIImage(contentsOfFile: pathName.path)
            return retImg
        }
        
        return nil
    }
    
    public func saveImageAndStoreDb() {
        let userSelectedImgs = self.imageSelected
        for pathName in userSelectedImgs.keys {
            if let selectedImg = userSelectedImgs[pathName] {
                let forlderName = self.orderData?.id ?? 0
                _ = self.saveImage(data: selectedImg, forlder: String(forlderName),name: pathName)
            }
            if let curOrder = self.orderData {
                _ = entitySetter.createPhotoBind(cId: curOrder.user_id, orderId: curOrder.id, path: pathName)
            }
        }
    }
    
    public func getImageFromDb(orderId: Int32) {
        var retImageDic: Dictionary<String, UIImage> = [:]
        guard let photoBindArr = entityGetter.getPhotoBind(orderId: orderId) else {
            return
        }
        for photoBind in photoBindArr {
            if let photoName = photoBind.path, let getImage = self.getImageByPath(forlder: String(orderId) , name: photoName) {
                retImageDic[photoName] = getImage
            }
        }
        self.imageSelected = retImageDic
    }
}
