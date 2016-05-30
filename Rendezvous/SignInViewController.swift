//
//  SignInViewController.swift
//  Rendezvous
//
//  Created by Jason Lu on 5/13/16.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Firebase(url: "https://rend-ezvous.firebaseio.com")
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    
    @IBAction func SignUp(sender: AnyObject) {
        self.performSegueWithIdentifier("createAccountSegue", sender: nil)
    }

    @IBAction func SignIn(sender: AnyObject) {
        ref.authUser(emailField.text!, password: passwordField.text!, withCompletionBlock: { error, authData in
            
            if self.emailField.text == "" && self.passwordField.text == ""
            {
                self.pleaseSignIn()
            }
            
            if error != nil
            {
                print("Unable to sign in user")
                self.cannotSignIn()
                
            }
            else {
                let uid = authData.uid
                print("Login successful with uid: \(uid)")
                
                // Save UID
                dataService.CURRENT_USER_UID = uid!

                
                let user_ref = self.ref.childByAppendingPath("USERS/\(uid)/Name")
                user_ref.observeEventType(.Value, withBlock: { snapshot in
                    //print(snapshot.value)
                    user_info = UserInfo.init(name: snapshot.value as! String, uid: uid!)
                    }, withCancelBlock: { error in
                        print(error.description)
                })

                self.performSegueWithIdentifier("segueToMap", sender: nil)
            }
        })
    }
    

    
    func cannotSignIn () {
        let alert = UIAlertController (title: "Unable to Sign In", message: "Email and/or password incorrect", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok",
            style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
                print("OK")
        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
   
    func pleaseSignIn () {
        let alert = UIAlertController (title :"Unable to Sign In",
                                       message: "Enter your email and password",
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
        
        emailField.delegate = self
        passwordField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dismiss the keyboard when the user taps the "Return" key or its equivalent
    // while editing a text field.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

}