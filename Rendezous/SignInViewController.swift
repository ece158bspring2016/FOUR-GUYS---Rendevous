//
//  SignInViewController.swift
//  Rendezvous
//
//  Created by Jason Lu on 5/13/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    let ref = Firebase(url: "https://rend-ezvous.firebaseio.com")
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!

    @IBAction func handleSignIn(sender: AnyObject) {
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
            
            let user = ["username" : self.usernameField.text!]
            self.ref.childByAppendingPath("USERS/\(uid)").setValue(user)
            self.performSegueWithIdentifier("segueToMap", sender: nil)
        }
            
        })
    }
    
    @IBAction func handleCreateAccount(sender: AnyObject) {
        ref.createUser(emailField.text!, password: passwordField.text!, withValueCompletionBlock: { error, result in
            
            if self.emailField.text == "" && self.usernameField.text == "" && self.passwordField.text == ""
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
    
    func pleaseCreateAccount () {
        let alert = UIAlertController (title :"Unable to Create Account",
                                       message: "Enter your email, username and password",
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

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
