//
//  CreateAccountViewController.swift
//  Rendezvous
//
//  Created by Jason Lu on 5/19/16.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    let ref = Firebase(url: "https://rend-ezvous.firebaseio.com")
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBAction func SignIn(sender: AnyObject) {
        performSegueWithIdentifier("GoBacktoSignInSegue", sender: nil)
    }
    
    @IBAction func createAccountHandle(sender: AnyObject) {
        ref.createUser(emailField.text!, password: passwordField.text!, withValueCompletionBlock: { error, result in
            
            if self.emailField.text == "" && self.nameField.text == "" && self.passwordField.text == "" && self.phoneNumberField.text == ""
            {
                self.pleaseCreateAccount()
            }
            
            if error != nil
            {
                print("Account already exists")
                self.cannotCreateAccount()
            }
            else
            {
                let uid = result["uid"] as? String
                print("Successfully created user with uid: \(uid)")
                
                
                let number = self.phoneNumberField.text!
                let name = ["Username" : self.nameField.text!]
                self.ref.childByAppendingPath("USERS/\(number)").setValue(name)
                
                self.performSegueWithIdentifier("segueToMap", sender: nil)
            }
        })
    }
    
    func cannotCreateAccount () {
        let alert = UIAlertController (title :"Unable to Create Account",
                                       message: "Email already exists",
                                       preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok",
                               style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
                                print("OK")
        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func pleaseCreateAccount () {
        let alert = UIAlertController (title :"Unable to Create Account",
                                       message: "Enter your name, phone number, email and password",
                                       preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok",
                               style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
                                print("OK")
        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
