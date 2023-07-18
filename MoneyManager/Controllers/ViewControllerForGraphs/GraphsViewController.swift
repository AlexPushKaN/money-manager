import UIKit
import CoreData

class GraphsViewController: UIViewController {
    
    @IBOutlet weak var timeIntervalSegmentedControl: UISegmentedControl!
    @IBOutlet weak var fieldForGraphsScrollView: UIScrollView!
    @IBOutlet weak var labelsForScaleOfValuesScrollView: LabelsForScaleOfValuesScrollView!
    @IBOutlet weak var labelsForScaleOfDatesScrollView: LabelsForScaleOfDatesScrollView!
    
    let coreDataManager = CoreDataManager.shared
    var incomes: Incomes = Incomes(allIncome: [])
    var expenses: Expenses = Expenses(allCategoriesExpenses: [])
    var allValues: [Int] = []
    var allUniqueDates: Set<Date> = []
    var allDates: [Date] = []
    var differenceDays: Int = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fieldForGraphsScrollView.delegate = self
        
        (incomes, expenses) = CoreDataManager.uploadDataFromCoreData()
        
        allValues = getAllValues()
        allUniqueDates = getSetAllDates()
        allDates = Array(allUniqueDates).sorted(by: < )
        
        if let firstDate = allDates.first,
           let lastDate = allDates.last {
            differenceDays = PointsForGraphs.calculateDifferenceDays(beetwen: lastDate, and: firstDate) + 1
        }
        
        if differenceDays > 7 {
            customizeDisplayOfGraph(periodIndex: timeIntervalSegmentedControl.setSelectedSegment(for: .all), differenceDays: differenceDays)
            timeIntervalSegmentedControl.selectedSegmentIndex = 3
        } else if allDates.count > 0 {
            customizeDisplayOfGraph(periodIndex: timeIntervalSegmentedControl.setSelectedSegment(for: .week), differenceDays: differenceDays)
        }
        
    }
    
    private func customizeDisplayOfGraph(periodIndex: Int, differenceDays: Int) {
        
        if !fieldForGraphsScrollView.subviews.isEmpty {
            
            fieldForGraphsScrollView.subviews.forEach { $0.removeFromSuperview() }
            labelsForScaleOfValuesScrollView.subviews.forEach { $0.removeFromSuperview() }
            labelsForScaleOfDatesScrollView.subviews.forEach { $0.removeFromSuperview() }
        }
        
        let cellWidthAndHeight: CGFloat = 50.0
        
        let field = Field(heightField: fieldForGraphsScrollView.frame.height, periodIndex: periodIndex, amountOfDay: differenceDays, cellWidthAndHeight: cellWidthAndHeight)
        
        let scale = Scales(allValues: allValues, allDates: allUniqueDates, field: field)
        
        let fieldForGraphsView = FieldForGraphsView(field: field, scales: scale, labelsForScaleOfValuesScrollView: labelsForScaleOfValuesScrollView, labelsForScaleOfDatesScrollView: labelsForScaleOfDatesScrollView)
        
        if let startDate = allDates.first {

            let pointsForGraphs = PointsForGraphs(startDate: startDate, fieldForGraphs: field, cellWidthAndHeight: cellWidthAndHeight)
            
            let pointsForIncomes = pointsForGraphs.createAndGetPoints(from: incomes.allIncome, maxValueOnValueScale: scale.values.max())

            let pointsForExpenses = pointsForGraphs.createAndGetPoints(from: expenses.allCategoriesExpenses, maxValueOnValueScale: scale.values.max())
            
            drawLinesOnFieldAndAdd(pointsForGraphs: pointsForIncomes, fieldForGraphsView: fieldForGraphsView, colorLines: .lineIncome, colorPoints: (backgroundColor: .pointIncome, borderColor: .borderPointIncome))

            drawLinesOnFieldAndAdd(pointsForGraphs: pointsForExpenses, fieldForGraphsView: fieldForGraphsView, colorLines: .lineExpense, colorPoints: (backgroundColor: .pointExpense, borderColor: .borderPointExpense))
            
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
    
    private func getAllValues() -> [Int] {
        
        var allValues = incomes.allIncome.map { $0.value }
        let othersValues: [[Int]] = expenses.allCategoriesExpenses.map{ $0.allExpense.map{ $0.value } }
        othersValues.forEach { elements in
            allValues.append(contentsOf: elements)
        }
        return allValues
    }
    
    private func getSetAllDates() -> Set<Date> {

        var allDates = incomes.allIncome.map { $0.date }
        let othersDates: [[Date]] = expenses.allCategoriesExpenses.map{ $0.allExpense.map{ $0.date } }
        othersDates.forEach { elements in
            allDates.append(contentsOf: elements)
        }

        return Set(allDates)
    }
    
    private func drawLinesOnFieldAndAdd(pointsForGraphs: [PointView], fieldForGraphsView: FieldForGraphsView, colorLines: UIColor, colorPoints: (backgroundColor: UIColor, borderColor: UIColor)) {
        
        guard let firstPoint = pointsForGraphs.first else { return }
        
        let linesOnFieldView = LinesOnFieldView(startPoint: firstPoint.center, lineColor: colorLines)
        
        for point in pointsForGraphs {
            linesOnFieldView.draw(on: fieldForGraphsView, nextPoint: point.center)
        }

        for pointView in pointsForGraphs {
            pointView.presentAlertDelegate = self
            pointView.presentCategoryExpensesViewControllerDelegate = self
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
    
    @IBAction func changeTimeIntervalSegmentedControl(_ sender: UISegmentedControl) {
        removeObjectsFromSuperview()
        customizeDisplayOfGraph(periodIndex: sender.selectedSegmentIndex, differenceDays: differenceDays)
    }
}

//MARK: - UIScrollViewDelegate
extension GraphsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        labelsForScaleOfValuesScrollView.contentOffset.y = fieldForGraphsScrollView.contentOffset.y
        labelsForScaleOfDatesScrollView.contentOffset.x = fieldForGraphsScrollView.contentOffset.x
    }
}

//MARK: - PresentAlertDelegate
extension GraphsViewController: PresentAlertDelegate {
    func present(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

//MARK: - PresentCategoryExpensesViewControllerDelegate
extension GraphsViewController: PresentCategoryExpensesViewControllerDelegate {
    func present(viewController: UIViewController) {
        present(viewController, animated: true)
    }
}
