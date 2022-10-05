//
//  SendAlertVC.swift
//  ReminderApp


import UIKit

class SendAlertVC: UIViewController {

    
    @IBOutlet weak var tvSendMessage: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBAction func btnClick(_ sender: UIButton) {
        let error = self.validation()
        if error.isEmpty {
            self.sendData(data: self.tvSendMessage.text.trim(), date: GFunction.shared.UTCToDateFormat(date: Date()))
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    func validation() -> String {
        if tvSendMessage.text.trim().isEmpty {
            return "Please enter message"
        }
        
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    
    func sendData(data: String, date: String){
        Firestore.firestore().collection(rNotification).addDocument(data: [rMessage: data,
                                                                              rDate: date], completion: { (error) in
            if error != nil {
                print("ERROR")
            }else{
                Alert.shared.showAlert(message: "Notification has been sent successfully to all users !!!") { Bool in
                    if Bool {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        })
    }
}
