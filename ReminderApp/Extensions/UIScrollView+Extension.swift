import UIKit

extension UIScrollView {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 11, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func addRefreshControl(withTitle: String = "", action: (() -> Void)?){
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .red
        refreshControl.attributedTitle = withTitle.getAttributedText(defaultDic: [.foregroundColor:UIColor.white,.font:UIFont.customFont(ofType: .regular, withSize: 14)], attributeDic: [.foregroundColor:UIColor.themeBlue,.font:UIFont.customFont(ofType: .regular, withSize: 14)], attributedStrings: [withTitle])
        refreshControl.addAction(for: .valueChanged) {
            if let refreshAction = action{
                refreshAction()
            }
        }
        self.refreshControl = refreshControl
    }
    
    func endRefreshing(){
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Class Variables
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}


