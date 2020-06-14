import UIKit
import CoreLocation

class ViewController: UIViewController
{
    var emojiChoices = ["🎃", "👻", "🍎", "🦇", "🍭", "😱", "😈", "👹", "🙀","💩"] //ctrl + cmd + space for emoji
    var emoji = Dictionary<Int, String>()
    var timer:Timer?
    var milestone:Int = 0
    var locationManager: CLLocationManager!
    var player: Player = Player()
    let playerId = "endGame"
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerElapsedTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        initLocationManager()
    }
    
    //MARK:- Didload functions
    // timer
    @objc func timerElapsedTime(){
        milestone += 1
        let seconds = String(format: "%02d", (milestone%60))
        let minutes = String(format: "%02d", milestone/60)
        timerLabel.text = "Timer: \(minutes):\(seconds)"
    }
    // locations
    func initLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // MARK: - Game logic
    //create the board
    lazy var game = Concentration(numberOfPairsOfCards: ((cardButtons.count + 1) / 2))
       
       var flipCount = 0 {
           didSet {
               flipCountLabel.text = "Flips: \(flipCount)"
           }
       }
    
    // the card function
    @IBAction func touchCard(_ sender: UIButton) {
        let cardNumber = cardButtons.firstIndex(of: sender)!
        if(!game.cards[cardNumber].isFaceUp  && !game.cards[cardNumber].isMatched){
            flipCount += 1;
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            checkIfGameEnd()
        }
    }
    
    //the board function
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if (card.isFaceUp) {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)  // ColorLiteral
            }
        }
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.uid] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.uid] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.uid] ?? "?"
    }
    
    // MARK:- End of the game
    func checkIfGameEnd(){
        if(game.gameEnded()){
            print("end")
            self.timer?.invalidate()
            updatePlayer()
            performSegue(withIdentifier: playerId, sender: self)
        }
    }
    
    func updatePlayer(){
        self.player.flip = flipCount
        self.player.time = milestone
        self.player.date = self.player.createDate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == playerId){
            let vc = segue.destination as! HighScoreController
            vc.checkPlayer = self.player
        }
    }
}

//MARK:- Get the location
extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self.player.playerLat = lat
            self.player.playerLong = lon
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in location: \(error)")
    }
}
