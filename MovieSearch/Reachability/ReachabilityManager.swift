import Foundation

protocol updateNetworkReachibility {
    func updateNetworkAvilable()
    func updateNetworkNotAvilable()
}

class ReachabilityManager: NSObject {
    var isNetworkWorking = false
    var isOverCellular = false
    var reachability = Reachability()
    var delegateNetworkReachibility: updateNetworkReachibility?
    
    class var sharedInstance: ReachabilityManager {
        struct Singleton {
            static let networkOperations = ReachabilityManager()
        }
        return Singleton.networkOperations
    }
    
    override init() {
        super.init()
    }
     func allocRechability() {
        let name = NSNotification.Name(rawValue: "ReachabilityNotification")
         NotificationCenter.default.addObserver(self, selector: #selector(ReachabilityManager.reachabilityChanged(_:)), name: name, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
        // Initial reachability check
        if let reach = reachability {
            if reach.isReachable {
                updateWhenReachable(reach)
            } else {
                updateWhenNotReachable(reach)
            }
        }
    }
 
    func updateWhenReachable(_ reachability: Reachability) {
        self.setCellularDataFlags(reachability)
        self.isNetworkWorking = true
        if nil != delegateNetworkReachibility {
            delegateNetworkReachibility?.updateNetworkAvilable()
        }
    }
    
    func updateWhenNotReachable(_ reachability: Reachability) {
        self.isNetworkWorking = false
        // change me
        //the notification must be send from Reachability.swift to AuthenticationManager.swift
       // NSNotificationCenter.defaultCenter().postNotificationName(N_NetRechability, object:nil)
        if nil != delegateNetworkReachibility {
            delegateNetworkReachibility?.updateNetworkNotAvilable()
        }
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        if let reachability = note.object as? Reachability {
            if reachability.isReachable {
                self.isNetworkWorking = true
            } else {
                self.isNetworkWorking = false
            }
            self.setCellularDataFlags(reachability)
            
            NotificationCenter.default.post(name: NSNotification.Name(ReachabilityConstant.reachabilityChange), object: reachability)
        }

    }
    
    func setCellularDataFlags(_ reachability: Reachability) {
        if reachability.isReachableViaWiFi {
            self.isOverCellular = false
        } else {
            self.isOverCellular = true
        }
    }
    func checkNetReachability() -> (error: NSError, isNetworkAvilable: Bool) {
        let error = NSError(domain: ReachabilityConstant.errorDomain, code: ReachabilityConstant.networkReachability, userInfo: [NSLocalizedDescriptionKey: "Network unavailable!"])
        return  (error, self.isNetworkWorking)
    }
}
