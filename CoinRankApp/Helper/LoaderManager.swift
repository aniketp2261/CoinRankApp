//
//  LoaderManager.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 02/03/25.
//

import Foundation
import UIKit

class LoaderManager {
    
    static let shared = LoaderManager()
    private let loadingView = UIView()
    private let backView = UIView()
    
    func showLoader() {
        if let topVC = UIApplication.topViewController() {
            loadingView.tag = 999
            loadingView.accessibilityIdentifier = "loading_view"
            let activityIndicatorView = UIActivityIndicatorView(style: .large)
            activityIndicatorView.color = .white
            activityIndicatorView.startAnimating()
            backView.backgroundColor = .clear
            topVC.view.addSubview(backView)
            backView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backView.leadingAnchor.constraint(equalTo: topVC.view.leadingAnchor),
                backView.trailingAnchor.constraint(equalTo: topVC.view.trailingAnchor),
                backView.topAnchor.constraint(equalTo: topVC.view.topAnchor, constant: 200),
                backView.bottomAnchor.constraint(equalTo: topVC.view.bottomAnchor, constant: -200)
            ])
            backView.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loadingView.heightAnchor.constraint(equalToConstant: 80),
                loadingView.widthAnchor.constraint(equalToConstant: 80),
                loadingView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
                loadingView.centerYAnchor.constraint(equalTo: backView.centerYAnchor)
            ])
            loadingView.addSubview(activityIndicatorView)
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicatorView.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor),
                activityIndicatorView.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor),
                activityIndicatorView.topAnchor.constraint(equalTo: loadingView.topAnchor),
                activityIndicatorView.bottomAnchor.constraint(equalTo: loadingView.bottomAnchor)
            ])
            loadingView.backgroundColor = UIColor(named: "ThemeColor")
            loadingView.layer.cornerRadius = 20
            loadingView.layer.shadowColor = UIColor.lightGray.cgColor
            loadingView.layer.shadowRadius = 2
            loadingView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            loadingView.layer.shadowOpacity = 0.2
            loadingView.layer.masksToBounds = false
            loadingView.layer.borderColor = UIColor.lightGray.cgColor
            loadingView.layer.borderWidth = 0.2
        }
    }
    
    func hideLoader() {
        if let topVC = UIApplication.topViewController(){
            topVC.view.backgroundColor = .white
            topVC.view.sendSubviewToBack(loadingView)
            loadingView.removeFromSuperview()
            backView.removeFromSuperview()
        }
    }
    
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = base as? UINavigationController {
            return topViewController(base: navigationController.visibleViewController)
        }
        
        if let tabBarController = base as? UITabBarController {
            return topViewController(base: tabBarController.selectedViewController)
        }
        
        if let presentedViewController = base?.presentedViewController {
            return topViewController(base: presentedViewController)
        }
        
        return base
    }
}
