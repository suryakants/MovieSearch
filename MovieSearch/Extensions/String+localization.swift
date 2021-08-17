import UIKit

extension String {
    
    func localize(comment: String = "") -> String {
        let localizeStr = NSLocalizedString(self, comment: "")
        return localizeStr
    }
}

