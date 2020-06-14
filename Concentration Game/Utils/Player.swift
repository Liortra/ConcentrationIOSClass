import Foundation

class Player:Codable
{
    var time:Int = 0
    var flip:Int = 0
    var playerLong: Double = 0.0
    var playerLat: Double = 0.0
    var date:String = ""
    
    init(){
        
    }
    
    init(time:Int,flip:Int) {
        self.time = time
        self.flip = flip
        self.date = createDate()
        
    }
    
    func createDate() -> String {
        let now = Date()
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .medium
        format.locale = .current
        return format.string(from: now)
    }
}
