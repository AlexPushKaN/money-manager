//
//  IncomesViewController.swift
//  MoneyManager
//
//  Created by Александр Муклинов on 29.05.2023.
//

import UIKit

class IncomesViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var incomeTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var addIncomeButton: UIButton!
    
    var balanceAccount:Int = 0 {
        didSet {
            incomeTableView.reloadData()
            UIView.transition(with: balanceLabel, duration: 0.2, options: .transitionCrossDissolve) {
                self.balanceLabel.text = String(self.balanceAccount) + " рублей"
            }
        }
    }
    
    var incomes:Incomes = Incomes(allIncome: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeDisagnController()
        incomeTableView.dataSource = self
        
        incomes.allIncome = [Income(value: 200, date: Date()),
                   Income(value: 300, date: Date()),
                   Income(value: 400, date: Date()),
                   Income(value: 500, date: Date()),
                   Income(value: 550, date: Date())]
        
        balanceAccount = incomes.calculateAccountAmount()
        balanceLabel.text = String(balanceAccount) + " рублей"
        
    }
    
    private func customizeDisagnController() {
        
        view.backgroundColor = .incomesViewControllerColor
        
        headerView.layer.cornerRadius = 20
        headerView.layer.borderWidth = 5
        headerView.layer.borderColor = UIColor.incomeBorderColor.cgColor
        
        incomeTableView.separatorColor = .white
        incomeTableView.layer.cornerRadius = 20
        incomeTableView.layer.borderWidth = 5
        incomeTableView.layer.borderColor = UIColor.incomeBorderColor.cgColor

        addIncomeButton.layer.cornerRadius = addIncomeButton.bounds.height / 2
        
    }
    
    @IBAction func didPressAddIncomeButton(_ sender: UIButton) {
        let income = Income(value: 777, date: Date())
        incomes.allIncome.append(income)
        balanceAccount += income.value
    }
    
}

extension IncomesViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomes.allIncome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath) as! IncomeTableViewCell
        let index:Int = indexPath.row
        return cell.configure(value: incomes.allIncome[index].value, date: incomes.allIncome[index].date)
        
    }
    
}
