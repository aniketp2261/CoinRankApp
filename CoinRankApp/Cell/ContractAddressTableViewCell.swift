//
//  ContractAddressTableViewCell.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 02/03/25.
//

import UIKit

class ContractAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var copyBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
