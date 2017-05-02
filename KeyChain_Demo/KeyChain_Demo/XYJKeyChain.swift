//
//  XYJKeyChain.swift
//  KeyChain_Demo
//
//  Created by xyj on 2017/4/28.
//  Copyright © 2017年 xyjw. All rights reserved.
//
import UIKit


public extension String {
    var uuid : String {
        let puuid = CFUUIDCreate( nil );
        
        let uuidString = CFUUIDCreateString(nil, puuid);
        
        return uuidString as! String
    }
}
    

struct XYJKeyChain {
    
    static let key = "keyq"
    
    static var resultCode : OSStatus = noErr
    
    private static func getKeyChainQuery(key service: String, userId: String) -> Dictionary<String, Any> {
        
        let addQuery : [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrLabel as String : "My UUID",
            kSecAttrAccount as String : userId,
            kSecReturnData as String : kCFBooleanTrue
        ]
        
        return addQuery
    }
    
    /**
     保存数据
     
     - parameter sevice: 对应的key
     - parameter data:   数据
     
     - returns: 是否成功
     */
    public static func add(key sevice: String, userId: String, data: Data) -> Bool {
        
        var query = getKeyChainQuery(key: sevice, userId: userId)
        
        SecItemDelete(query as CFDictionary)
        
        query.updateValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        
        return SecItemAdd(query as CFDictionary, nil) == noErr
    }
    
    /**
     读取数据
     
     - parameter sevice: key
     
     - returns: 数据
     */
    public static func get(key sevice: String, userId: String) -> Data? {
        var result: Data? = nil
        
        var dic = getKeyChainQuery(key: sevice, userId: userId)
        
        dic[kSecReturnData as String] = kCFBooleanTrue
        
        dic[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var queryResult: AnyObject?
        
        print(SecItemCopyMatching(dic as CFDictionary , &queryResult))
        if SecItemCopyMatching(dic as CFDictionary , &queryResult) == noErr {
            
            guard let a = NSKeyedUnarchiver.unarchiveObject(with: (queryResult as? Data)!) as? Data else { return nil }
            
            result = a
        }else {
            
            print("the load data is nil")
        }
        return result
    }
    
    /**
     删除数据
     
     - parameter sevice: key
     
     - returns: 是否成功
     */
    public static func delete(key sevice: String, userId: String) -> Bool {
        
        let query = getKeyChainQuery(key: sevice, userId: userId)
        
        return SecItemDelete(query as CFDictionary) == noErr
    }
    
}

