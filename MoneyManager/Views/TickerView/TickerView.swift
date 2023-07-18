import UIKit

class TickerView: UIView {
    
    var labels: [UIView] = []
    var maxWidhtLabel: CGFloat = 0.0
    let delayAnimationLabelConst = 5.0
    var endPointXForAnimation: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func create(labelsForTicker: ListOfCurrencies) {
        
        maxWidhtLabel = 0.0
        endPointXForAnimation = 0.0
        
        for label in labelsForTicker.all {
            labels.append(getLabel(with: label.currencySymbol,
                                   with: label.currencyName,
                                   with: label.currencyPrice ?? 0.0,
                                   with: label.currencyPriceDeviation ?? 0.0))
        }
        
        subviews.forEach{ $0.removeFromSuperview() }
    }
    
    private func getLabel(with symbol: String, with nameCurrency: String, with priceCurrency: Double, with priceDeviationCurrency: Double) -> UIView {
        
        var infoView: UIView = UIView()
        let nameLabel = UILabel()
        let symbolLabel = UILabel()
        let priceLabel = UILabel()
        let priceDeviationLabel = UILabel()
        var imageView = UIImageView()
        
        symbolLabel.text = "  " + symbol + ": "
        symbolLabel.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        symbolLabel.sizeToFit()
        
        nameLabel.text = nameCurrency
        nameLabel.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        nameLabel.sizeToFit()
        nameLabel.frame.origin.x = symbolLabel.bounds.maxX

        priceLabel.text = " " + String(priceCurrency) + " "
        priceLabel.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        priceLabel.sizeToFit()
        priceLabel.frame.origin.x = nameLabel.frame.maxX
        
        priceDeviationLabel.text = " " + String(priceDeviationCurrency) + "%"
        priceDeviationLabel.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        priceDeviationLabel.sizeToFit()
        priceDeviationLabel.frame.origin.x = priceLabel.frame.maxX
        
        if priceDeviationCurrency > 0.0 {
            let upImage = UIImage(systemName: "chart.line.uptrend.xyaxis")
            imageView = UIImageView(image: upImage)
            imageView.tintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        } else if priceDeviationCurrency < 0.0 {
            let upImage = UIImage(systemName: "chart.line.downtrend.xyaxis")
            imageView = UIImageView(image: upImage)
            imageView.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else if priceDeviationCurrency == 0.0 {
            let upImage = UIImage(systemName: "chart.line.flattrend.xyaxis")
            imageView = UIImageView(image: upImage)
            imageView.tintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        }
        imageView.frame.origin.x = priceDeviationLabel.frame.maxX
        
        let widthInfoView = symbolLabel.bounds.width + nameLabel.bounds.width + priceLabel.bounds.width + priceDeviationLabel.bounds.width + imageView.bounds.width
        
        endPointXForAnimation += widthInfoView
        
        if maxWidhtLabel < widthInfoView {
            maxWidhtLabel = widthInfoView
        }
        
        infoView = UIView(frame: CGRect(x: frame.width,
                                        y: self.bounds.height / 2 - nameLabel.bounds.height / 2,
                                        width: widthInfoView,
                                        height: frame.height / 2))
        
        infoView.addSubview(symbolLabel)
        infoView.addSubview(nameLabel)
        infoView.addSubview(priceLabel)
        infoView.addSubview(priceDeviationLabel)
        infoView.addSubview(imageView)

        return infoView
    }

    func animateTicker() {

        var delay: CGFloat = 0.0
        var delayAnimation: CGFloat = 0.0
        
        for (index, label) in labels.enumerated() {

            addSubview(label)
            
            label.frame.origin.x = frame.width

            if label.bounds.width == maxWidhtLabel, index > 0 {
                delayAnimation = delayAnimationLabelConst
            } else {
                delayAnimation = label.frame.width / maxWidhtLabel * delayAnimationLabelConst
            }
            
            let duration = delayAnimationLabelConst * CGFloat(labels.count)
 
            UIView.animate(withDuration: duration, delay: delay, options: [.repeat,.curveLinear]) {
                label.frame.origin.x = -self.endPointXForAnimation
            }

            delay += delayAnimation /*замедлим поток на сек*/ + 0.8
        }
    }
}
