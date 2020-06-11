//
//  Coin.swift
//  ByteCoin
//
//  Created by Nadeem Ansari on 6/11/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel: Codable {
     let asset_id_base: String
     let asset_id_quote: String
     let rate: Double
}
