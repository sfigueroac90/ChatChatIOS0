//
//  ViewController.swift
//  ChatChat0
//
//  Created by Sebastian Figueroa on 25/04/17.
//  Copyright © 2017 Sebastian Figueroa. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    
    
    var messages: [FIRDataSnapshot]! = [FIRDataSnapshot]()//Firdatasnapshot constructor
    var ref:FIRDatabaseReference! //Force to be a FIRDataBaseReference
    private var _refHandle: FIRDatabaseHandle! //Force fo be FIRDATABASEHANDLE TYPE
    
    deinit {
        self.ref.child("messages").removeObserver(withHandle: _refHandle)
    }
    
  
    @IBAction func LogOut(_ sender: UIBarButtonItem) {
        
        
         let firebaseAuth = FIRAuth.auth();
         do{
         try firebaseAuth?.signOut();
         } catch let signOutError as NSError{
         
         print(signOutError.localizedDescription);
         }
         
        //After logout we need to instantiate loginviewcontroller
        
        if(FIRAuth.auth()?.currentUser == nil){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController")
            self.navigationController?.present(vc!,animated: true, completion:nil);
        }
        
        

        
    }
    
    func configureDataBase(){
        
        ref = FIRDatabase.database().reference() //Obtain a reference for the DataBase
        
        //Set the handler
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { (snapshot) in
            self.messages.append(snapshot)
            self.tableView.insertRows(at: [IndexPath (row: self.messages.count-1, section: 0)], with: .automatic)
            
            
        })
        
        
    }
    
    func sendMessage(_ data: [String:String]){
        
        var packet = data
        packet[Constants.MessageFields.dateTime]=Utilities().GetDate() //Add date tiem to the packet
        self.ref.child("messages").childByAutoId().setValue(packet)
        
    }
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var tableView: UITableView!
  
    override func viewWillAppear(_ animated: Bool) {
      
        super.viewWillAppear(true);
        
      
        
        //logout
        
        
        /*
        let firebaseAuth = FIRAuth.auth();
        do{
            try firebaseAuth?.signOut();
        } catch let signOutError as NSError{
            
            print(signOutError.localizedDescription);
        }
 
 */
 
       
 
        if(FIRAuth.auth()?.currentUser == nil){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController")
            self.navigationController?.present(vc!,animated: true, completion:nil);
        }else{
             configureDataBase()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        let messageSnap: FIRDataSnapshot! = self.messages[indexPath.row]
        let message = messageSnap.value as! Dictionary<String,String>
        if let text = message[Constants.MessageFields.text] as String!{
            cell.textLabel?.text = text}
        
        if let subtText = message[Constants.MessageFields.dateTime]{
        
            cell.detailTextLabel?.text = subtText
        }
        
        
        return cell
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textField.delegate = self
        
        configureDataBase()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_ :)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_ :)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NSLog("View will dissappear")
        
      //  NotificationCenter.r
        
       // NotificationCenter.default.removeObserver(self)
        
       // NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
      //  NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
        NSLog("Observers removed")

    }
    
    func keyboardWillHide(_ sender: NSNotification){
        
        let userInfo: [AnyHashable:AnyObject] = sender.userInfo! as [AnyHashable : AnyObject]
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue.size
        
        self.view.frame.origin.y += keyboardSize.height
        
    }
    
    
    func keyboardWillShow(_ sender: NSNotification){
    
        
        NSLog("Keyboard will show and sender is %@",sender)
        
        //Creo un diccionario en el almaceno el user info del sender notificacion
        let userInfo: [AnyHashable:AnyObject] = sender.userInfo! as [AnyHashable : AnyObject]
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.cgRectValue.size
        
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.cgRectValue.size
        
       // NSLog("KeyBoard Size: %f",keyboardSize.height)
        
        if(keyboardSize.height == offset.height){ //Aparentement siempre serán iguales es posible que este if sobre???
            
            let viewOrigin = self.view.window?.frame.origin.y //Origen del ViewController
            
            if(viewOrigin == 0){//Si el origen es 0 en Y
                UIView.animate(withDuration: 0.15, animations: {
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        }else{
            
            UIView.animate(withDuration: 0.15, animations: {
                self.view.frame.origin.y = self.view.frame.origin.y + (keyboardSize.height - offset.height)
            })
            
        }
        
    
    }
    

    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("eneded editing")
        
        let data = [Constants.MessageFields.text : textField.text! as String]
        sendMessage(data)
       
        
        self.view.endEditing(true)
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

