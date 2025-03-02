//
//  CoinTableViewCell.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 02/03/25.
//

import UIKit
import Charts

class CoinTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var coinImg: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var coinRankLbl: UILabel!
    @IBOutlet weak var coinTitleLbl: UILabel!
    @IBOutlet weak var coinSubTitleLbl: UILabel!
    @IBOutlet weak var coinPriceLbl: UILabel!
    @IBOutlet weak var coinSubPriceLbl: UILabel!
    @IBOutlet weak var coinVolumeLbl: UILabel!
    @IBOutlet weak var volImg: UIImageView!
    

    override class func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func addBottomShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.6
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
    }

}
