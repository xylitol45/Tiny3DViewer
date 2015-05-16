//
//  UrlItem.swift
//  Tiny3DViewer
//
//  Created by セラフ on 2015/03/17.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import Foundation

class ModelItem : NSObject, NSCoding {
    
    var url = ""
    var name = ""
    var modelType = ""
    var modelFile = ""
    var modelFileLoadAt:NSDate? = nil
    
    override init() {
        super.init()
    }
    
    init(url:String, name:String) {
        self.url = url
        self.name = name
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.modelType, forKey:"modelType")
        aCoder.encodeObject(self.modelFile, forKey:"modelFile")
        aCoder.encodeObject(self.modelFileLoadAt, forKey:"modelFileLoadAt")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObjectForKey("url") as! String? ?? ""
        self.name = aDecoder.decodeObjectForKey("name") as! String? ?? ""
        self.modelType = aDecoder.decodeObjectForKey("modelType") as! String? ?? ""
        self.modelFile = aDecoder.decodeObjectForKey("modelFile") as! String? ?? ""
        self.modelFileLoadAt = aDecoder.decodeObjectForKey("modelFileLoadAt") as! NSDate?
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject! {
        var _res = ModelItem()
        _res.url = url
        _res.name = name
        _res.modelType = modelType
        _res.modelFile = modelFile
        _res.modelFileLoadAt = modelFileLoadAt
        return _res
    }
    
//
//    
//    - (id)copyWithZone:(NSZone*)zone
//    {
//    // 複製を保存するためのインスタンスを生成します。
//    CopyingClass* result = [[[self class] allocWithZone:zone] init];
//    
//    if (result)
//    {
//    [result->stringValue release];
//    [result->arrayValues release];
//    
//    result->stringValue = [stringValue copyWithZone:zone];
//    result->arrayValues = [[NSArray allocWithZone:zone] initWithArray:arrayValues copyItems:YES];
//    }
//    
//    return result;
//    }
//    
    
}