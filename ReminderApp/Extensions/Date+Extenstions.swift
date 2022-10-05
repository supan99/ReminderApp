//
//  Date+Extenstions.swift
//  ReminderApp
//
//

import Foundation
extension Date {
    var dateFormatted: String {
        let formatter = DateFormatter.initWithSafeLocale(withDateFormat: DateTimeFormater.yyyymmdd.rawValue)
        return  formatter.string(from: self as Date)
    }
    
    var dateFormattedReminder: String {
        let formatter = DateFormatter.initWithSafeLocale(withDateFormat: DateTimeFormater.spacemonyyyy.rawValue)
        return  formatter.string(from: self as Date)
    }
    
    func convertDateFormat(output format: DateFormatter, type: DateConvertionType) -> (String, Date) {
        if type == .utc {
            return (format.string(from: self.convertToUTC()), self)
        } else {
            return (format.string(from: self), self.convertToLocal())
        }
    }
}

enum DateConvertionType {
    case local, utc, noconversion
}

extension Date {
    //MARK: - convert date to local
    func convertToLocal() -> Date {
        
        let sourceTimeZone = TimeZone(abbreviation: "UTC")
        let destinationTimeZone = TimeZone.current
        
        //calculate interval
        let sourceGMTOffset : Int = (sourceTimeZone?.secondsFromGMT(for: self))!
        let destinationGMTOffset : Int = destinationTimeZone.secondsFromGMT(for:self)
        let interval : TimeInterval = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: Date = Date(timeInterval: interval, since: self)
        return date
    }
    
    //MARK: - convert date to utc
    func convertToUTC() -> Date {
        
        let sourceTimeZone = TimeZone.current
        let destinationTimeZone = TimeZone(abbreviation: "UTC")
        
        //calc time difference
        let sourceGMTOffset : Int = (sourceTimeZone.secondsFromGMT(for: self))
        let destinationGMTOffset : Int = destinationTimeZone!.secondsFromGMT(for: self)
        let interval : TimeInterval = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: Date = Date(timeInterval: interval, since: self)
        return date
    }
}

extension DateFormatter {
    
    private static var dateFormatter = DateFormatter()
    
    class func initWithSafeLocale(withDateFormat dateFormat: String? = nil) -> DateFormatter {
        
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar.init(identifier: .gregorian)
        if let format = dateFormat {
            dateFormatter.dateFormat = format
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return dateFormatter
    }
}
//MARK:- Date time formater
enum DateTimeFormater : String {
    case yyyymmdd       = "yyyy-MM-dd"
    case MMM_d_Y        = "MMM d, yyyy"
    case HHmmss         = "HH:mm:ss"
    case hhmma          = "hh:mma"
    case HHmm           = "HH:mm"
    case dmmyyyy        = "d/MM/yyyy"
    case hhmmA          = "hh:mm a"
    case UTCFormat      = "yyyy-MM-dd HH:mm:ss"
    case UTCFormatWith12H      = "yyyy-MM-dd hh:mm a"
    case NodeUTCFormat  = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case ddmm_yyyy      = "dd MMM, yyyy"
    case WeekDayhhmma   = "EEE,hh:mma"
    case dmm_hhmm       = "d MMM, hh:mma"
    case ddmonyyyy      = "dd-MMM-yyyy"
    case ddmm_yyyy_hhmm = "dd MMM, yyyy. hh:mm a"
    case yyyyddmm       = "yyyy-dd-MM"
    case ddmmyyyyWithoutSpace       = "dd-MM-yyyy"
    case nameddmmyyyy        = "EEEE, dd/MM/yyyy"
    case mmmmddyyyy = "MMMM dd, yyyy"
    case ddmmyyyy        = "dd/MM/yyyy"
    case nameMMMddyyyy = "EEEE,  MMMM dd,  yyyy"
    case ddMMyyyyHHmmss      = "dd-MM-yyyy HH:mm:ss"
    case spaceddmonyyyy      = "dd MMM yyyy"
    case spacemonyyyy      = "MMM, yyyy"
    case commaddmonyyyy      = "EEE, dd MMMM yyyy"
    case customddmm_yyyy_hhmm = "dd MMM yyyy, hh:mm a"
    case customNewLineddmm_yyyy_hhmm = "dd MMM yyyy, \nhh:mm a"
}
