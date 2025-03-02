//
//  CoinDetailsModel.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 02/03/25.
//

import Foundation

// MARK: - CoinDetailsModel
struct CoinDetailsModel: Codable {
    var status: String?
    var data: CoinDetailsData?
}

// MARK: - CoinDetailsData
struct CoinDetailsData: Codable {
    var coin: CoinDetail?
}

// MARK: - CoinDetail
struct CoinDetail: Codable {
    var uuid, symbol, name, description: String?
    var color: String?
    var iconURL: String?
    var websiteURL: String?
    var links: [Link]?
    var supply: Supply?
    var the24HVolume, marketCap, fullyDilutedMarketCap, price: String?
    var btcPrice: String?
    var priceAt: Int?
    var change: String?
    var rank, numberOfMarkets, numberOfExchanges: Int?
    var sparkline: [String]?
    var allTimeHigh: AllTimeHigh?
    var coinrankingURL: String?
    var lowVolume: Bool?
    var listedAt: Int?
    var notices: [Notice]?
    var contractAddresses, tags: [String]?

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, description, color
        case iconURL = "iconUrl"
        case websiteURL = "websiteUrl"
        case links, supply
        case the24HVolume = "24hVolume"
        case marketCap, fullyDilutedMarketCap, price, btcPrice, priceAt, change, rank, numberOfMarkets, numberOfExchanges, sparkline, allTimeHigh
        case coinrankingURL = "coinrankingUrl"
        case lowVolume, listedAt, notices, contractAddresses, tags
    }
}

// MARK: - AllTimeHigh
struct AllTimeHigh: Codable {
    var price: String?
    var timestamp: Int?
}

// MARK: - Link
struct Link: Codable {
    var name: String?
    var url: String?
    var type: String?
}

// MARK: - Notice
struct Notice: Codable {
    var type, value: String?
}

// MARK: - Supply
struct Supply: Codable {
    var confirmed: Bool?
    var supplyAt: Int?
    var circulating, total, max: String?
}

