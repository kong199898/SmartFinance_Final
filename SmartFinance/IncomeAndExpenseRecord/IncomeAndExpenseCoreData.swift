import Foundation
import CoreData

enum ExpenseFilter: String {
    case all
    case week
    case month
}

enum ExpenseSort: String {
    case createdAt
    case updatedAt
    case occuredOn
}

public class ExpenseCD: NSManagedObject, Identifiable {
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var type: String?
    @NSManaged public var title: String?
    @NSManaged public var tag: String?
    @NSManaged public var occuredOn: Date?
    @NSManaged public var note: String?
    @NSManaged public var amount: Double
    @NSManaged public var imageAttached: Data?
}

extension ExpenseCD {
    static func getAllExpense(sort: ExpenseSort = .occuredOn, order: Bool = true, filter: ExpenseFilter = .all) -> NSFetchRequest<ExpenseCD> {
        let FetchRequest: NSFetchRequest<ExpenseCD> = ExpenseCD.fetchRequest() as! NSFetchRequest<ExpenseCD>
        let descriptor = NSSortDescriptor(key: sort.rawValue, ascending: order)
        
        if filter == .month {
            let start: NSDate = Date().LastThirtyDay()! as NSDate
            let end: NSDate = NSDate()
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", start, end)
            FetchRequest.predicate = predicate
        } else if filter == .week {
            let start: NSDate = Date().LastSevenDay()! as NSDate
            let end: NSDate = NSDate()
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", start, end)
            FetchRequest.predicate = predicate
        }
        FetchRequest.sortDescriptors = [descriptor]
        return FetchRequest
    }
}
