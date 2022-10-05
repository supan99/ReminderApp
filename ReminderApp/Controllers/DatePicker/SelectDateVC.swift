//
//  SelectDateVC.swift
//  ApolloHealth
//
//  Created by 2021M05 on 29/06/22.
//

import UIKit

class SelectDateVC: UIViewController {

    //MARK: Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var vwBack: UIView!
    
    
    //MARK: Class Variable
    var selectionCompletion : ((_ selectedDate: String) -> Void) = { _ in }
    var dateFromSelection = ""
    
    //MARK: Custom Method
    
    func setUpView(){
        self.applyStyle()
        
        self.datePicker.minimumDate = Date()
        self.setDate()
    }
    
    func setDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MMM-yyyy"

        if let date = dateFormatter.date(from: dateFromSelection) {
            datePicker.date = date
        }
    }
    
    func applyStyle(){
        self.lblTitle.font = UIFont.customFont(ofType: .bold, withSize: 17)
        self.lblTitle.textColor = .black
        self.vwBack.roundCorners([.topLeft,.topRight], radius: 25)
    }
    
    //MARK: Action Method
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        print(self.datePicker.date)
        let selectedDate = self.datePicker.date.dateFormatted
        self.dismiss(animated: true) {
            self.selectionCompletion(selectedDate)
        }
    }
    
    //MARK: Delegates
    
    //MARK: UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setUpView()
        }
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }

}
