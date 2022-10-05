//
//  ProfileVC.swift
//  ReminderApp
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProfileVC: UIViewController {

    //MARK: Outlet
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblMail: UILabel!
    @IBOutlet weak var btnLogout: RoundedThemeButton!
    @IBOutlet weak var btnSave: RoundedThemeButton!
    @IBOutlet weak var btnResetPassword: RoundedThemeButton!
    
    //MARK: Custom Method
    
    let email : String = FirebaseAuth.Auth.auth().currentUser?.email ?? ""
    let uid: String = FirebaseAuth.Auth.auth().currentUser?.uid ?? ""
    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
        if AppDelegate.shared.userType == .Admin {
            self.lblMail.text = "Admin@gmail.com"
            self.txtName.text = "Admin"
            self.txtName.isUserInteractionEnabled = false
            self.btnSave.isHidden = true
        }else{
            Firestore.firestore().collection(rUser).whereField(rEmail, isEqualTo: email).addSnapshotListener{querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                let data1 = snapshot.documents[0].data()
                if let name: String = data1[rName] as? String, let email: String = data1[rEmail] as? String {
                    self.lblMail.text = email
                    self.txtName.text = name
                }
            }
        }
    }
    
    //MARK: Action Method
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnLogout {
            Alert.shared.showAlert("", actionOkTitle: "Logout", actionCancelTitle: "Cancel", message: "Are you sure you want to logout?") { (yes) in
                if yes {
                    UIApplication.shared.setStart()
                }
            }
        }else if sender == btnSave {
            let error = self.validation()
            if error.isEmpty {
                self.updateData(uid: uid, name: self.txtName.text?.trim() ?? "")
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }else if sender == btnResetPassword {
            self.resetPassword(email: GFunction.user.email)
        }
        
    }
    
    func resetPassword(email:String){
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email){
            error in
            Alert.shared.showAlert(message: "Reset password link has been set to your mail id", completion: nil)
        }
    }
    
    func validation() -> String {
        if self.txtName.text?.trim() == "" {
            return "Please enter name"
        }
        return ""
    }
    
    //MARK: UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    
    func updateData(uid: String, name: String) {
        let ref =  Firestore.firestore().collection(rUser).document(uid)
        ref.updateData([
            rName: name,
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                Alert.shared.showAlert(message: "Your data has been Updated !!!") { Bool in
                    if Bool {
                        self.applyStyle()
                    }
                }
            }
        }
    }
}
