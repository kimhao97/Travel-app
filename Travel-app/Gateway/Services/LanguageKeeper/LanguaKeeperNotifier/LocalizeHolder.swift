import UIKit
class LocalizeHolder {
    private var localizeItem = NSHashTable<NSObject>.weakObjects()
    var count: Int {
        return localizeItem.allObjects.count
    }
    func add(item: NSObject) {
        localizeItem.add(item)
    }
    func remove(item: UIView) {
        localizeItem.remove(item)
    }
    func reloadInfo() {
        localizeItem.allObjects.forEach { (item) in
            if let localizeItem = item as? LocalizationableItem {
                localizeItem.shouldReload(withString: "")
            }
        }
    }
}
