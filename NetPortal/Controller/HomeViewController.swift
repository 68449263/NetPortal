//
//  HomeViewController.swift
//  NetPortal
//
//  Created by Siyabonga Zondo on 2018/02/06.
//  Copyright © 2018 Siyabonga Zondo. All rights reserved.
//

import UIKit
import Foundation

class HomeViewController: UIViewController {

    @IBOutlet weak var StudentName: UILabel!
    @IBOutlet weak var Course: UILabel!
    @IBOutlet weak var AnnouncementsTableView: UITableView!

    typealias JSONDictionary = [String: Any]
 
    var AnnouncementsArray: [Announcement] = []
    var errorMessage = ""

    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    override func viewDidAppear(_ animated: Bool) {
        AnnouncementsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

          getAnnouncements()

          AnnouncementsTableView.delegate = self
          AnnouncementsTableView.dataSource = self

          getUserInfoFromDefaults()
    }
    

    func getAnnouncements() {

        dataTask?.cancel()

        if var urlComponents = URLComponents(string: "https://cynectar.co.za/Retrofit/IOSAnnouncements.php") {

            guard let url = urlComponents.url else { return }
       
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
      
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateAnnouncementResults(data)
                }
            }

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
 
        
       AnnouncementsArray = createArray(array:array)
  
    }
    

    func createArray(array:[Any])->[Announcement]{
        
        var tempAnnouncements:[Announcement] = []
        
        for AnnouncementDictionary in array {
            
            if let AnnouncementDictionary = AnnouncementDictionary as? JSONDictionary,
                
                // let idjson = AnnouncementDictionary["id"] as? Int,
                let announcer = AnnouncementDictionary["Announcer"] as? String,
                let date = AnnouncementDictionary["Date"] as? String,
                let announcement = AnnouncementDictionary["Announcement"] as? String,
                let downloadlink = AnnouncementDictionary["DownloadableFileLink"] as? String
                
            {
                
                tempAnnouncements.append(Announcement( Announcer: announcer, Date: date, objAnnouncement: announcement, DownloadableFileLink: downloadlink))

                //  print(downloadlink + " " + announcer + " " + date + " " + announcement)
                
            } else {
                errorMessage += "Problem parsing AnnouncementsDictionary\n"
            }
        }
        
        return tempAnnouncements
    }
    

    func getUserInfoFromDefaults(){
        
        //getting user data from defaults
        let defaultValues = UserDefaults.standard
        
        if let name = defaultValues.string(forKey: "name"){
            let surname = defaultValues.string(forKey: "surname")
            //setting the name to label
            StudentName.text = name + " " + surname!
        }else{
            //send back to login view controller
        }
    }
    
    

}

extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnnouncementsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnnouncementsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementsTableViewCell") as! AnnouncementsTableViewCell
                
        let announcement = AnnouncementsArray[indexPath.row]
        
        cell.Configure(announcement:announcement)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 5.9, green: 7.9, blue: 9.9, alpha: 1.0) // very light gray
        } else {
            cell.backgroundColor = UIColor.white
        }
    }
    
}



