import Foundation

class DataHandler {
    
    var data: DataFromNetwork

    init(data: DataFromNetwork) {
        self.data = data
    }
    
    func get(inputInformation: CurrencyInformation, settlementСurrency: ListSymbolsAndNamesCurrency) -> CurrencyInformation {
        
        let outputInformation: CurrencyInformation = CurrencyInformation(currencySymbol: inputInformation.currencySymbol,
                                                                         currencyName: inputInformation.currencyName,
                                                                         statusInListOfCurrencies: inputInformation.statusInListOfCurrencies)
        let oldInformation = ListOfCurrencies.loadInformation()
        let rateBaseCurrency: Double = data.rates[settlementСurrency.rawValue] ?? 1.0

        for rate in data.rates {
            if rate.key == inputInformation.currencySymbol {
                outputInformation.currencyPrice = rate.key == settlementСurrency.rawValue ? rate.value.rounded(toPlaces: 2) : (1/*$*/ / rate.value * rateBaseCurrency).rounded(toPlaces: 2)
                if let currencyPrice = outputInformation.currencyPrice {
                    outputInformation.currencyPriceDeviation = getPriceDeviationCurrency(symbol: rate.key, newPriceCurrency: currencyPrice, oldInformation: oldInformation)
                }
            }
        }
        
        return outputInformation
    }
    
    private func getPriceDeviationCurrency(symbol: String, newPriceCurrency: Double, oldInformation: ListOfCurrencies?) -> Double {

        var priceDeviationCurrency: Double = 0.0
        var index: Int = 0
        
        if let oldInformation = oldInformation {
            while index <= oldInformation.all.count - 1 {
                if symbol == oldInformation.all[index].currencySymbol {
                    if let oldPriceCurrency = oldInformation.all[index].currencyPrice {
                        priceDeviationCurrency = (newPriceCurrency - oldPriceCurrency) / oldPriceCurrency * 100
                    }
                    break
                }
                index += 1
            }
        }
        return priceDeviationCurrency.rounded(toPlaces: 2)
    }
}
