//
//  TopViewController.swift
//  Tiny3DViewer
//
//  Created by yoshimura on 2015/03/12.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import UIKit

class TopViewController: UITableViewController {
    
    var selectRowIndex:Int = 0
    //    var selectIndex:Int = -1
    var list = [ModelItem]()
    
    var viewModel:String? = nil
    var viewIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        if let _list = loadModelItem() {
            self.list = _list
        } else {
            
            saveModelItem(-1, item: ModelItem(url: "http://kick55.com/20150515/anchor.obj", name:"サンプル(OBJ)"))
            saveModelItem(-1, item: ModelItem(url: "http://kick55.com/20150515/lego.dae", name:"サンプル(DAE)"))
            
            self.list = loadModelItem() ?? []
            
        }
        
        
//        self.list = loadModelItem()
        self.tableView?.tableFooterView = UIView(frame: CGRectZero)
        
        let _btn = UIButton.buttonWithType(.InfoLight) as! UIButton
        _btn.addTarget(self, action: Selector("touchButton:"), forControlEvents: .TouchUpInside)
        
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: _btn)
        
        
        //       SVProgressHUD.showWithStatus("loading...", maskType: SVProgressHUDMaskType.None)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Open ThreeDViewController" {
            if let threeDViewController = segue.destinationViewController as? ThreeDViewController {
                
                threeDViewController.modelUrl = ""
                
//                if selectRowIndex == 0 {
//                    threeDViewController.modelType = "obj"
//                    threeDViewController.modelFile = "sample1.dat"
//                    return
//                } else if selectRowIndex == 1 {
//                    threeDViewController.modelType = "dae"
//                    threeDViewController.modelFile = "sample2.dat"
//                    return
//                }
//                
                let _index = selectRowIndex
                if _index >= 0 && _index < list.count {
                    let _item = list[_index]
                    threeDViewController.modelUrl = _item.url
                    threeDViewController.modelType = _item.modelType
                    threeDViewController.modelFile = _item.modelFile
                    return
                }
            }
        } else if segue.identifier == "Open EditViewController" {
            if let editViewController = segue.destinationViewController as? EditViewController {
                
                editViewController.index = selectRowIndex
                if editViewController.index >= 0 && editViewController.index < list.count {
                    editViewController.modelItem = list[editViewController.index].copy() as? ModelItem
                }
                editViewController.topViewController = self
            }
        }
    }
    
    //    @IBAction func goBackFromEditViewController(segue: UIStoryboardSegue) {
    //        println(segue)
    //    }
    //
    //    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
    //        return true
    //    }
    // MARK: UI Events
    func touchButton(sender:UIButton) {
        self.performSegueWithIdentifier("Open InfoViewController", sender: self)

    }
    
    // MARK: UITableViewController
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let _cell = tableView.dequeueReusableCellWithIdentifier("TopCell") as? UITableViewCell
        
//        if indexPath.item == 0 {
//            _cell!.textLabel?.text = "サンプル(OBJ)"
//            _cell!.textLabel?.textColor = UIColor.blackColor()
//            
//        } else if indexPath.item == 1 {
//            _cell!.textLabel?.text = "サンプル(DAE)"
//            _cell!.textLabel?.textColor = UIColor.blackColor()
//            
//        } else
        if indexPath.item ==  list.count  {
            _cell!.textLabel?.text = "新規"
            _cell!.textLabel?.textColor = UIColor.redColor()
        } else {
            
            var _title = ""
            let _index = indexPath.item
            if _index >= 0 && _index < self.list.count {
                _title = self.list[_index].name
                if _title.isEmpty {
                    _title = self.list[_index].url
                }
            }
            
            _cell!.textLabel?.text = _title
            _cell!.textLabel?.textColor = UIColor.blackColor()
        }
        
        return _cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        selectRowIndex = indexPath.item
        
