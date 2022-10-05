

import UIKit

class NotificationTableCell : UITableViewCell {
    //MARK:- Outlet
    @IBOutlet weak var lblNotification : UILabel!
    @IBOutlet weak var vwContainer : UIView!
    
    
    //MARK:- Class Variable
    var cellData: NotificationModel = NotificationModel(content: "", createdAt: "", profileImage: ""){
        didSet{
            self.setCellData()
        }
    }
    
    //MARK:- Custom Methods
    override func awakeFromNib(){
    self.lblNotification.font = UIFont.customFont(ofType: .regular, withSize: 14)
    self.vwContainer.layer.cornerRadius = 6
    self.vwContainer.layer.borderColor = UIColor.themeBlue.cgColor
    self.vwContainer.shadow(color: UIColor.black, shadowOffset: CGSize(width: 0, height: 1), shadowOpacity: 0.06)
    }
    
    func setCellData() {
        self.lblNotification.text = cellData.content
    }
}


class NotificationVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var arrData : [NotificationModel] = []
    
    
    
    private func setUpView() {
        self.getData()
    }
    
   
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnClearClicked(_ sender: UIBarButtonItem){
        let actionYes = "Yes".addAction(style: .default, handler: { (action) in
        })
        let actionNo = "No".addAction(style: .cancel, handler: nil)
        UIAlertController.Style.alert.showAlert(title: "", message: "Are you sure you want to clear all notifications?", actions: [actionYes , actionNo])
    }
    
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tblView.updateFooterViewHeight()
    }
}

//MARK:- UITableView Delegate & DataSource Method
extension NotificationVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell") as! NotificationTableCell
        cell.cellData = self.arrData[indexPath.row]
        return cell
    }
    
    func getData() {
        self.arrData.removeAll()
        Firestore.firestore().collection(rNotification).addSnapshotListener{querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let message: String = data1[rMessage] as? String, let date: String = data1[rDate] as? String {
                        self.arrData.append(NotificationModel(content: message, createdAt: date, profileImage: ""))
                    }
                }
            }
            self.tblView.delegate = self
            self.tblView.dataSource = self
            self.tblView.reloadData()
        }
    }
}



// MARK: Web Services
extension NotificationVC {
    /**
     This api used to Notification List
          
     ### End point
     auth/notificationlist
     
     ### Method
     POST
     
     ### Required parameters
     user_type,page
     
     ### Optional parameters
     
     */
    func apiNotificaiontList(page: String) {
       
    }
}

extension UITableView {
    func updateFooterViewHeight() {
        if let footerView = self.tableFooterView {
            let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var footerFrame = footerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != footerFrame.size.height {
                footerFrame.size.height = height
                footerView.frame = footerFrame
                self.tableFooterView = footerView
            }
        }
    }
}
