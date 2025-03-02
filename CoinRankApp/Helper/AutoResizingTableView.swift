//
//  AutoResizingTableView.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 02/03/25.
//

import UIKit

class AutoResizingTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                     height: contentSize.height + adjustedContentInset.top)
    }
}
