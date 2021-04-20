import Foundation
import CoreData


extension TheProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TheProfile> {
        return NSFetchRequest<TheProfile>(entityName: "TheProfile")
    }

    @NSManaged public var birthdate: Date?
    @NSManaged public var name: String?
    @NSManaged public var earning: Int64

}
