
import UIKit

extension UITextField {
    func configure(with placeholder: String) {
        backgroundColor = UIColor.TrackerColor.background
        
        self.placeholder = placeholder
        font = UIFont.TrackerFont.regular17
        textColor = UIColor.TrackerColor.black
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.height))
        leftViewMode = .always
        clearButtonMode = .whileEditing
        returnKeyType = .go
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}

