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
        
        let item = items?[indexPath.row] as? NotificationData
        
        let type = MediaType(rawValue: (item?.media_type)!) ?? .none
        var identifier = ""
        
        switch type {
        case .audio, .video:
            identifier = "NotificationAttachmentTableViewCell"
        default:
            identifier = "NotificationTableViewCell"
        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if let block = self.configureCellBlock , let item: Any = self.items?[(indexPath as NSIndexPath).row]{
            block(cell , item , indexPath as Any?)
        }
        return cell
    }
    

}
