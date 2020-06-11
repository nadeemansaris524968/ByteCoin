//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func coinManager(_ manager: CoinManager, didUpdateCoinPrice coin: CoinModel)
    func coinManager(_ manager: CoinManager, didFailWithError error: Error)
}

struct CoinManager {
    
    private let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    private let queryAPIKEY = "apikey"
    private let apiKey = "26E14B1E-C190-4E98-B034-810E3E83548B"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let finalURL = "\(baseURL)/\(currency)?\(queryAPIKEY)=\(apiKey)"
        performRequest(using: finalURL)
    }
    
    private func performRequest(using url: String) {
        guard let url = URL(string: url) else { return }
        let urlSession = URLSession(configuration: .default)
        let urlSessionTask = urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                guard let error = error else { return }
                print(error)
                return
            }
            guard let safeData = data else { return }
            guard let decodedCoin = self.parseJSON(data: safeData) else { return }
            self.delegate?.coinManager(self, didUpdateCoinPrice: decodedCoin)
        }
        urlSessionTask.resume()
    }
    
    private func parseJSON(data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        var decodedCoin: CoinModel?
        do {
            decodedCoin = try decoder.decode(CoinModel.self, from: data)
        } catch {
            delegate?.coinManager(self, didFailWithError: error)
        }
        return decodedCoin
    }
    
}
