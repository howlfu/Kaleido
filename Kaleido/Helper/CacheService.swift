//
//  CacheService.swift
//  Kaleido
//
//  Created by Howlfu on 2022/3/11.
//

import Foundation

protocol CacheServiceProtocol {
    func cacheNew(id: String, object: Any)
    func cacheRemove(by id: String) -> Bool
    func getCache(by id: String) -> Any?
    func stop()
}

class CacheService: CacheServiceProtocol {
    static let inst:CacheService = CacheService()
    private var cacheIdList: [String] = []
    private var cacheDict: Dictionary<String, Any> = [:]
    func cacheNew(id: String, object: Any){
        if(!cacheIdList.contains(id)) {
            cacheIdList.append(id)
        }
        cacheDict[id] = object
    }
    
    func cacheRemove(by id: String) -> Bool {
        if(cacheIdList.contains(id)) {
            guard let indexToRemove = cacheIdList.firstIndex(of: id) else {
                return false
            }
            cacheIdList.remove(at: indexToRemove)
            cacheDict.removeValue(forKey: id)
            return true
        }
        return false
    }
    
    
    func getCache(by id: String) -> Any?
    {
        if (cacheIdList.contains(id)) {
            return cacheDict[id]
        }
        return nil
    }
    
    func stop(){
        cacheIdList.removeAll()
        cacheDict.removeAll()
    }
}
