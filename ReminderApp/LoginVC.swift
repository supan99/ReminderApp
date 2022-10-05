//
//  LoginVC.swift
//  ReminderApp

import UIKit
import FirebaseAuth
import FirebaseFirestore
class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: PurpleThemeButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    var flag : Bool = true
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnLogin {
            self.flag = false
            let error = self.validation(email: self.txtEmail.text!.trim(),password: self.txtPassword.text!.trim())

            if error.isEmpty {
                if self.txtEmail.text?.trim() == "Admin@gmail.com" && self.txtPassword.text?.trim() == "Admin@1234" {
                    AppDelegate.shared.userType = .Admin
                    UIApplication.shared.setAdmin()
                }else{
                    AppDelegate.shared.userType = .User
                    self.loginUser(email: self.txtEmail.text?.trim() ?? "", password: self.txtPassword.text?.trim() ?? "")
                }
                
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }else if sender == btnForgotPassword {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: ForgotPasswordVC.self){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func validation(email: String, password: String) -> String {
        
        if email.isEmpty {
            return STRING.errorEmail
        }else if !Validation.isValidEmail(email) {
            return STRING.errorValidEmail
        } else if password.isEmpty {
            return STRING.errorPassword
        } else if password.count < 8 {
                return STRING.errorPasswordCount
        } else if !Validation.isValidPassword(password) {
            return STRING.errorValidCreatePassword
        } else {
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


//MARK:- Extension for Login Function
extension LoginVC {
    func loginUser(email:String,password:String){
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password){  [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if error != nil {
                Alert.shared.showAlert(message: error?.localizedDescription ?? "", completion: nil)
            }else{
                Firestore.firestore().collection(rUser).whereField(rEmail, isEqualTo: email).addSnapshotListener{querySnapshot, error in
                    guard let snapshot = querySnapshot else {
                        print("Error fetching snapshots: \(error!)")
                        return
                    }
                    if snapshot.documents.count != 0 {
                        let data1 = snapshot.documents[0].data()
                        if let name: String = data1[rName] as? String, let email: String = data1[rEmail] as? String, let phone: String = data1[rPhone] as? String {
                            GFunction.user = UserModel(docID: "", name: name, email: email,phone: phone, profileImage: "")
                        }
                        UIApplication.shared.setTab()
                    }
                }
            }
        }
    }
}
