//
//  File.swift
//  NetPortal
//
//  Created by Siyabonga Zondo on 2018/02/08.
//  Copyright © 2018 Siyabonga Zondo. All rights reserved.
//

import Foundation
import UIKit

class Announcement {
    
   // let  id: Int
    let Announcer: String
    let Date: String
    let objAnnouncement: String
    let DownloadableFileLink: String
    var downloaded = false
    
    init(Announcer:String,Date:String,objAnnouncement:String,DownloadableFileLink:String) {
       
        self.Announcer = Announcer
        self.Date = Date
        self.objAnnouncement = objAnnouncement
        self.DownloadableFileLink = DownloadableFileLink
    }
    
}
