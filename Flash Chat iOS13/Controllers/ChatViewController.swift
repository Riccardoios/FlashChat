//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // always good practise to implement this: call super after this kind of methods
        navigationController?.navigationBar.isTranslucent = true
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
       
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, erorr) in
            
            self.messages = []
            
            if let e = erorr {
                print ("There was an issue retrivieng data from FireStore \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1 , section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                // this is just for get the last message first
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data:[
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) {(error) in
                    if let e = error {
                        print ("there was an issue saving data to firestore, \(e)")
                    } else {
                        print ("successfuly saved data firestore")
                        
                        DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                        }
                    }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
    
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
     
          // this is a message from the current user.
          if message.sender == Auth.auth().currentUser?.email {
              cell.leftImageView.isHidden = true
              cell.rightImageView.isHidden = false
              cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
              cell.label.textColor = UIColor(named: K.BrandColors.purple)
          }
          // this is a message from another sender
          else {
              cell.leftImageView.isHidden = false
              cell.rightImageView.isHidden = true
              cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
              cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
          }
          
          
        return cell
    }
}



//extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print (indexPath.row)
//    }
//} // this one is one a row is selected
