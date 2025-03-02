//
//  SplashViewController.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 01/03/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("SplashViewController")
        logoShow()
    }
    
    func logoShow(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut, .curveLinear, .transitionCurlUp], animations: {
            self.logoImg.isHidden = false
            self.logoImg.center.y -= self.logoImg.bounds.height - 80
            self.logoImg.layoutIfNeeded()
        }, completion: { complete in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
    }

}
