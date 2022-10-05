//
//  AddReminderVC.swift
//  ReminderApp
//
//

import UIKit
import MaterialComponents
import FirebaseFirestore
import FirebaseAuth
import GoogleMaps


class AddReminderVC: UIViewController {

    //MARK: Outlet
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtTitle: UIView!
    @IBOutlet weak var txtLocation: UIView!

    @IBOutlet weak var txtNotes: UIView!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var currentLocationMarker: UIImageView!
    
    //MARK: Class Variable
    var selectedDate = ""
    var textField = MDCOutlinedTextField()
    var textFieldLocation = MDCOutlinedTextField()
    var textArea = MDCOutlinedTextArea()
    var isEditMode = false
    var editData: ReminderModel?
    var selectedLocation = CLLocationCoordinate2D()
    var address = ""
    
    
    //MARK: Custom Method
    
    func setUpView(){
        self.applyStyle()
        self.mapView.delegate = self
        self.perform(#selector(self.setCurrentLocation), with: nil, afterDelay:1.0)
        
    }
    
    // Set Current Location
    @objc func setCurrentLocation()
    {
    
    var data = LocationManager.shared.getUserLocation().coordinate
    if isEditMode {
        data.latitude = editData!.lat
        data.longitude = editData!.lng
    }
    
    self.selectedLocation = data
    self.mapView.camera = GMSCameraPosition(target: self.selectedLocation, zoom: 15, bearing: 0, viewingAngle: 0)
        self.getLocationAddressFromLatLong(position: self.selectedLocation)
    }
    
    func applyStyle(){
        if isEditMode {
            self.lblDate.text = self.editData?.date.strChangeDateFormat(fromDateFormat: DateTimeFormater.ddmmyyyyWithoutSpace.rawValue, toDateFormat: DateTimeFormater.yyyymmdd.rawValue, type: .noconversion) ?? ""
            
            self.selectedDate = self.editData?.date ?? ""
        }
        
        txtTitle.removeAllSubviews()
        let estimatedFrame = self.txtTitle.bounds
        self.textField = MDCOutlinedTextField(frame: estimatedFrame)
        self.textField.label.text = "Title"
        self.textField.placeholder = "Enter title"
        self.textField.setFloatingLabelColor(UIColor.hexStringToUIColor(hex: "#735fa6"), for: .editing)
        self.textField.sizeToFit()
        if isEditMode {
            self.textField.text = self.editData?.title
        }
        txtTitle.insertSubview(self.textField, at: 0)
        
        txtLocation.removeAllSubviews()
        let estimatedFrameLocationn = self.txtLocation.bounds
        self.textFieldLocation = MDCOutlinedTextField(frame: estimatedFrameLocationn)
        self.textFieldLocation.text = self.address
        self.textFieldLocation.label.text = "Location"
        self.textFieldLocation.placeholder = "Select location"
        self.textFieldLocation.delegate = self
        self.textFieldLocation.setFloatingLabelColor(UIColor.hexStringToUIColor(hex: "#735fa6"), for: .editing)
        self.textFieldLocation.sizeToFit()
        if isEditMode {
            self.textFieldLocation.text = self.editData?.title
        }
        
        txtLocation.insertSubview(self.textFieldLocation, at: 0)
        
        txtNotes.removeAllSubviews()
        let estimatedFrameTV = self.txtNotes.bounds
        self.textArea = MDCOutlinedTextArea(frame: estimatedFrameTV)
        self.textArea.setFloatingLabel(UIColor.hexStringToUIColor(hex: "#735fa6"), for: .editing)
        self.textArea.placeholder = "Enter notes"
        self.textArea.label.text = "Notes"
        self.textArea.textView.text = ""
        self.textArea.sizeToFit()
        if isEditMode {
            self.textArea.textView.text = self.editData?.notes
        }
        txtNotes.insertSubview(self.textArea, at: 0)
    }
    
    func validation(date: String, title: String, description: String) -> String {
        if date.isEmpty {
            return "Please select reminder date"
        }else if title.isEmpty {
            return "Please enter title"
        }else if description.isEmpty {
            return "Please enter description"
        }
        return ""
    }
    
    
    //MARK: Action Method
    
    @IBAction func btnSelectDateTapped(_ sender: Any) {
        let nextVC = UIStoryboard.main.instantiateViewController(withIdentifier: "SelectDateVC") as! SelectDateVC
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.selectionCompletion = { selectedDate in
            self.selectedDate =  selectedDate.strChangeDateFormat(fromDateFormat: DateTimeFormater.yyyymmdd.rawValue, toDateFormat: DateTimeFormater.ddmmyyyyWithoutSpace.rawValue, type: .noconversion) ?? ""
            self.lblDate.text = selectedDate
        }
        self.present(nextVC, animated: true)
    }
    
    @IBAction func btnBackTapped(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddReminderTapped(sender: UIButton) {
        let error = self.validation(date: self.selectedDate, title: self.textField.text ?? "", description: self.textArea.description)
        
        if error.isEmpty {
            if isEditMode {
                self.updateReminder(date: self.selectedDate, title: self.textField.text ?? "", description: self.textArea.textView.text, id: self.editData?.id ?? "", address: self.textFieldLocation.text ?? "")
            }else{
                self.addReminder(date: self.selectedDate, title: self.textField.text ?? "", description: self.textArea.textView.text,address: self.textFieldLocation.text ?? "")
            }
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    //MARK: Delegates
    
    //MARK: UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    
    func addReminder(date: String, title: String, description: String, address: String) {
        
        let dataGeo = GeoPoint(latitude: self.selectedLocation.latitude, longitude: self.selectedLocation.longitude)
        
        Firestore.firestore().collection(rReminder).document(FirebaseAuth.Auth.auth().currentUser?.uid ?? "").collection("userReminders").addDocument(data: [
            rTitle: title,
            rDescription : description,
            rDate: date,
            rLocation : dataGeo,
            rAddress: address
        ]){
          err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func updateReminder(date: String, title: String, description: String,id: String, address: String) {
        let ref =  Firestore.firestore().collection(rReminder).document(FirebaseAuth.Auth.auth().currentUser?.uid ?? "").collection("userReminders").document(id)
        let dataGeo = GeoPoint(latitude: self.selectedLocation.latitude, longitude: self.selectedLocation.longitude)
        ref.updateData([
            rTitle: title,
            rDescription : description,
            rDate: date,
            rLocation : dataGeo,
            rAddress: address
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                Alert.shared.showAlert(message: "Your Reminder has been Updated !!!", completion: nil)
                UIApplication.shared.setTab()
            }
        }
    }

}

//MARK:- GMSMapView Delegate Method
extension AddReminderVC: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        self.selectedLocation = position.target
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.getLocationAddressFromLatLong(position: position.target)
    }
}

//MARK: Google Map Methods
extension AddReminderVC {
    func getLocationAddressFromLatLong(position: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            //
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                if let places = response?.results() {
                    if let place = places.first {
                        
                        
                        if let lines = place.lines {
                            print("GEOCODE: Formatted Address: \(lines)")
                            self.address = lines.joined(separator: ", ")
                            
                            self.textFieldLocation.text = self.address
                        }
                        
                    } else {
                        print("GEOCODE: nil first in places")
                    }
                } else {
                    print("GEOCODE: nil in places")
                }
            }
        }
    }
}

extension AddReminderVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.autocompleteClicked(textField)
        return false
    }
}

extension AddReminderVC: GMSAutocompleteViewControllerDelegate {
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.selectedLocation = place.coordinate
        self.getLocationAddressFromLatLong(position: self.selectedLocation)
        let camera = GMSCameraPosition.camera(withLatitude: self.selectedLocation.latitude, longitude: self.selectedLocation.longitude, zoom: 15);
        self.mapView.camera = camera
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
