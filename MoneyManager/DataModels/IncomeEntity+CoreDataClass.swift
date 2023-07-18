import Foundation
import CoreData

class IncomeEntity: NSManagedObject {

    class func findOrCreate(_ income: Income, context: NSManagedObjectContext) throws -> IncomeEntity {
        
        let request: NSFetchRequest<IncomeEntity> = IncomeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", income.id as CVarArg)
        
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0 {
                assert(fetchResult.count == 1, "Duplicate has been found in DB!")
                return fetchResult[0]
            }
        } catch {
            throw error
        }
        
        let incomeEntity = IncomeEntity(context: context)
        incomeEntity.id = income.id
        incomeEntity.value = Int64(income.value)
        incomeEntity.date = income.date
        
        return incomeEntity
    }
}
