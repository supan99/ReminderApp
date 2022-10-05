//
//  RemindersVC.swift
//  ReminderApp
//
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreMedia
import CoreLocation
class RemindersTVC: UITableViewCell {
    //MARK: Outlet
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblDayValue: UILabel!
    @IBOutlet weak var lblMonthAndYearValue: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    //MARK: Class Variable
    
    //MARK: Custom Method
    
    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
        self.vwBack.layer.cornerRadius = 12
        self.vwBack.shadow()
        
        self.lblDayValue.font = UIFont.customFont(ofType: .bold, withSize: 44)
        self.lblDayValue.textColor = UIColor.hexStringToUIColor(hex: "#6d579f")
        self.lblMonthAndYearValue.font = UIFont.customFont(ofType: .semiBold, withSize: 14)
        self.lblTitle.font = UIFont.customFont(ofType: .bold, withSize: 18)
        self.lblDescription.font = UIFont.customFont(ofType: .regular, withSize: 16)
        self.lblDescription.textColor = UIColor.gray
    }
    
    //MARK: Action Method
    func configCell(data: ReminderModel) {
        self.lblTitle.text = data.title.description
        self.lblDescription.text = data.notes.description
        self.lblDayValue.text = data.date.dropLast(8).description
        self.lblMonthAndYearValue.text = GFunction.shared.getDate(date: data.date)?.dateFormattedReminder
    }
    //MARK: Delegates
    
    //MARK: UILifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
}

class RemindersVC: UIViewController {

    //MARK: Outlet
    @IBOutlet weak var tblReminders: UITableView!
    
    //MARK: Class Variable
    var array = [ReminderModel]()
    
    
    //MARK: Custom Method
    
    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
        
    }
    
    //MARK: Action Method
    @IBAction func btnNotificationTapped(_ sender: UIButton) {
        let nextVC = NotificationVC.instantiate(fromAppStoryboard: .main)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Delegates
    
    //MARK: UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.getData()
        self.navigationController?.navigationBar.isHidden = true
    }
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }

}

extension RemindersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemindersTVC") as! RemindersTVC
        cell.configCell(data: self.array[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, tapped in
            
            let actionYes = "Yes".addAction(style: .default, handler: { (action) in
                print(self.array[indexPath.row].id)
                self.removeData(id: self.array[indexPath.row].id)
            })
            let actionNo = "No".addAction(style: .cancel, handler: nil)
            UIAlertController.Style.alert.showAlert(title: "", message: "Are you sure you want to delete?", actions: [actionYes , actionNo])
        }
        let action = UISwipeActionsConfiguration(actions: [delete])
        return action
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { action, view, tapped in
            if let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AddReminderVC") as? AddReminderVC {
                nextVC.isEditMode = true
                nextVC.editData = self.array[indexPath.row]
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        let action = UISwipeActionsConfiguration(actions: [edit])
        
        edit.backgroundColor = UIColor.blue
        return action
    }
    
    func getRadiusData(dataReminder: ReminderModel) {
        
        let data = LocationManager.shared.getUserLocation().coordinate
        
        
        let someOtherLocation: CLLocation = CLLocation(latitude: dataReminder.lat,
                                                       longitude: dataReminder.lng)
        

        let distanceInMeters: CLLocationDistance = CLLocation(latitude: data.latitude, longitude: data.longitude).distance(from: someOtherLocation)
        
        if distanceInMeters < 1000 {
            self.emailSend(email: GFunction.user.email, name: GFunction.user.name)
        }
    }
    
    
    func getData(){
        
        Firestore.firestore().collection(rReminder).document(FirebaseAuth.Auth.auth().currentUser?.uid ?? "").collection("userReminders").addSnapshotListener{querySnapshot , error in
            
            guard let snapshot = querySnapshot else {
                print("Error")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[rTitle] as? String, let date: String = data1[rDate] as? String, let notes: String = data1[rDescription] as? String, let address: String = data1[rAddress] as? String, let location = data1[rLocation] as? GeoPoint {
                       
                        
                        print("Data Count : \(self.array.count)")
//                        let lat = location["longitude"] as! Double
                        let remData = ReminderModel( id: data.documentID, title: name, date: date, notes: notes,location: address, lat: location.latitude, lng: location.longitude)
                        self.array.append(remData)
                        self.getRadiusData(dataReminder: remData)
                    }
                    self.tblReminders.delegate = self
                    self.tblReminders.dataSource = self
                    self.tblReminders.reloadData()
                    
                }
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
    func removeData(id: String){
        let ref =  Firestore.firestore().collection(rReminder).document(FirebaseAuth.Auth.auth().currentUser?.uid ?? "").collection("userReminders").document(id)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                self.getData()
            }
        }
    }
    
    func emailSend(email: String, name:String){
        self.sendEmail( email: email, name:name){ [unowned self] (result) in
            DispatchQueue.main.async {
                switch result{
                    case .success(_):
                        break;
                    case .failure(_):
                        Alert.shared.showAlert(message: "Error", completion: nil)
                }
            }
            
        }
    }
    
    func sendEmail(email: String, name:String, completion: @escaping (Result<Void,Error>) -> Void) {
        let apikey = "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"
        let devemail = "vinithkumar42@gmail.com"
        
        let data : [String:String] = [
            "name": name,
            "email": email
        ]
        
        
        let personalization = TemplatedPersonalization(dynamicTemplateData: data, recipients: email)
        let session = Session()
        session.authentication = Authentication.apiKey(apikey)
        
        let from = Address(email: devemail, name: "ReminderApp")
        let template = Email(personalizations: [personalization], from: from, templateID: "d-e560615afd9a459ea221cabe9fd50faf", subject: "Remind your tasks!!!")
        
        do {
            try session.send(request: template, completionHandler: { (result) in
                switch result {
                    case .success(let response):
                        print("Response : \(response)")
                        completion(.success(()))
                        
                    case .failure(let error):
                        print("Error : \(error)")
                        completion(.failure(error))
                }
            })
        }catch(let error){
            print("ERROR: ")
            completion(.failure(error))
        }
    }
}
        
       


//Bold Title Lable
class NavTitleLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.customFont(ofType: .semiBold, withSize: 32)
        self.textColor = UIColor.hexStringToUIColor(hex: "#1F1F1F")
    }
}


