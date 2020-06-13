import Foundation

class Concentration
{
    var cards = Array<Card>()
    var indexOfOnlyOneFaceUp: Int?
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOnlyOneFaceUp, matchIndex != index {
                // Check if the cards match
                if (cards[matchIndex].uid == cards[index].uid) {
                    cards[matchIndex].isMatched = true;
                    cards[index].isMatched = true;
                }
                cards[index].isFaceUp = true
                indexOfOnlyOneFaceUp = nil
            } else {
                // Either no cards or two cards are face up
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOnlyOneFaceUp = index
            }
        }
    }
    
    func gameEnded() -> Bool {
        for card in cards{
            if(!card.isMatched){
                return false
            }
        }
        return true
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards.append(card)
            cards.append(card)
        }
        
        // Shuffle the cards
//        for index in 0..<cards.count {
//            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
//            let randomCard = cards[randomIndex]
//            cards[randomIndex] = cards[index]
//            cards[index] = randomCard
//        }
    }
}
