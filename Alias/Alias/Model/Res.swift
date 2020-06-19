
import Foundation

class Res: Decodable {
    enum Response: CodingKey {
        case ack, message, code
    }
    
    var ack: String = ""
    var message: String = ""
    var code: Int = -2
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Response.self)
        ack = try container.decode(String.self, forKey: .ack)
        message = try container.decode(String.self, forKey: .message)
        code = try container.decode(Int.self, forKey: .code)
    }
    
    init() {}
}