//        if selectRowIndex == 0 || selectRowIndex == 1 {
//            let _item = ModelItem()
//            self.performSegueWithIdentifier("Open ThreeDViewController", sender: self)
//            return
//        } else
        if selectRowIndex ==  list.count  {
            // 新規
            
            self.performSegueWithIdentifier("Open EditViewController", sender: self)
            return
        }
        
        let _index = selectRowIndex
        if _index < 0 || list.count <= _index {
            return
        }
        
        
        
        let alertController =
        UIAlertController(title: "操作", message: "", preferredStyle: .ActionSheet)
        
        alertController.addAction(
            UIAlertAction(title: "3DViewer", style: .Default, handler: {
                action in
                self.performSegueWithIdentifier("Open ThreeDViewController", sender: self)
            }))
        alertController.addAction(
            UIAlertAction(title: "編集", style: .Default, handler: {
                action in
                self.performSegueWithIdentifier("Open EditViewController", sender: self)
            }))
        alertController.addAction(
            UIAlertAction(title: "削除", style: .Default, handler: {
                action in
                
                let _ac = UIAlertController(title: "Tiny3DViewer", message: "削除しますか？", preferredStyle: .Alert)
                
                _ac.addAction(UIAlertAction(title: "削除する", style: .Default, handler: {
                    action2 in
                    self.list.removeAtIndex(_index)
                    let _data = NSKeyedArchiver.archivedDataWithRootObject(self.list)
                    let _defaults = NSUserDefaults.standardUserDefaults()
                    _defaults.setObject(_data, forKey: "ItemList")
                    _defaults.synchronize()
                    
                    self.refresh()
                    
                    }
                    ))
                _ac.addAction(UIAlertAction(title: "しない", style: .Cancel, handler: nil))
                
                self.presentViewController(_ac, animated: true, completion: nil)
                
            }))
        
        alertController.addAction(UIAlertAction(title: "CLOSE", style: .Cancel, handler: nil))
        
        //For ipad And Univarsal Device
        let _frame = self.view.frame
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect =
            CGRectMake(_frame.width / 2, _frame.height, 0, 0)
        //RectではなくUIBarButtonItemを起点にできるプロパティもある
        //alertController.popoverPresentationController.barButtonItem
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: refresh
    func refresh() {
        self.list = loadModelItem() ?? []
        self.tableView.reloadData()
    }
    
    // MARK: UrlItem load/save
    func loadModelItem()->[ModelItem]? {
        let _defaults = NSUserDefaults.standardUserDefaults()
        let _data = _defaults.objectForKey("ItemList") as? NSData
        if _data != nil {
            if var _list = NSKeyedUnarchiver.unarchiveObjectWithData(_data!) as? [ModelItem] {
                return _list
            }
        }
        return nil
    }
    
//    func saveModelItem(index:Int, item:ModelItem, modelData:NSData?) {
    func saveModelItem(index:Int, item:ModelItem) {
        
        var _list = loadModelItem() ?? []
        
        // 空いているファイル名検索
//        if modelData != nil && item.modelFile.isEmpty {
//            for i in 0..<10 {
//                let _modelFile = "model\(i).dat"
//                let _n = _list.filter({
//                    e in
//                    return e.modelFile == _modelFile
//                })
//                if _n.isEmpty {
//                    item.modelFile = _modelFile
//                    break
//                }
//            }
//        }
        
//      println(item);
        
        if index == -1 {
//            if _list.count >= 10 {
//                return
//            }
            _list.append(item)
        } else if index >= 0 && index < _list.count {
            _list[index] = item
        } else {
            return
        }
        
        //        var _list2 = [UrlItem(), UrlItem(), UrlItem()]
        //        NSData* classDataSave = [NSKeyedArchiver archivedDataWithRootObject:list];
        let _data = NSKeyedArchiver.archivedDataWithRootObject(_list)
        let _defaults = NSUserDefaults.standardUserDefaults()
        _defaults.setObject(_data, forKey: "ItemList")
        _defaults.synchronize()
        
//        if modelData != nil {
//            self.saveModelData(item.modelFile, data: modelData)
//        }
    }
    
//    func saveModelData(name:String, data:NSData?) {
//        
//        if name.isEmpty {
//            return
//        }
//        
//        let _paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let _dictionary = _paths[0] as? String
//        let _dir = NSBundle.mainBundle().resourcePath!        
//        let _path = _dir.stringByAppendingPathComponent(name)
//        
//        
//        if data == nil {
//            let _fileManager = NSFileManager.defaultManager()
//            _fileManager.removeItemAtPath(_path, error: nil)
//            return
//        }
//        data?.writeToFile(_path, atomically: false)
//    }
    //    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    //        return rooms.count
    //    }
    //
    //    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell! {
    //        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("RoomCell") as? UITableViewCell
    //        if !cell {
    //            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:"RoomCell")
    //        }
    //
    //        let room = rooms[indexPath.row]
    //        cell!.textLabel.textColor = UIColor.blackColor()
    //        cell!.textLabel.text = "\(room.name)(\(room.messageCount))"
    //        return cell
    //    }
}