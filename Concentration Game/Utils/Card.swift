import Foundation

struct Card
{
    var isFaceUp = false
    var isMatched = false
    var uid: Int
    
    static var uidFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        uidFactory += 1
        return uidFactory
    }
    
    init() {
        self.uid = Card.getUniqueIdentifier()
    }
}
