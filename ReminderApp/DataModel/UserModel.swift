//
//  UserModel.swift
//  ReminderApp


import Foundation
class UserModel {
    var docID: String
    var name: String
    var email: String
    var phone: String
    var profileImage: String
    
    
    init(docID: String,name: String,email: String, phone: String, profileImage: String) {
        self.docID = docID
        self.email = email
        self.name = name
        self.phone = phone
        self.profileImage = profileImage
    }
}
