//
//  GetAnnouncements.swift
//  NetPortal
//
//  Created by Siyabonga Zondo on 2018/02/09.
//  Copyright © 2018 Siyabonga Zondo. All rights reserved.
//

import Foundation



class GetAnnouncements{
    
   
    typealias QueryResult = ([Announcement]?, String) -> ()
    typealias JSONDictionary = [String: Any]
    
    
    var AnnouncementsArray: [Announcement] = []
    var errorMessage = ""
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    
    func getAnnouncements(completion: @escaping QueryResult) {

        // 1
        dataTask?.cancel()
        // 2
        if var urlComponents = URLComponents(string: "https://cynectar.co.za/Retrofit/IOSAnnouncements.php") {
           
            // 3
            guard let url = urlComponents.url else { return }
            // 4
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                // 5
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateAnnouncementResults(data)
                    // 6
              
                }
            }
            // 7
            
            dataTask?.resume()
        }
    }
    
    func updateAnnouncementResults(_ data: Data){
        var response: JSONDictionary?
        
        AnnouncementsArray.removeAll()
        
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
            
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["Announcements"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            print("response changed")
            return
        }
        
        for AnnouncementDictionary in array {
            
            if let AnnouncementDictionary = AnnouncementDictionary as? JSONDictionary,
                
                // let idjson = AnnouncementDictionary["id"] as? Int,
                let announcer = AnnouncementDictionary["Announcer"] as? String,
                let date = AnnouncementDictionary["Date"] as? String,
                let announcement = AnnouncementDictionary["Announcement"] as? String,
                let downloadlink = AnnouncementDictionary["DownloadableFileLink"] as? String
                
            {
                
                AnnouncementsArray.append(Announcement( Announcer: announcer, Date: date, objAnnouncement: announcement, DownloadableFileLink: downloadlink))
                
                
                
               //  print(downloadlink + " " + announcer + " " + date + " " + announcement)
                
            } else {
                errorMessage += "Problem parsing AnnouncementsDictionary\n"
            }
        }
        
        print(AnnouncementsArray)
    }



}
