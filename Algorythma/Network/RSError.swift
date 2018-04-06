//
//  RSError.swift
//  mahishopping
//
//  Created by Amit Mishra on 20/12/17.
//  Copyright © 2017 Lenskart. All rights reserved.
//

import Foundation

open class RSError: NSError {
    static let networkErrorDomain = "NetworkIssue"
    static let serviceErrorDomain = "Something Went Wrong. Call to Service Failed"
    
    
    static let networkNotReachableErrorCode = -5001
    static let serviceNotReachableErrorCode = -6001
    
    
    open class func networkNotReachableError() -> RSError {
        
        let userInfo: [AnyHashable : Any] =
            [
                NSLocalizedDescriptionKey :  NSLocalizedString("None", value: "Network not reachable. Please check your Internet connection", comment: "") ,
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Call to Service Failed.Please try again", comment: "")
        ]
        return RSError(domain: networkErrorDomain , code: networkNotReachableErrorCode , userInfo: userInfo as? [String : Any])
        
        
    }
    open class func serViceNotReachableError() -> RSError {
        let userInfo: [AnyHashable : Any] =
            [
                NSLocalizedDescriptionKey :  NSLocalizedString("None", value: "Service not reachable. Please try again later", comment: "") ,
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Call to Service Failed.Please try again", comment: "")
        ]
        
        return RSError(domain: serviceErrorDomain, code: serviceNotReachableErrorCode, userInfo: userInfo as? [String : Any])
        
    }
    
    open class func errorResponseFromServer(domain: String = "Unauthorized", code:Int = 401, description:String = "No Description Availiable",statusKey : String = "None" ) -> RSError    {
        
        let userInfo: [AnyHashable : Any] =
            [
                NSLocalizedDescriptionKey :  NSLocalizedString(statusKey, value: description, comment: "") ,
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "UnKnown Error", comment: "")
        ]
        return RSError(domain: domain , code: code , userInfo: userInfo as? [String : Any])
    }
    
    
}
