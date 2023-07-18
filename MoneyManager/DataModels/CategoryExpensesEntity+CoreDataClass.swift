import Foundation
import CoreData

class CategoryExpensesEntity: NSManagedObject {
    
    class func findOrCreate(_ categoryExpenses: CategoryExpenses, context: NSManagedObjectContext) throws -> CategoryExpensesEntity {
        
        let request: NSFetchRequest<CategoryExpensesEntity> = CategoryExpensesEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", categoryExpenses.id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0 {
                assert(fetchResult.count == 1, "Duplicate has been found in DB!")
                return fetchResult[0]
            }
        } catch {
            throw error
        }

        let categoryExpensesEntity = CategoryExpensesEntity(context: context)
        categoryExpensesEntity.id = categoryExpenses.id
        categoryExpensesEntity.name = categoryExpenses.name
        return categoryExpensesEntity
    }
}
