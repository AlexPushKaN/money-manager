import Foundation

enum ListSymbolsAndNamesCurrency: String, CaseIterable {

    case AED
    case AFN
    case ALL
    case AMD
    case ANG
    case AOA
    case ARS
    case AUD
    case AWG
    case AZN
    case BAM
    case BBD
    case BDT
    case BGN
    case BHD
    case BIF
    case BMD
    case BND
    case BOB
    case BRL
    case BSD
    case BTC
    case BTN
    case BWP
    case BYN
    case BYR
    case BZD
    case CAD
    case CDF
    case CHF
    case CLF
    case CLP
    case CNH
    case CNY
    case COP
    case CRC
    case CUC
    case CUP
    case CVE
    case CZK
    case DJF
    case DKK
    case DOP
    case DZD
    case EEK
    case EGP
    case ERN
    case ETB
    case EUR
    case FJD
    case FKP
    case GBP
    case GEL
    case GGP
    case GHS
    case GIP
    case GMD
    case GNF
    case GTQ
    case GYD
    case HKD
    case HNL
    case HRK
    case HTG
    case HUF
    case IDR
    case ILS
    case IMP
    case INR
    case IQD
    case IRR
    case ISK
    case JEP
    case JMD
    case JOD
    case JPY
    case KES
    case KGS
    case KHR
    case KMF
    case KPW
    case KRW
    case KWD
    case KYD
    case KZT
    case LAK
    case LBP
    case LKR
    case LRD
    case LSL
    case LYD
    case MAD
    case MDL
    case MGA
    case MKD
    case MMK
    case MNT
    case MOP
    case MRO
    case MRU
    case MTL
    case MUR
    case MVR
    case MWK
    case MXN
    case MYR
    case MZN
    case NAD
    case NGN
    case NIO
    case NOK
    case NPR
    case NZD
    case OMR
    case PAB
    case PEN
    case PGK
    case PHP
    case PKR
    case PLN
    case PYG
    case QAR
    case RON
    case RSD
    case RUB
    case RWF
    case SAR
    case SBD
    case SCR
    case SDG
    case SEK
    case SGD
    case SHP
    case SLL
    case SOS
    case SRD
    case SSP
    case STD
    case STN
    case SVC
    case SYP
    case SZL
    case THB
    case TJS
    case TMT
    case TND
    case TOP
    case TRY
    case TTD
    case TWD
    case TZS
    case UAH
    case UGX
    case USD
    case UYU
    case UZS
    case VES
    case VND
    case VUV
    case WST
    case XAF
    case XAG
    case XAU
    case XCD
    case XDR
    case XOF
    case XPD
    case XPF
    case XPT
    case YER
    case ZAR
    case ZMK
    case ZMW
    
