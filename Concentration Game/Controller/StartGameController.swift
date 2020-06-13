import UIKit

class StartGameController: UIViewController {

    @IBOutlet weak var BTN_playButton: UIButton!
    @IBOutlet weak var BTN_topTenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ClickStart(_ sender: Any) {
        self.performSegue(withIdentifier: "play", sender: self)
    }
    
    @IBAction func ClickTopTen(_ sender: Any) {
        self.performSegue(withIdentifier: "topTen", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "play"){
            _ = segue.destination as! ViewController
        }
        /*
        if(segue.identifier == "topTen"){
            _= segue.description as!
        }
 */
    }

}
