//
//  EditViewController.swift
//  Tiny3DViewer
//
//  Created by セラフ on 2015/03/12.
//  Copyright (c) 2015年 yoshimura. All rights reserved.
//

import UIKit

class EditViewController: UITableViewController {
    
    // 新規の場合、-1
    var index:Int = -1
    var topViewController:TopViewController? = nil
//    var displayUrlItem:ModelItem? = nil
    var modelItem:ModelItem? = nil
    var modelData:NSData? = nil
    var modelFileLoadAt:NSDate? = nil
    
    @IBOutlet weak var txtUrl: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "編集"
        
        txtUrl?.text = modelItem?.url ?? ""
        txtName?.text = modelItem?.name ?? ""
        modelFileLoadAt = modelItem?.modelFileLoadAt
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        var _index = index
        var _item = modelItem
        if _item == nil {
            _index = -1
            _item = ModelItem()
        }
        _item!.url = txtUrl?.text ?? ""
        _item!.name = txtName?.text ?? ""
        _item!.modelFileLoadAt = self.modelFileLoadAt
        
        if _item!.name.isEmpty {
            _item!.name = _item!.url
        }
        
        if _item!.url.rangeOfString("\\.(?i)obj$", options: .RegularExpressionSearch, range: nil, locale: nil) != nil {
            _item!.modelType = "obj"
        } else if _item!.url.rangeOfString("\\.(?i)dae$", options: .RegularExpressionSearch, range: nil, locale: nil) != nil {
            _item!.modelType = "dae"
        }
        
        if !_item!.name.isEmpty {
//            self.topViewController?.saveModelItem(_index, item: _item!, modelData:self.modelData)
            self.topViewController?.saveModelItem(_index, item: _item!)
        }
        
        self.topViewController?.refresh()
        
    }
    
    @IBAction func touchEditButton(sender: AnyObject) {
//        self.performSegueWithIdentifier("GoBack From EditViewController", sender: self)
        SVProgressHUD.showWithStatus("loading...", maskType: .Black)

        self.loadModel()
    }
    
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
//
//        println(toViewController)
//        
//        return super.segueForUnwindingToViewController(toViewController,fromViewController:fromViewController,identifier:identifier)
//    }
    
    // MARK: UITableViewController
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
//        if section == 1 {
//            if let _comps = CommonUtil.getNSDateComponents(self.modelFileLoadAt) {
//                return "最終取得日時: \(_comps.year)/\(_comps.month)/\(_comps.day) \(_comps.hour):\(_comps.minute):\(_comps.second) "
//            }
//        }
        
        return nil
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        return true
    }
    
    func loadModel() {
        let url = NSURL(string:txtUrl?.text ?? "")
        let req = NSURLRequest(URL:url!)
        
        NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            SVProgressHUD.dismiss()
            if let _msg = err?.localizedDescription {
                self.showAlert(_msg)
                return
            }
            self.modelData = data
            self.modelFileLoadAt = NSDate()
            
            self.tableView.reloadData()
            
            // let image = UIImage(data:data)
            // 画像に対する処理 (UcellのUIImageViewに表示する等)
        }
    }
    
    func showAlert(msg:String) {
        
        let _ac = UIAlertController(title: "Tiny3DView", message: msg, preferredStyle:.Alert)
        
        _ac.addAction(
            UIAlertAction(title: "OK", style: .Default, handler: {
                action in
            }))
        
        self.presentViewController(_ac, animated: true, completion: nil)
        
    }
}