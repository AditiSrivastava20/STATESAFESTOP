//
//  NotificationTableviewDataSource.swift
//  SSSCAM
//
//  Created by cbl16 on 3/27/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class NotificationTableviewDataSource: TableViewDataSource {

  
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let identifier = indexPath.row <= 1 ? "NotificationTableViewCell" : "NotificationAttachmentTableViewCell"
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if let block = self.configureCellBlock , let item: Any = self.items?[(indexPath as NSIndexPath).row]{
            block(cell , item , indexPath as Any?)
        }
        return cell
    }
    

}
