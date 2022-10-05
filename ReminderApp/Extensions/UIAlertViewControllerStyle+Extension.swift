import Foundation
import UIKit

extension UIAlertController.Style{
    
    /**
     To Show the AlertContrller
     
     - Parameter title: Title of the AlertControler
     - Parameter message: Message to display
     - Parameter actions: Actions of the AlertController
     
     */
    func showAlert(title : String , message : String , actions : [UIAlertAction]){
        let _controller = UIAlertController(title: title, message: message, preferredStyle: self)
        actions.forEach { _controller.addAction($0) }
        UIApplication.topViewController()?.present(_controller, animated: true, completion: nil)
    }
}
