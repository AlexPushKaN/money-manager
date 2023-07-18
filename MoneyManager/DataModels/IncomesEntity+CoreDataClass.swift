import Foundation
import CoreData


class IncomesEntity: NSManagedObject {
    
    class func findOrCreate(context: NSManagedObjectContext) throws -> IncomesEntity {
        
        let request:NSFetchRequest<IncomesEntity> = IncomesEntity.fetchRequest()
        
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0 {
                assert(fetchResult.count == 1, "Duplicate has been found in DB!")
                return fetchResult[0]
            }
        } catch {
            throw error
        }

        let incomesEntity = IncomesEntity(context: context)
        return incomesEntity
    }
}
