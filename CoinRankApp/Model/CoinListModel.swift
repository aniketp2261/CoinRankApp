//
//  CoinListModel.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 02/03/25.
//

import Foundation

// MARK: - CoinListModel
struct CoinListModel: Codable {
    var status: String?
    var data: CoinListData?
}

// MARK: - CoinListData
struct CoinListData: Codable {
    var stats: Stats?
    var coins: [Coin]?
}

// MARK: - Coin
struct Coin: Codable {
    var uuid, symbol, name, color: String?
    var iconURL: String?
    var marketCap, price: String?
    var listedAt: Int?
    var change: String?
    var rank: Int?
    var sparkline: [String]?
    var lowVolume: Bool?
    var coinrankingURL: String?
    var the24HVolume, btcPrice: String?
    var contractAddresses: [String]?
    var tier: Int?

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color
        case iconURL = "iconUrl"
        case marketCap, price, listedAt, change, rank, sparkline, lowVolume
        case coinrankingURL = "coinrankingUrl"
        case the24HVolume = "24hVolume"
        case btcPrice, contractAddresses, tier
    }
}

// MARK: - Stats
struct Stats: Codable {
    var total, totalCoins, totalMarkets, totalExchanges: Int?
    var totalMarketCap, total24HVolume: String?

    enum CodingKeys: String, CodingKey {
        case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
        case total24HVolume = "total24hVolume"
    }
}
