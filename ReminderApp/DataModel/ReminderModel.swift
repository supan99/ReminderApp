//
//  ReminderModel.swift
//  ReminderApp


import Foundation
class ReminderModel {
    var title: String
    var date:  String
    var notes: String
    var location: String
    var lat: Double
    var lng: Double
    var id: String
    
    
    init(id: String,title:String,date: String, notes: String, location: String, lat: Double, lng: Double) {
        self.title = title
        self.date = date
        self.notes = notes
        self.id = id
        self.location = location
        self.lat = lat
        self.lng = lng
    }
}

