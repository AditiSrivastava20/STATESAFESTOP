//
//  BaseViewController.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import Material
import ISMessages
import EZSwiftExtensions
import GooglePlacePicker
import NVActivityIndicatorView

class BaseViewController: UIViewController, UIApplicationDelegate {

    let viewTemp = UIView(frame: UIScreen.main.bounds)
    
    var loader : NVActivityIndicatorView?
    
    
    var dataSource : TableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        loader = NVActivityIndicatorView(frame: CGRect(x: view.center.x-22, y: view.center.y-22, w: 44, h: 44) , type: .ballClipRotate, color: colors.loaderColor.color() , padding: nil)
        
        viewTemp.addSubview(loader!)
        keyWindow.addSubview(viewTemp)
        viewTemp.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewTemp.isHidden = true
        

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.Font(.HelveticaNeue , type: .Regular , size: 16)]
        
        // Do any additional setup after loading the view.
        
         NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name.UIApplicationDidEnterBackground , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appTerminated), name: NSNotification.Name.UIApplicationWillTerminate , object: nil)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setupTableView(tableView : UITableView? , cellId : String? , items : [Any]? ) {
        
        
        dataSource = TableViewDataSource(items:items , height: UITableViewAutomaticDimension , tableView: tableView, cellIdentifier:cellId , configureCellBlock: { (cell, item, indexPath) in
            
            
            (cell as? ComplaintTableViewCell)?.objComplaint = item as? Complaint
            
        }, aRowSelectedListener: { (indexPath) in
            
        }) { (scrollView) in
            
        }
        
        tableView?.delegate = dataSource
        tableView?.dataSource = dataSource
        
    }
    
    //MARK:- fetch full address
    func fetchFullAddress(completion: @escaping (String?) -> ()) {
        view.endEditing(true)
        
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePicker(config: config)
        
        
        placePicker.pickPlace(callback: { (place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place selected")
                return
            }
            
            var address = ""
            
            if "\(place.name)".lowercased().range(of:"\(place.coordinate.latitude)") != nil {
                completion(address)
            } else {
                address = "\(place.name)"
            }
            
            if let _ = place.formattedAddress {
                address += "\(place.formattedAddress!)"
            }
            
            if let _ = place.attributions {
                address += "\(place.attributions)"
            }
            
            completion(address)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        ISMessages.hideAlert(animated: true)
        self.view.endEditing(true)
    }
    
    func startLoader() {
        
        loader?.startAnimating()
        viewTemp.isHidden = false
        
    }
    
    func stopLoader() {
        
        self.loader?.stopAnimating()
        self.viewTemp.isHidden = true
        
    }
    
    func appMovedToBackground() {
        self.view.endEditing(true)
    }
    
    func appTerminated() {
        
    }
    

}

extension BaseViewController: PinCodeTextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        ISMessages.hideAlert(animated: true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    
}



