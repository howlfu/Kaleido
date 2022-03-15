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
    let cacheService = CacheService.inst
    var imageSelectedClosure: (() -> ())?
    var orderData: Order?
    
    public func getOrderData() -> Order? {
        return self.orderData
    }
    
    public func setOrderInfo(data: Order) {
        self.orderData = data
    }
    
    public func saveImageDetail(data: UIImage,forlder: String ,name: String) -> String {
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
    
    public func saveImage() {
        //binding btn action
        let userSelectedImgs = self.imageSelected
        let cacheFromDb = cacheService.getCache(by: CacheKeyType.demoBindImg)
        
        for pathName in userSelectedImgs.keys {
            //save image
            if let selectedImg = userSelectedImgs[pathName] {
                let forlderName = self.orderData?.id ?? 0
                _ = self.saveImageDetail(data: selectedImg, forlder: String(forlderName),name: pathName)
                //save to cache
                if var dictImgs = cacheFromDb as? Dictionary<String, UIImage>{
                    dictImgs[pathName] = selectedImg
                }
            }
            //save image path binding
            if let curOrder = self.orderData {
                _ = entitySetter.createPhotoBind(cId: curOrder.user_id, orderId: curOrder.id, path: pathName)
            }
            
            
            
        }
    }
    
    public func getImageFromDb(orderId: Int32) {
        let cacheFromDb = cacheService.getCache(by: CacheKeyType.demoBindImg)
        if let  dictImgs = cacheFromDb as? Dictionary<String, UIImage>
        {
            self.imageSelected = dictImgs
        } else {
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
            cacheService.cacheNew(id: CacheKeyType.demoBindImg, object: retImageDic)
        }
    }
}
