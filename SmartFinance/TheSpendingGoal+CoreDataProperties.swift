import Foundation
import CoreData


extension TheSpendingGoal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TheSpendingGoal> {
        return NSFetchRequest<TheSpendingGoal>(entityName: "TheSpendingGoal")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var frequency: String?
    @NSManaged public var startingage: Int64
    @NSManaged public var other: String?
    @NSManaged public var type: String?

}
