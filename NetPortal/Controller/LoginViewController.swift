//
//  ViewController.swift
//  NetPortal
//
//  Created by Siyabonga Zondo on 2018/01/31.
//  Copyright © 2018 Siyabonga Zondo. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var Usernametxtfield: UITextField!
    @IBOutlet weak var Passwordtxtfield: UITextField!
    @IBOutlet weak var LoginLabel: UILabel!
    @IBOutlet weak var ForgotPassButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    //login URL
    let URL_USER_LOGIN = "https://cynectar.co.za/BCportal/Login.php"
    

    //the defaultvalues to store user data
    let defaultValues = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //changing the status bar color to light content ~ white
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // checks if there's network connectivity. if not an  alert is before the user try to login
        if CheckNetworkConectivity.isConnectedToInternet() == false{
          
            let alert = UIAlertController(title: "Network Error!", message: "Check your network Conectivity!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        LoginButton.layer.cornerRadius = 15.0
        ForgotPassButton.layer.cornerRadius = 7.0
        
        //setting textfield border color
        let myColor = UIColor.init(red: 212/255, green: 85/255, blue: 0.0, alpha: 1.0)
        Usernametxtfield.layer.borderColor = myColor.cgColor
        Passwordtxtfield.layer.borderColor = myColor.cgColor
        
        //setting the border radius of text fields
        
         Usernametxtfield.layer.cornerRadius = 9.0
         Passwordtxtfield.layer.cornerRadius = 9.0
        
        // border width of textfields
        Usernametxtfield.layer.borderWidth = 1.0
        Passwordtxtfield.layer.borderWidth = 1.0
        
        //hiding the navigation button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //if user is already logged in switching to profile screen
        if defaultValues.string(forKey: "username") != nil{
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! StudentAreaViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
            
        }
    }
    
    
    @IBAction func Login(_ sender: UIButton) {

        // checks if the user wants to login without internet connection
        // and stops the login process if there's no network connection
        if CheckNetworkConectivity.isConnectedToInternet() == false{
            
            let alert = UIAlertController(title: "Network Error!", message: "Check your network Conectivity!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            self.LoginLabel.text = "Please wait..."
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            //getting the username and password
            let parameters: Parameters=[
                "user_name":Usernametxtfield.text!,
                "password":Passwordtxtfield.text!
            ]
            
            print(parameters)
            //making a post request
            Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    
                    //dismissing the network indicator
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    //printing response
                    print(response)
                    
                    
                    //getting the json value from the server
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        //if there is no error
                        if(!(jsonData.value(forKey: "error") as! Bool)){
                            
                            //getting the user from response
                            let user = jsonData.value(forKey: "user") as! NSDictionary
                            
                            //getting user values
                            
                            let userName = user.value(forKey: "name") as! String
                            let userSurname = user.value(forKey: "surname") as! String
                            let userEmail = user.value(forKey: "email") as! String
                            

                            //saving user values to defaults
                            
                            self.defaultValues.set(userName, forKey: "name")
                            self.defaultValues.set(userSurname, forKey: "surname")
                            self.defaultValues.set(userEmail, forKey: "useremail")
                            
                            //switching the screen
                            let studentAreaViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabController") as! UITabBarController
                            self.navigationController?.pushViewController(studentAreaViewController, animated: true)
                            
                            self.dismiss(animated: false, completion: nil)
                            
                        }else{
                            //error message in case of invalid credential
                            self.LoginLabel.text = "Invalid username or password"
                        }
                }
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // changing the status bar color back to default(black color) after successful login 
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
}

