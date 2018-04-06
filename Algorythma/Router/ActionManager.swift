//
//  ActionManager.swift
//  mahishopping
//
//  Created by Amit Mishra on .
//  Copyright © 2017 Lenskart. All rights reserved.
//

import Foundation
import UIKit
enum ErrorActionType {
    case Alert, None
}
class ActionParams: NSObject {
    
    
}
class MovieListParam: ActionParams {
    var movies : [MoviesModel]?
}

enum RedirectionTypes {
    case Login, Search
    
    func title() -> String {
        var title = ""
        switch self {
        case .Login:
            title = "ABOUT US"
            break
        case .Search:
            title = "Search Result"
            break
            
        }
        return title
    }
    
}
class ActionManager: NSObject {
    
    class func performAction(redirectionType: RedirectionTypes?, actionParams: ActionParams? = nil, sourceController: AnyObject?, completionHandler: ((AnyObject) -> Void)? = nil) {
        if let redirectionType = redirectionType {
            switch redirectionType {
            case .Search:
                performMovieListAction(actionParams:actionParams, sourceController: sourceController)
                break

            default:
                break
            }
        }
}
    private class func performMovieListAction(actionParams: ActionParams?, sourceController: AnyObject?) {
        if let viewController = sourceController as? ViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVc:MovieListing? = storyboard.instantiateViewController(withIdentifier: "MovieListing") as? MovieListing
            if let mlVC = newVc {
                mlVC.dataSource = ((actionParams as? MovieListParam)?.movies)!
                let navController =  viewController.navigationController
                navController?.pushViewController(mlVC, animated: true)
            }
        }
    }
    
class func showNoResult(pageType: PageType, sourceController: UIViewController? = nil) {
    if (sourceController as? RxBaseVC)?.noresultVC == nil {
        var message = "No results."
        var imageName = "icon_search-min"
        var hideShopNow = true
        switch pageType {
       

        case .Designer:
            message = "No data available now. Please try again later."
            imageName = "icon_search-min"
            hideShopNow = false
        default:
            break
        }
        let storyboard :UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NoResultVC")
        let newVc:NoResultVC? = viewController as? NoResultVC
        if let noResultVC = newVc {
            sourceController?.addChildViewController(noResultVC)
            noResultVC.view.frame = sourceController?.view.bounds ?? CGRect.zero
            sourceController?.view.addSubview(noResultVC.view)
            noResultVC.setText(lableTxt: message, hideShopNowButton: hideShopNow, imageName: imageName)
            (sourceController as? RxBaseVC)?.noresultVC = noResultVC
            noResultVC.didMove(toParentViewController: sourceController)
        }
    }
}

class func removeNoResult(pageType: PageType, sourceController: UIViewController? = nil) {
    if let noResultVC = (sourceController as? RxBaseVC)?.noresultVC {
        noResultVC.view.removeFromSuperview()
        noResultVC.removeFromParentViewController()
        (sourceController as? RxBaseVC)?.noresultVC = nil
    }
}
   
}



//
enum PageType {
    case  Search, Designer
}
