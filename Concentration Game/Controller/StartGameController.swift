import UIKit

class StartGameController: UIViewController {

    @IBOutlet weak var BTN_playButton: UIButton!
    @IBOutlet weak var BTN_topTenButton: UIButton!
    @IBOutlet weak var BTN_exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:- button functions
    @IBAction func ClickStart(_ sender: Any) {
        self.performSegue(withIdentifier: "play", sender: self)
    }
    
    @IBAction func ClickTopTen(_ sender: Any) {
        self.performSegue(withIdentifier: "topTen", sender: self)
    }
    
    @IBAction func ClickExit(_ sender: Any) {
        exit(0)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "play"){
            _ = segue.destination as! ViewController
        }
        if(segue.identifier == "topTen"){
            _ = segue.destination as! HighScoreController
        }
    }

}
