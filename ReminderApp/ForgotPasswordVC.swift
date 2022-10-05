//
//  ForgotPasswordVC.swift
//  ReminderApp


import UIKit
import FirebaseAuth

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: PurpleThemeButton!
    
    var flag:Bool = true
    
    
    @IBAction func BtnClick(_ sender: UIButton) {
        self.flag = false
        let error = self.validation(email: self.txtEmail.text?.trim() ?? "")
        
        if error.isEmpty {
            self.resetPassword(email: self.txtEmail.text ?? "")
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    func validation(email: String) -> String {
        
        if email.isEmpty {
            return STRING.errorEmail
        }else if !Validation.isValidEmail(email) {
            return STRING.errorValidEmail
        } else {
            return ""
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}


//MARK:- Extension for Forgot Password Function
extension ForgotPasswordVC {
    
    func resetPassword(email:String){
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email){
            error in
            
                Alert.shared.showAlert(message: "resest link", completion: nil)
        }
    }
//    func checkUser(email:String) {
//
//        _ = AppDelegate.shared.db.collection(rUser).whereField(rEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
//
//            guard let snapshot = querySnapshot else {
//                print("Error fetching snapshots: \(error!)")
//                return
//            }
//
//            if snapshot.documents.count != 0 {
//                if let vc = UIStoryboard.main.instantiateViewController(withClass: ResetPasswordVC.self){
//                    vc.email = snapshot.documents[0].documentID
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            }else{
//                if !self.flag {
//                    Alert.shared.showAlert(message: "Please check your email !!!", completion: nil)
//                    self.flag = true
//                }
//            }
//        }
//
//    }
}
