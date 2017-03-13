//
//  ViewController.swift
//  UserLogin
//
//  Created by Mitosis on 11/01/17.
//  Copyright © 2017 Mitosis. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class ViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passField: UITextField!
    
    @IBOutlet var customButton: FBSDKLoginButton!
    
    
    @IBOutlet var myView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
      assignbackground()
      emailfieldView()
        passfieldView()

//Remember me 
        
        
    remember.addTarget(self, action: #selector(self.stateChanged(_:)),for: UIControlEvents.valueChanged)
        isClicked = UserDefaults.standard.bool(forKey: "switch")
        if(isClicked==true)
        {
            remember.setOn(true, animated: true)
            emailField.text=UserDefaults.standard.string(forKey: "keepEmail")
            passField.text=UserDefaults.standard.string(forKey: "keepPwd")
        }
       
        
//FB
        self.emailField.delegate = self;
        self.passField.delegate = self;

      customButton.readPermissions=["email","public_profile"]
        customButton.delegate=self
        
        customButton.addTarget(self, action: #selector(handleCustomFBLogin), for: UIControlEvents.touchUpInside)
        
//Gmail
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        // TODO(developer) Configure the sign-in button look/feel
        // [START_EXCLUDE]
      
        NotificationCenter.default.addObserver(self,selector: #selector(ViewController.receiveToggleAuthUINotification(_:)),name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),object: nil)
                toggleAuthUI()

    }
    
    //Gmail start
    
    @IBOutlet var signInButton: GIDSignInButton!
    
    @IBOutlet var signOutButton: UIButton!
    
   
    @IBAction func didTapSignOut(_ sender: AnyObject)
    {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
                toggleAuthUI()
        // [END_EXCLUDE]
    }
    // [END signout_tapped]
   
    
        func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            }
        else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            
           
        }
    }
    // [END toggle_auth]
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                           }
        }
    }
    
//Gmail End

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
 func assignbackground(){
        
        let background = UIImage(named: "login_banner")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleToFill
        imageView.clipsToBounds = true
        imageView.image = background
        //imageView.alpha=0.5
        imageView.center = view.center
        myView.addSubview(imageView)
        myView.sendSubview(toBack: imageView)
    
    }
    
    
//FB start
    func handleCustomFBLogin(){
        
   //  FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self)
    //   { (result, error) -> Void in
    //  if error != nil {
       //   print("custom FB Login Failed",error)
       //       }
    //}
                self.showEmail()
                print(123)
     
     

      }
  
    
    func showEmail()
    {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "email, id, name"]).start {
            (connection, result, err) in
          if(err == nil)
           {
                print("result \(result)")
            }
           else
            {
                print("error \(err)")
            }
        }
      
    }
   
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil
        {
            print(error)
            return
            
        }
        else{
            print("Successfully logged in with Facebook... ")
            
        }
        //showEmail()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        
        print("Did Logout of Facebook")
        
    }
//FB end
    
//Validation start
    
    func emailfieldView()
    {
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "email_field")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        emailField.leftViewMode = UITextFieldViewMode.always
        emailField.leftView = leftView
        
      
    }
    
    func passfieldView()
    {
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "pass_field")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        passField.leftViewMode = UITextFieldViewMode.always
        passField.leftView = leftView

           }
    
    func  displayMyAlert(_ userMessage:String)
    {
        let myAlert=UIAlertController(title:"Alert",message: userMessage,preferredStyle: UIAlertControllerStyle.alert);
        let okAction=UIAlertAction(title:"ok",style:UIAlertActionStyle.default, handler:nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    
    
    func validate(_ value: String) ->  Bool {
        
        let PASS_REGEX = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{8,}$" //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character
        let passTest = NSPredicate(format: "SELF MATCHES %@", PASS_REGEX)
        let result =  passTest.evaluate(with: value)
        return result
    }
    
//Validate End
    
    
    
//Regular Login
    @IBAction func btnLogin(_ sender: AnyObject) {
        
        let currentEmail="i@p.co"
        let currentPass="Qwerty12"
        
        UserDefaults.standard.set(currentEmail, forKey: "keepEmail")
        UserDefaults.standard.set(currentPass, forKey: "keepPwd")
        UserDefaults.standard.synchronize()
        
        //let userEmail = NSUserDefaults.standardUserDefaults().stringForKey("email")
       // let userPass = NSUserDefaults.standardUserDefaults().stringForKey("pass")
        
        
        if(emailField.text==currentEmail && passField.text==currentPass && isValidEmail(emailField.text!) && validate(passField.text!) )
        {
            
            performSegue(withIdentifier: "loginView", sender: sender)
            
        }
            
        else{
            displayMyAlert("Login Failed! Enter Correct Email and Password");
            return;
            
        }

    }
    
    
//Remember Me switch
    @IBOutlet var remember: UISwitch!
    var isClicked:Bool=false
    
   
    @IBAction func btnRemember(_ sender: AnyObject) {
        
        if(remember.isOn){
            remember.setOn(false, animated: true)
        }
        else{
            remember.setOn(true, animated: true)
        }
    }
    func stateChanged(_ switchState: UISwitch)
    {
        if(switchState.isOn)
        {
            UserDefaults.standard.set(true, forKey: "switch")
            UserDefaults.standard.synchronize()
        }
        else{
            UserDefaults.standard.set(false, forKey: "switch")
            UserDefaults.standard.synchronize()
        }

    }
}

