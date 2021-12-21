
import UIKit

extension UIView {
    var autolayoutView: Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func constrain(subview: UIView, padding: Padding) -> Self {
        UIView.constrain(subview, to: self, with: padding)
        return self
    }
    
    static func constrain(_ subview: UIView, to parent: UIView, with padding: Padding) {
        [subview.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: padding.leading),
         subview.topAnchor.constraint(equalTo: parent.topAnchor, constant: padding.top),
         subview.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -padding.trailing),
         subview.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -padding.bottom)]
            .forEach {
                $0.isActive = true
            }
    }
    
    struct Padding {
        static let zero = Padding(leading: 0, top: 0, trailing: 0, bottom: 0)
        
        let leading: CGFloat
        let top: CGFloat
        let trailing: CGFloat
        let bottom: CGFloat
    }
}
