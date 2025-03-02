//
//  WelcomeViewController.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 01/03/25.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var termsLbl: UILabel!
    @IBOutlet weak var startedBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        termsLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsClick)))
    }
    
    @objc func termsClick(){
        let alertController = UIAlertController(title: "Terms & Conditions", message: "By tapping accept, you agree to Terms of Sevice and Privacy Policy.", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (_) in
            print("You clicked Accept!")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("You clicked Cancel!")
        }
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getStartedClick(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarketViewController") as? MarketViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
