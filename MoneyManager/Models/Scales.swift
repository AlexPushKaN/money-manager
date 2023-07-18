import Foundation

class Scales {
    
    var values: [Int] = []
    var dates: [Date] = []

    init(allValues: [Int], allDates: Set<Date>, field: Field) {
        
        values = allValues.sorted(by: < )
        dates = allDates.sorted(by: < )
        
        let endValue: Int = values.removeLast()
        let step: Int = calculateStepScaleValuesFor(label: field.numberOfCellVertically, endValue: endValue)
        var value: Int = step
        values = []
        values.append(value)
        
        for _ in 2...field.numberOfCellVertically {
            value += step
            values.append(value)
        }
        
        values.sort(by: >)
        
        dates = [dates.removeFirst()]
        for _ in 1...field.numberOfCellsHorizontally {
            guard let lastDate = dates.last, let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: lastDate) else { return }
            dates.append(nextDay)
        }
        
    }
    
    private func calculateStepScaleValuesFor(label: Int, endValue: Int) -> Int {
        
        let step = endValue / label
        let numberOfZeroInStep: Int = String(step).count - 1
        let powStep = pow(10.0, Double(numberOfZeroInStep))

        for coefficient in [1,2,5,10] {
            if step < Int(powStep) * coefficient {
                return Int(powStep) * coefficient
            }
        }
        
        return step
    }
}
