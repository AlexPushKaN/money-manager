import Foundation
import CoreData

class ExpensesEntity: NSManagedObject {
    
    class func findOrCreate(context: NSManagedObjectContext) throws -> ExpensesEntity {
        
        let request:NSFetchRequest<ExpensesEntity> = ExpensesEntity.fetchRequest()
        
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0 {
                assert(fetchResult.count == 1, "Duplicate has been found in DB!")
                return fetchResult[0]
            }
        } catch {
            throw error
        }

        let expensesEntity = ExpensesEntity(context: context)
        return expensesEntity
    }
}
