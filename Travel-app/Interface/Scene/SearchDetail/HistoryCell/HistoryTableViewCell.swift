import UIKit
import Reusable

class HistoryTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var historyLabel: UILabel!

    var isDeleteItem: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        historyLabel.font = AppFont.appFont(type: .regular, fontSize: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func binding(history: String) {
        historyLabel.text = history
    }
    
    @IBAction func deleteItem(sender: Any) {
        isDeleteItem?()
    }
}
