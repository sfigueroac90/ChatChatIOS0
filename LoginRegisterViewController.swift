//
//  LoginRegisterViewController.swift
//  
//
//  Created by Sebastian Figueroa on 25/04/17.
//
//

import UIKit
import Firebase


class LoginRegisterViewController: UIViewController {

    @IBOutlet var emailTextView: UITextField!
    @IBOutlet var passwordTextView: UITextField!
    
   
    
    func CheckInput()-> Bool{
        if((emailTextView.text?.characters.count)! < 5){
            
            emailTextView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0.4, alpha: 0.5);
            return false
            
        }else{
            
            emailTextView.backgroundColor = UIColor.white
        }
        
        
        if((passwordTextView.text?.characters.count)! < 5){
            
            passwordTextView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0.4, alpha: 0.5);
            return false
            
        }else{
            
            passwordTextView.backgroundColor = UIColor.white
        }
        
        return true
    
    }
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        NSLog("longinClicked");
        if(!CheckInput()){
        return
        }
        
        
        let email = emailTextView.text
        let password = passwordTextView.text
        
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
              Utilities().ShowAlert(title: "Error!", message: error.localizedDescription, vc: self)
            print(error.localizedDescription)
                return
            }
            print("signed in!");
            
            self.dismiss(animated: true, completion: nil)
            
            
            return
            
        })
        
        
        
    }
    
    
   
    @IBAction func registerClicked(_ sender:    UIButton) {
        NSLog("RegisterClicked");
        if(!CheckInput()){
        return
        }
        
        let alert = UIAlertController(title:"Register", message: "Please Confirm password...", preferredStyle: .alert)
        
       
        
       
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action-> Void in
        
            let passConfirm = alert.textFields![0] as UITextField
            if(passConfirm.text!.isEqual(self.passwordTextView.text)){
                
                //register begins
                let email = self.emailTextView.text
                let password = self.passwordTextView.text
                
                FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
                    if let error = error{
                        Utilities().ShowAlert(title: "Error", message: error.localizedDescription, vc: self)
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                
            })
                
            }else{
            
                Utilities().ShowAlert(title: "Error", message: "Password are not the same", vc: self);
            }
        
        }))
         alert.addAction(UIAlertAction(title:"Cancel",style: .default, handler: nil))
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "password"
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        NSLog("ForgotPassClicked");
        if(!emailTextView.text!.isEmpty){
        
        
            let email = emailTextView.text!
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
                if let error = error {
                Utilities().ShowAlert(title: "Error", message: error.localizedDescription, vc: self)
                    return
                }
                
                Utilities().ShowAlert(title: "Mensaje envaido", message: "Revisa tu correo", vc: self)
                
            })
            
            
        }else{
        
        Utilities().ShowAlert(title: "Falta email", message: "Debes escribir su email", vc: self)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisterViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap);
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
