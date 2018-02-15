//
//  AnnouncementsTableViewCell.swift
//  NetPortal
//
//  Created by Siyabonga Zondo on 2018/02/08.
//  Copyright © 2018 Siyabonga Zondo. All rights reserved.
//

import UIKit

class AnnouncementsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var AnnouncerLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var AnnouncementLabel: UILabel!
    
    
    func  Configure(announcement:Announcement) {
        
        AnnouncerLabel.text = announcement.Announcer
        DateLabel.text = announcement.Date
        AnnouncementLabel.text = announcement.objAnnouncement
        
        
        
    }

}
