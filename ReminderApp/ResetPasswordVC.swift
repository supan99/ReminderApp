//
//  ResetPasswordVC.swift
//  ReminderApp


import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnUpdate: PurpleThemeButton!
    
    
    var email: String = ""
    var flag: Bool = true
    
    
    private func validation(password: String, confirmPass: String) -> String {
        
        if password.isEmpty {
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
    
    
    @IBAction func BtnClick(_ sender: UIButton) {
        self.flag = false
        
        let error = self.validation(password: self.txtPassword.text?.trim() ?? "", confirmPass: self.txtConfirmPassword.text?.trim() ?? "")
        
        if error.isEmpty {
//            self.updatePassword(password: self.txtPassword.text?.trim() ?? "")
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtConfirmPassword.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
}


//MARK:- Extension for Forgot Password Function
extension ResetPasswordVC {

//    func updatePassword(password: String) {
//        let ref = AppDelegate.shared.db.collection(rUser).document(self.email)
//        ref.updateData([
//            rPassword: password
//        ]){ err in
//            if let err = err {
//                print("Error updating document: \(err)")
//                self.navigationController?.popViewController(animated: true)
//            } else {
//                print("Document successfully updated")
//                Alert.shared.showAlert(message: "Your Password has been updated successfully !!!") { (true) in
//                    if let vc = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self){
//                        UIApplication.shared.setRootController(for: vc)
//                    }
//                }
//            }
//        }
//    }
}
