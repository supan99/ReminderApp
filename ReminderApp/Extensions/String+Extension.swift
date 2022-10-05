//
//  UIStoryBoard+Extension.swift


import Foundation
import UIKit



extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func strChangeDateFormat(fromDateFormat : String, toDateFormat : String, type: DateConvertionType) -> String? {
        let fromDateFormatter = DateFormatter()
        let toDateFormatter = DateFormatter()
        
        fromDateFormatter.dateFormat = fromDateFormat
        toDateFormatter.dateFormat = toDateFormat
        
        return fromDateFormatter.date(from: self)?.convertDateFormat(output: toDateFormatter, type: type).0
    }
    
    /**
     To Get UIAlertAction from String
     
     - Parameter style: UIAlertAction Style
     - Parameter handler: To Handle events
     
     */
    typealias AlertActionHandlerd = ((UIAlertAction) -> Void)
    
    func addAction(style : UIAlertAction.Style  = .default , handler : AlertActionHandlerd? = nil) -> UIAlertAction{
        return UIAlertAction(title: self, style: style, handler: handler)
    }
    
    func getAttributedText ( defaultDic : [NSAttributedString.Key : Any] , attributeDic : [NSAttributedString.Key : Any]?, attributedStrings : [String]) -> NSMutableAttributedString {
        
        let attributeText : NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: defaultDic)
        for strRange in attributedStrings {
            if let range = self.range(of: strRange) {
                let startIndex = self.distance(from: self.startIndex, to: range.lowerBound)
                let range1 = NSMakeRange(startIndex, strRange.count)
                attributeText.setAttributes(attributeDic, range: range1)
            }
        }
        return attributeText
    }
}



extension UIView {
    func viewStyle() {
        self.clipsToBounds = true
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    @discardableResult func shadow(color: UIColor = UIColor.black, shadowOffset : CGSize = CGSize(width: 1.0, height: 1.0) , shadowOpacity : Float = 0.5) -> Self {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.masksToBounds = false
        return self
    }
}
