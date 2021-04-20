import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var portfolio: UILabel!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var spending: UILabel!
    @IBOutlet weak var cashflow: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
