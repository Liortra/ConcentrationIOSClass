import UIKit
import MapKit

class HighScoreController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table_highScore: UITableView!
    @IBOutlet weak var map_highScore: MKMapView!
    
    var checkPlayer: Player?
    var highScoreList:[Player] = [Player]()
    let cellId = "highScoreCell"
    let dataId = "key"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHighScoreTable()
        showHighScoreTable()
    }
    
    //MARK:- Didload functions
    func initHighScoreTable(){
        table_highScore.delegate = self
        table_highScore.dataSource = self
        table_highScore.reloadData()
    }
    
    // check if it from the main screen or the game
    func showHighScoreTable(){ // need to
        self.highScoreList = readData()
        if(checkPlayer != nil){
         appendAndSortHighScoreList(checkPlayer: checkPlayer!)
        }
    }
    
    //MARK:- Functions
    // highScore list functions
    func appendAndSortHighScoreList(checkPlayer: Player){
        self.highScoreList.append(checkPlayer)
        sortHighScoreList()
        writeData(array: self.highScoreList)
    }
    
    func sortHighScoreList(){
        self.highScoreList = self.highScoreList.sorted(by: {(player1, player2) -> Bool in
            return player1.time < player2.time
        })
        if(self.highScoreList.count > 10){
            self.highScoreList.removeLast()
        }
    }
    
    // loctaion functions
    func showPlayersLocations(){
        for player in self.highScoreList{
            markInMap(player: player)
        }
    }
    
    func markInMap(player: Player){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D.init(latitude: player.playerLat, longitude: player.playerLong)
        map_highScore.addAnnotation(annotation)
        let seconds = String(format: "%02d", (player.time%60))
        let minutes = String(format: "%02d", player.time/60)
        annotation.title = "\(minutes):\(seconds)"
    }
    
    //read and write functions
    func readData() -> [Player]{
        if let data = UserDefaults.standard.data(forKey: dataId){
            do{
                let decoder = JSONDecoder()
                self.highScoreList =
                    try decoder.decode([Player].self, from: data)
                    return self.highScoreList
            }catch{
                print("Cannot read the share preference")
            }
        }
        return [Player]()
    }
    
    func writeData(array: [Player]){
        do{
            let encoder = JSONEncoder()
            let data =
                try encoder.encode(array)
                UserDefaults.standard.set(data, forKey: dataId)
                self.highScoreList = readData()
        }catch{
            print("Cannot write to the share preference")
        }
    }

    //MARK:- UITableViewDataSource functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScoreList.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table_highScore.dequeueReusableCell(withIdentifier: cellId) as? HighScoreTable
        cell?.highScore_LBL_Flip.text = String(highScoreList[indexPath.row].flip)
        let seconds = String(format: "%02d", (highScoreList[indexPath.row].time%60))
        let minutes = String(format: "%02d", highScoreList[indexPath.row].time/60)
        cell?.highScore_LBL_Time.text = "\(minutes):\(seconds)"
        cell?.highScore_LBL_Date.text = String(highScoreList[indexPath.row].date)
        showPlayersLocations()
        return cell!
    }

}