    func getAssociatedValue() -> String {
        
        switch self {
        case .AED: return "United Arab Emirates Dirham"
        case .AFN: return "Afghan Afghani"
        case .ALL: return "Albanian Lek"
        case .AMD: return "Armenian Dram"
        case .ANG: return "Netherlands Antillean Guilder"
        case .AOA: return "Angolan Kwanza"
        case .ARS: return "Argentine Peso"
        case .AUD: return "Australian Dollar"
        case .AWG: return "Aruban Florin"
        case .AZN: return "Azerbaijani Manat"
        case .BAM: return "Bosnia-Herzegovina Convertible Mark"
        case .BBD: return "Barbadian Dollar"
        case .BDT: return "Bangladeshi Taka"
        case .BGN: return "Bulgarian Lev"
        case .BHD: return "Bahraini Dinar"
        case .BIF: return "Burundian Franc"
        case .BMD: return "Bermudan Dollar"
        case .BND: return "Brunei Dollar"
        case .BOB: return "Bolivian Boliviano"
        case .BRL: return "Brazilian Real"
        case .BSD: return "Bahamian Dollar"
        case .BTC: return "Bitcoin"
        case .BTN: return "Bhutanese Ngultrum"
        case .BWP: return "Botswanan Pula"
        case .BYN: return "Belarusian Ruble"
        case .BYR: return "Belarusian Ruble (pre-2016)"
        case .BZD: return "Belize Dollar"
        case .CAD: return "Canadian Dollar"
        case .CDF: return "Congolese Franc"
        case .CHF: return "Swiss Franc"
        case .CLF: return "Chilean Unit of Account (UF)"
        case .CLP: return "Chilean Peso"
        case .CNH: return "Chinese Yuan (Offshore)"
        case .CNY: return "Chinese Yuan"
        case .COP: return "Colombian Peso"
        case .CRC: return "Costa Rican Colón"
        case .CUC: return "Cuban Convertible Peso"
        case .CUP: return "Cuban Peso"
        case .CVE: return "Cape Verdean Escudo"
        case .CZK: return "Czech Republic Koruna"
        case .DJF: return "Djiboutian Franc"
        case .DKK: return "Danish Krone"
        case .DOP: return "Dominican Peso"
        case .DZD: return "Algerian Dinar"
        case .EEK: return "Estonian Kroon"
        case .EGP: return "Egyptian Pound"
        case .ERN: return "Eritrean Nakfa"
        case .ETB: return "Ethiopian Birr"
        case .EUR: return "Euro"
        case .FJD: return "Fijian Dollar"
        case .FKP: return "Falkland Islands Pound"
        case .GBP: return "British Pound Sterling"
        case .GEL: return "Georgian Lari"
        case .GGP: return "Guernsey Pound"
        case .GHS: return "Ghanaian Cedi"
        case .GIP: return "Gibraltar Pound"
        case .GMD: return "Gambian Dalasi"
        case .GNF: return "Guinean Franc"
        case .GTQ: return "Guatemalan Quetzal"
        case .GYD: return "Guyanaese Dollar"
        case .HKD: return "Hong Kong Dollar"
        case .HNL: return "Honduran Lempira"
        case .HRK: return "Croatian Kuna"
        case .HTG: return "Haitian Gourde"
        case .HUF: return "Hungarian Forint"
        case .IDR: return "Indonesian Rupiah"
        case .ILS: return "Israeli New Sheqel"
        case .IMP: return "Manx pound"
        case .INR: return "Indian Rupee"
        case .IQD: return "Iraqi Dinar"
        case .IRR: return "Iranian Rial"
        case .ISK: return "Icelandic Króna"
        case .JEP: return "Jersey Pound"
        case .JMD: return "Jamaican Dollar"
        case .JOD: return "Jordanian Dinar"
        case .JPY: return "Japanese Yen"
        case .KES: return "Kenyan Shilling"
        case .KGS: return "Kyrgystani Som"
        case .KHR: return "Cambodian Riel"
        case .KMF: return "Comorian Franc"
        case .KPW: return "North Korean Won"
        case .KRW: return "South Korean Won"
        case .KWD: return "Kuwaiti Dinar"
        case .KYD: return "Cayman Islands Dollar"
        case .KZT: return "Kazakhstani Tenge"
        case .LAK: return "Laotian Kip"
        case .LBP: return "Lebanese Pound"
        case .LKR: return "Sri Lankan Rupee"
        case .LRD: return "Liberian Dollar"
        case .LSL: return "Lesotho Loti"
        case .LYD: return "Libyan Dinar"
        case .MAD: return "Moroccan Dirham"
        case .MDL: return "Moldovan Leu"
        case .MGA: return "Malagasy Ariary"
        case .MKD: return "Macedonian Denar"
        case .MMK: return "Myanma Kyat"
        case .MNT: return "Mongolian Tugrik"
        case .MOP: return "Macanese Pataca"
        case .MRO: return "Mauritanian Ouguiya (pre-2018)"
        case .MRU: return "Mauritanian Ouguiya"
        case .MTL: return "Maltese Lira"
        case .MUR: return "Mauritian Rupee"
        case .MVR: return "Maldivian Rufiyaa"
        case .MWK: return "Malawian Kwacha"
        case .MXN: return "Mexican Peso"
        case .MYR: return "Malaysian Ringgit"
        case .MZN: return "Mozambican Metical"
        case .NAD: return "Namibian Dollar"
        case .NGN: return "Nigerian Naira"
        case .NIO: return "Nicaraguan Córdoba"
        case .NOK: return "Norwegian Krone"
        case .NPR: return "Nepalese Rupee"
        case .NZD: return "New Zealand Dollar"
        case .OMR: return "Omani Rial"
        case .PAB: return "Panamanian Balboa"
        case .PEN: return "Peruvian Nuevo Sol"
        case .PGK: return "Papua New Guinean Kina"
        case .PHP: return "Philippine Peso"
        case .PKR: return "Pakistani Rupee"
        case .PLN: return "Polish Zloty"
        case .PYG: return "Paraguayan Guarani"
        case .QAR: return "Qatari Rial"
        case .RON: return "Romanian Leu"
        case .RSD: return "Serbian Dinar"
        case .RUB: return "Russian Ruble"
        case .RWF: return "Rwandan Franc"
        case .SAR: return "Saudi Riyal"
        case .SBD: return "Solomon Islands Dollar"
        case .SCR: return "Seychellois Rupee"
        case .SDG: return "Sudanese Pound"
        case .SEK: return "Swedish Krona"
        case .SGD: return "Singapore Dollar"
        case .SHP: return "Saint Helena Pound"
        case .SLL: return "Sierra Leonean Leone"
        case .SOS: return "Somali Shilling"
        case .SRD: return "Surinamese Dollar"
        case .SSP: return "South Sudanese Pound"
        case .STD: return "São Tomé and Príncipe Dobra (pre-2018)"
        case .STN: return "São Tomé and Príncipe Dobra"
        case .SVC: return "Salvadoran Colón"
        case .SYP: return "Syrian Pound"
        case .SZL: return "Swazi Lilangeni"
        case .THB: return "Thai Baht"
        case .TJS: return "Tajikistani Somoni"
        case .TMT: return "Turkmenistani Manat"
        case .TND: return "Tunisian Dinar"
        case .TOP: return "Tongan Paʻanga"
        case .TRY: return "Turkish Lira"
        case .TTD: return "Trinidad and Tobago Dollar"
        case .TWD: return "New Taiwan Dollar"
        case .TZS: return "Tanzanian Shilling"
        case .UAH: return "Ukrainian Hryvnia"
        case .UGX: return "Ugandan Shilling"
        case .USD: return "United States Dollar"
        case .UYU: return "Uruguayan Peso"
        case .UZS: return "Uzbekistan Som"
        case .VES: return "Venezuelan Bolívar Soberano"
        case .VND: return "Vietnamese Dong"
        case .VUV: return "Vanuatu Vatu"
        case .WST: return "Samoan Tala"
        case .XAF: return "CFA Franc BEAC"
        case .XAG: return "Silver (troy ounce)"
        case .XAU: return "Gold (troy ounce)"
        case .XCD: return "East Caribbean Dollar"
        case .XDR: return "Special Drawing Rights"
        case .XOF: return "CFA Franc BCEAO"
        case .XPD: return "Palladium Ounce"
        case .XPF: return "CFP Franc"
        case .XPT: return "Platinum Ounce"
        case .YER: return "Yemeni Rial"
        case .ZAR: return "South African Rand"
        case .ZMK: return "Zambian Kwacha (pre-2013)"
        case .ZMW: return "Zambian Kwacha"
        }
    }
    
    func getAllNameAndSymbol() -> [String: String] {
        
        var all: [String: String] = [:]
        
        for oneOf in ListSymbolsAndNamesCurrency.allCases {
            let symbol: String = oneOf.rawValue
            var associatedValue: String = ""
            if let oneOfCases = ListSymbolsAndNamesCurrency(rawValue: symbol) {
                associatedValue = oneOfCases.getAssociatedValue()
            }
            all[symbol] = associatedValue
        }
        
        return all
    }
}
