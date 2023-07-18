import UIKit

class GraphForExpenseViewController: UIViewController {
    
    @IBOutlet weak var categoryExpensesNameLabel: UILabel!
    @IBOutlet weak var timeIntervalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var fieldForGraphsScrollView: UIScrollView!
    @IBOutlet weak var labelsForScaleOfValuesScrollView: LabelsForScaleOfValuesScrollView!
    @IBOutlet weak var labelsForScaleOfDatesScrollView: LabelsForScaleOfDatesScrollView!
    
    var categoryExpenses: CategoryExpenses?
    var allUniqueDates: Set<Date> = []
    var differenceDays: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldForGraphsScrollView.delegate = self
        
        guard let categoryExpenses = categoryExpenses else { return }
        
        categoryExpensesNameLabel.text = categoryExpenses.name
        
        allUniqueDates = Set(categoryExpenses.allExpense.map { $0.date })
        let allDates = Array(allUniqueDates).sorted(by: < )
        
        if let firstDate = allDates.first,
           let lastDate = allDates.last {
            differenceDays = PointsForGraphs.calculateDifferenceDays(beetwen: lastDate, and: firstDate) + 1
        }
        
        if differenceDays > 7 {
            customizeDisplayOfGraph(periodIndex: timeIntervalSegmentedControl.setSelectedSegment(for: .all), categoryExpenses: categoryExpenses)
            timeIntervalSegmentedControl.selectedSegmentIndex = 3
        } else {
            customizeDisplayOfGraph(periodIndex: timeIntervalSegmentedControl.setSelectedSegment(for: .week), categoryExpenses: categoryExpenses)
        }
    }
    
    private func customizeDisplayOfGraph(periodIndex: Int, categoryExpenses: CategoryExpenses) {
        
        view.backgroundColor = .expensesViewControllerColor
        
        let cellWidthAndHeight: CGFloat = 50.0
        
        let allValues: [Int] = categoryExpenses.allExpense.map { $0.value }
        
        let field = Field(heightField: fieldForGraphsScrollView.frame.height, periodIndex: periodIndex, amountOfDay: differenceDays, cellWidthAndHeight: cellWidthAndHeight)
        
        let scale = Scales(allValues: allValues, allDates: allUniqueDates, field: field)
        
        let fieldForGraphsView = FieldForGraphsView(field: field, scales: scale, labelsForScaleOfValuesScrollView: labelsForScaleOfValuesScrollView, labelsForScaleOfDatesScrollView: labelsForScaleOfDatesScrollView)
        
        if let firstDate = Array(allUniqueDates).sorted(by: > ).first {
            
            let pointsForGraphs = PointsForGraphs(startDate: firstDate, fieldForGraphs: field, cellWidthAndHeight: cellWidthAndHeight).createAndGetPoints(from: categoryExpenses.allExpense, maxValueOnValueScale: scale.values.max())
            
            drawLinesOnFieldAndAdd(pointsForGraphs: pointsForGraphs, fieldForGraphsView: fieldForGraphsView, colorLines: .lineExpense, colorPoints: (backgroundColor: .pointExpense, borderColor: .borderPointExpense))
        }
        
        fieldForGraphsScrollView.contentSize = fieldForGraphsView.frame.size
        labelsForScaleOfValuesScrollView.contentSize.height = fieldForGraphsView.frame.height
        labelsForScaleOfDatesScrollView.contentSize.width = fieldForGraphsView.frame.width
        fieldForGraphsScrollView.contentOffset.x = fieldForGraphsScrollView.contentSize.width - fieldForGraphsScrollView.frame.width
        fieldForGraphsScrollView.contentOffset.y = 50.0
        
        fieldForGraphsScrollView.addSubview(fieldForGraphsView)
        
        let fontAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]

        for index in 0..<timeIntervalSegmentedControl.numberOfSegments {
            timeIntervalSegmentedControl.setTitleTextAttributes(fontAttributes, for: UIControl.State(rawValue: UInt(index)))
        }
        
        fieldForGraphsScrollView.backgroundColor = .fieldForGraphsScrollViewColor
        fieldForGraphsScrollView.layer.cornerRadius = 10.0
        fieldForGraphsScrollView.layer.borderColor = UIColor.fieldForGraphsScrollViewColor.cgColor
        fieldForGraphsScrollView.layer.borderWidth = 5.0
        view.backgroundColor = .graphsViewControllerColor
    }
    
    @IBAction func changeTimeIntervalSegmentedControl(_ sender: UISegmentedControl) {
        removeObjectsFromSuperview()
        guard let categoryExpenses = categoryExpenses else { return }
        customizeDisplayOfGraph(periodIndex: sender.selectedSegmentIndex, categoryExpenses: categoryExpenses)
    }
    
    private func drawLinesOnFieldAndAdd(pointsForGraphs: [PointView], fieldForGraphsView: FieldForGraphsView, colorLines: UIColor, colorPoints: (backgroundColor: UIColor, borderColor: UIColor)) {
        
        guard let firstPoint = pointsForGraphs.first else { return }
        
        let linesOnFieldView = LinesOnFieldView(startPoint: firstPoint.center, lineColor: colorLines)
        
        for point in pointsForGraphs {
            linesOnFieldView.draw(on: fieldForGraphsView, nextPoint: point.center)
        }

        for pointView in pointsForGraphs {
            pointView.presentAlertDelegate = self
            pointView.setColorPoint(backgroundColor: colorPoints.backgroundColor, borderColor: colorPoints.borderColor)
            fieldForGraphsView.addSubview(pointView)
        }
    }

    private func removeObjectsFromSuperview() {
        fieldForGraphsScrollView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        labelsForScaleOfValuesScrollView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        labelsForScaleOfDatesScrollView.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}

//MARK: - UIScrollViewDelegate
extension GraphForExpenseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        labelsForScaleOfValuesScrollView.contentOffset.y = fieldForGraphsScrollView.contentOffset.y
        labelsForScaleOfDatesScrollView.contentOffset.x = fieldForGraphsScrollView.contentOffset.x
    }
}

//MARK: - PresentAlertDelegate
extension GraphForExpenseViewController: PresentAlertDelegate {
    func present(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}
