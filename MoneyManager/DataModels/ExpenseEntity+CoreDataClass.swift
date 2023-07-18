import Foundation
import CoreData

class ExpenseEntity: NSManagedObject {
    
    class func findOrCreate(_ expense: Expense, context: NSManagedObjectContext) throws -> ExpenseEntity {
        
        let request: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", expense.id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0 {
                assert(fetchResult.count == 1, "Duplicate has been found in DB!")
                return fetchResult[0]
            }
        } catch {
            throw error
        }
        
        let expenseEntity = ExpenseEntity(context: context)
        expenseEntity.id = expense.id
        expenseEntity.value = Int64(expense.value)
        expenseEntity.date = expense.date
        expenseEntity.name = expense.name
        
        return expenseEntity
    }
}
