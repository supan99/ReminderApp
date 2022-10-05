//
//  AdminHomeVC.swift
//  ReminderApp
//
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreMedia

enum UserType {
    case Admin
    case User
}

class AdminHomeTVC: UITableViewCell {
   
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
   
    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
        self.vwBack.layer.cornerRadius = 12
        self.vwBack.shadow()
        self.lblName.font = UIFont.customFont(ofType: .bold, withSize: 18)
    }
    
    func configCell(data: UserModel) {
        self.lblName.text = data.name.description
        self.imgView.image = UIImage(named: "profileAVATAR")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
}

class AdminHomeVC: UIViewController {

    @IBOutlet weak var tblUserList: UITableView!

    var array = [UserModel]()

    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
        self.array.removeAll()
        Firestore.firestore().collection(rUser).addSnapshotListener{querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[rName] as? String, let email: String = data1[rEmail] as? String, let phone: String = data1[rPhone] as? String {
                        self.array.append(UserModel(docID: data.documentID.description, name: name, email: email, phone: phone, profileImage: ""))
                    }
                }
                self.tblUserList.delegate = self
                self.tblUserList.dataSource = self
                self.tblUserList.reloadData()
            }
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.navigationController?.navigationBar.isHidden = true
    }
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
}
extension AdminHomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminHomeTVC") as! AdminHomeTVC
        cell.configCell(data: self.array[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func btnSendAlertTapped() {
        Alert.shared.showAlert(message: "Alert sent successfully", completion: nil)
    }
}
