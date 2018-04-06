import UIKit

class NoResultVC: RxBaseVC {
    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var messageLbl: UILabel?
    @IBOutlet weak var subMessageLbl: UILabel?
    @IBOutlet weak var shopButton: UIButton?
    
    func setText(lableTxt: String? = "No results. Please try again later.", subLabelText: String? = nil, hideShopNowButton: Bool = true, imageName: String = "ic_empty_search") {
        imgView?.image = UIImage(named: imageName)
        let text = lableTxt?.uppercased()
        messageLbl?.text = text
        
        subMessageLbl?.text = subLabelText
        shopButton?.isHidden = hideShopNowButton
        shopButton?.setTitle("searchAgainW", for: UIControlState.normal)
    }
    
    @IBAction func searchAgainClicked() {
        self.navigationController?.popViewController(animated: false)
        // ActionManager.performAction(redirectionType: RedirectionTypes.OTP, sourceController: self)
    }
}

