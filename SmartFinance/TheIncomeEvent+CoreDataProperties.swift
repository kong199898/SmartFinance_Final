import Foundation
import CoreData


extension TheIncomeEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TheIncomeEvent> {
        return NSFetchRequest<TheIncomeEvent>(entityName: "TheIncomeEvent")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var frequency: String?
    @NSManaged public var startingage: Int64
    @NSManaged public var other: String?
    @NSManaged public var type: String?

}
