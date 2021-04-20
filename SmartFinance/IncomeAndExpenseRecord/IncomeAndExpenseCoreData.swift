import Foundation
import CoreData

enum ExpenseFilter: String {
    case all
    case week
    case month
}

enum ExpenseSort: String {
    case occuredOn
}

public class ExpenseCD: NSManagedObject, Identifiable {
    @NSManaged public var type: String?
    @NSManaged public var title: String?
    @NSManaged public var tag: String?
    @NSManaged public var occuredOn: Date?
    @NSManaged public var amount: Double
    @NSManaged public var imageAttached: Data?
}

extension ExpenseCD {
    static func getAllExpense(sort: ExpenseSort = .occuredOn, order: Bool = true, filter: ExpenseFilter = .all) -> NSFetchRequest<ExpenseCD> {
        var FetchRequest: NSFetchRequest<ExpenseCD> = ExpenseCD.fetchRequest() as! NSFetchRequest<ExpenseCD>
        
        if filter == .month {
            var start = Date().LastThirtyDay()! as NSDate
            FetchRequest.predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", start, NSDate())
        } else if filter == .week {
            var start = Date().LastSevenDay()! as NSDate
            FetchRequest.predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", start, NSDate())
        }
        FetchRequest.sortDescriptors = [NSSortDescriptor(key: sort.rawValue, ascending: order)]
        return FetchRequest
    }
}
