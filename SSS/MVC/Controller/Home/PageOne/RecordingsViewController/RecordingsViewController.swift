//
//  RecordingsViewController.swift
//  SSS
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit


class RecordingsViewController: UIViewController {
    
    var selectedRow:Int = -1
    let data:[String:String] = ["title": "video_01.mp4", "image": Asset.icVideoFill.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension RecordingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
    }
    
}

extension RecordingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingTableCell", for: indexPath) as! RecordingTableCell
        
        cell.cellData = data
        return cell
        
    }
    
}







































//override func viewDidAppear(_ animated: Bool) {
//    let modalViewController = self.storyboard?.instantiateViewController(withIdentifier: "PinValidation")
//    modalViewController?.modalPresentationStyle = .overCurrentContext
//    present(modalViewController!, animated: true, completion: nil)
//}
