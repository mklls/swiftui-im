

import SwiftUI

struct ContentView: View {
    @State var LoggedIn: Bool = false
    
    
    var body: some View {
        VStack {
            if LoggedIn {
                RootView()
            } else {
                SignInView(isLoggedIn: $LoggedIn)
            }
        }
    }
}
