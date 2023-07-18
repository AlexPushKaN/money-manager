import Foundation

class CurrencyInformation: Codable {
    
    var currencySymbol: String
    var currencyName: String
    var statusInListOfCurrencies: Bool
    var currencyPrice: Double?
    var currencyPriceDeviation: Double?
    
    init(currencySymbol: String, currencyName: String, statusInListOfCurrencies: Bool, currencyPrice: Double? = nil, currencyPriceDeviation: Double? = nil) {
        self.currencySymbol = currencySymbol
        self.currencyName = currencyName
        self.statusInListOfCurrencies = statusInListOfCurrencies
        self.currencyPrice = currencyPrice
        self.currencyPriceDeviation = currencyPriceDeviation
    }
}

class ListOfCurrencies: Codable {
    var settlementСurrency: Int = 0
    var all: [CurrencyInformation] = []
}
