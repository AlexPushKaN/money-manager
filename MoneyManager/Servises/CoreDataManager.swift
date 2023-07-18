import UIKit
import CoreData

class CoreDataManager {
    
    // MARK: - static properties and functions
    static let shared = CoreDataManager()
    
    static func uploadDataFromCoreData() -> (incomes: Incomes, expenses: Expenses) {
        
        let incomes: Incomes = Incomes(allIncome: [])
        let expenses: Expenses = Expenses(allCategoriesExpenses: [])
        
        let incomesEntity = try! IncomesEntity.findOrCreate(context: shared.context)
        if let incomesEntity = incomesEntity.income {
            for incomeEntity in incomesEntity {
                let incomeEntity = incomeEntity as! IncomeEntity
                if let id = incomeEntity.id,
                   let date = incomeEntity.date {
                    let income = Income(id: id, value: Int(incomeEntity.value), date: date)
                    incomes.allIncome.append(income)
                }
            }
        }
        
        let expensesEntity = try! ExpensesEntity.findOrCreate(context: shared.context)
        if let categoriesExpensesEntities = expensesEntity.categoriesExpenses {
            for categoryExpensesEntity in categoriesExpensesEntities {
                if let categoryExpensesEntity = categoryExpensesEntity as? CategoryExpensesEntity {
                    if let id = categoryExpensesEntity.id,
                       let name = categoryExpensesEntity.name {
                        let categoryExpenses = CategoryExpenses(id: id, name: name, allExpense: [])
                        if let expensesEntity = categoryExpensesEntity.expense {
                            for expenseEntity in expensesEntity {
                                let expenseEntity = expenseEntity as! ExpenseEntity
                                if let id = expenseEntity.id,
                                   let date = expenseEntity.date,
                                   let name = expenseEntity.name {
                                    let expense = Expense(id: id, value: Int(expenseEntity.value), date: date, name: name)
                                    categoryExpenses.allExpense.append(expense)
                                }
                            }
                        }
                        expenses.allCategoriesExpenses.append(categoryExpenses)
                    }
                }
            }
        }
        
        return (incomes: incomes, expenses: expenses)
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoneyManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    func add(entity: Objects) {
        
        do {
            
            switch entity {
            case .incomes (let incomes):
                if let income = incomes.allIncome.last {
                   let incomeEntity = try IncomeEntity.findOrCreate(income, context: context)
                   let incomesEntity = try IncomesEntity.findOrCreate(context: context)
                    incomesEntity.addToIncome(incomeEntity)
                }
            case .categoryExpenses(let categoryExpenses):
                if let expense = categoryExpenses.allExpense.last {
                   let expenseEntity = try ExpenseEntity.findOrCreate(expense, context: context)
                   let categoryExpensesEntity = try CategoryExpensesEntity.findOrCreate(categoryExpenses, context: context)
                    categoryExpensesEntity.addToExpense(expenseEntity)
                }
            case .expenses(let expenses):
                if let categoryExpenses = expenses.allCategoriesExpenses.last {
                   let categoryExpensesEntity = try CategoryExpensesEntity.findOrCreate(categoryExpenses, context: context)
                   let expensesEntity = try ExpensesEntity.findOrCreate(context: context)
                    expensesEntity.addToCategoriesExpenses(categoryExpensesEntity)
                }
            }
            
        } catch {
            print("Error in block add")
        }
        
        saveContext()
        
    }
    
    func delete(entity: Objects, id: UUID) {
        
        switch entity {
            
        case .incomes(_):
            let incomesEntity = try! IncomesEntity.findOrCreate(context: context)
            guard let incomeEntities = incomesEntity.income else { return }
            for incomeEntity in incomeEntities {
                if let incomeEntity = incomeEntity as? IncomeEntity, incomeEntity.id == id {
                    incomesEntity.removeFromIncome(incomeEntity)
                }
            }
        case .expenses(_):
            let expensesEntity = try! ExpensesEntity.findOrCreate(context: context)
            guard let categoriesExpensesEntities = expensesEntity.categoriesExpenses else { return }
            for categoryExpensesEntity in categoriesExpensesEntities {
                if let categoryExpensesEntity = categoryExpensesEntity as? CategoryExpensesEntity, categoryExpensesEntity.id == id {
                    expensesEntity.removeFromCategoriesExpenses(categoryExpensesEntity)
                }
            }
        case .categoryExpenses(let categoryExpenses):
            let categoryExpensesEntity = try! CategoryExpensesEntity.findOrCreate(categoryExpenses, context: context)
            guard let expenseEntities = categoryExpensesEntity.expense else { return }
            for expenseEntity in expenseEntities {
                if let expenseEntity = expenseEntity as? ExpenseEntity, expenseEntity.id == id {
                    categoryExpensesEntity.removeFromExpense(expenseEntity)
                }
            }
        }

        saveContext()
    }
    
    private init() {}
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
