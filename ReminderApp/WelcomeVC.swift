//
//  WelcomeVC.swift
//  ReminderApp


import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var btnLogin: PurpleThemeButton!
    @IBOutlet weak var btnSignUp: PurpleThemeButton!
    @IBOutlet weak var btnApple: PurpleThemeButton!
    
    private let socialLoginManager: SocialLoginManager = SocialLoginManager()
    
    
    @IBAction func btnClick(_ sender: UIButton){
        if sender == btnLogin {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnSignUp {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if sender == btnApple {
            self.socialLoginManager.performAppleLogin()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.socialLoginManager.delegate = self
        // Do any additional setup after loading the view.
    }
}


extension WelcomeVC: SocialLoginDelegate {
    
    func socialLoginData(data: SocialLoginDataModel) {
        print("Social Id==>", data.socialId ?? "")
        print("First Name==>", data.firstName ?? "")
        print("Last Name==>", data.lastName ?? "")
        print("Email==>", data.email ?? "")
        print("Login type==>", data.loginType ?? "")
        
    }
}
