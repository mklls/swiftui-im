import AVFoundation
import SwiftSocket


class ChatRoom: ObservableObject {
    @Published var friends: [Chat]
    @Published var client: TCPClient
    @Published var me: User
    @Published var enableNotification: Bool
    
    var readingQueue: DispatchQueue
    var readingWorkItem: DispatchWorkItem? = nil
    
    init() {
        friends = []
        client = TCPClient(address: "\(Config.CHAT)", port: 5219)
        readingQueue = DispatchQueue(label: "readingQueue")
        me = User(id: 0, username: "admin", icon: "0", mail: "")
        enableNotification = UserDefaults.standard.bool(forKey: "enableNotification")
        switch client.connect(timeout: 500) {
            case .success:
                print("connection successfull")
            case .failure(let err):
                print("failed \(err)")
        }
    }
    
    func startReadingQueue() {
        print("开始获取")
        readingWorkItem = DispatchWorkItem {
            guard let item = self.readingWorkItem else { return }
            var temp: String = ""
            while !item.isCancelled {
                guard let d = self.client.read(4096) else { continue }
                
                let c = String(bytes: d, encoding: .utf8)!
                
                if c.contains("«") {
                    let i = c.firstIndex(of: "«")!
                    temp += c[..<i]
                    print(temp)
                    let res = try! JSONDecoder().decode(Handler.self, from: Data(temp.utf8))
                    self.handle(data: res)
                    temp = ""
                } else {
                    temp += c
                }
            }
        }
        readingQueue.async(execute: readingWorkItem!)
    }
    
    func handle(data: Handler) {
        DispatchQueue.main.async {
            switch data.type {
                case .me(let me):
                    self.me = me
                    print(self.me)
                case .room(let users):
                    for u in users {
                        self.friends.append(Chat(with: u))
                    }
                case .new(let new):
                    self.friends.append(Chat(with: new))
                case .message(let msg):
                    for c in self.friends {
                        if c.with.id == msg.creator.id {
                            c.messages.append(msg)
                            break
                        }
                    }
                    if self.enableNotification  { AudioServicesPlaySystemSound(1002) }
                case .all(let msg):
                    self.friends[0].messages.append(msg)
                    print("enable \(self.enableNotification)")
                    if self.enableNotification  { AudioServicesPlaySystemSound(1002) }
                case .offline(let username):
                    for (i, c) in self.friends.enumerated() {
                        var ready = false
                        if c.with.username == username { ready = true }
                        if ready {
                            print("移除 \(username)")
                            self.friends.remove(at: i)
                            break
                        }
                    }
                case .null:
                    print("unknow type")
            }
            self.objectWillChange.send()
        }
    }
}
