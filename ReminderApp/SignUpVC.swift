//
//  SignUpVC.swift
//  ReminderApp


import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSignUp: PurpleThemeButton!
    
    var flag: Bool = true
    
    @IBAction func btnClick(_ sender:  UIButton){
        
       self.flag = false
        let error = self.validation(name: self.txtName.text?.trim() ?? "", email: self.txtEmail.text?.trim() ?? "", password: self.txtPassword.text?.trim() ?? "", confirmPass: self.txtConfirmPassword.text?.trim() ?? "", phone: self.txtPhone.text?.trim() ?? "")
        
        if error.isEmpty {
            self.register(name: self.txtName.text ?? "", email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", phone: self.txtPhone.text?.trim() ?? "")
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    
    private func validation(name: String, email: String, password: String, confirmPass: String,phone: String) -> String {
        
        if name.isEmpty {
            return STRING.errorEnterName
            
        } else if email.isEmpty {
            return STRING.errorEmail
            
        } else if !Validation.isValidEmail(email) {
            return STRING.errorValidEmail
        } else if phone.isEmpty{
            return STRING.errorPhone
        }else if !Validation.isValidPhoneNumber(phone) {
            return STRING.errorValidPhone
        }else if password.isEmpty {
            return STRING.errorPassword
            
        } else if password.count < 8 {
            return STRING.errorPasswordCount
            
        } else if !Validation.isValidPassword(password) {
            return STRING.errorValidCreatePassword
            
        } else if confirmPass.isEmpty {
            return STRING.errorConfirmPassword
            
        } else if password != confirmPass {
            return STRING.errorPasswordMismatch
            
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
extension  SignUpVC {
    
    func register(name: String, email: String, password:String, phone: String){
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password){authResult, error in
            let id = authResult?.user.uid ?? ""
            if error != nil {createAccount(name: name, email: email, password: password, phone: phone, id : id)} else {
                Alert.shared.showAlert(message: error?.localizedDescription ?? "", completion: nil)
            }
        }
        
        
        func createAccount(name: String, email: String, password: String, phone: String, id: String) {
            Firestore.firestore().collection(rUser).document(FirebaseAuth.Auth.auth().currentUser?.uid ?? "" ).setData([rEmail: email,
                                                                                                                         rName: name,
                                                                                                                        rPhone: phone]){
                err in
                if err != nil {
                    UIApplication.shared.setTab()
                    Alert.shared.showAlert(message: "Error!!!", completion: nil)
                    self.flag = true
                }else{
                    UIApplication.shared.setTab()
                    Alert.shared.showAlert(message: "Welcome!!!", completion: nil)
                }
            }
        }
    }
}
