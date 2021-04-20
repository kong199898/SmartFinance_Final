import Foundation
import CoreData


extension TheAssumption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TheAssumption> {
        return NSFetchRequest<TheAssumption>(entityName: "TheAssumption")
    }

    @NSManaged public var inflation: Int64
    @NSManaged public var life: Int64
    @NSManaged public var retirement: Int64
    
}
