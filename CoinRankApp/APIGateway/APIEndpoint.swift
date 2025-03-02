//
//  APIEndpoint.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 02/03/25.
//

import Foundation

class APIEndpoint {
    
    //MARK: -  BASE URL
    static let Baseurl                  = "https://api.coinranking.com/v2/"
    
    //MARK: -  COIN LIST
    static let coinList                 = Baseurl + "coins"
    
    //MARK: -  COIN DETAIL
    static let coinDetail               = Baseurl + "coin/"
    
    //MARK: -  FAVORITES
    static let favoritesList            = Baseurl + "coins/favorites"
    static let favorite                 = Baseurl + "api/favorite"
    static let unfavorite               = Baseurl + "api/unfavorite"

}
