import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(itemHere:Store.init().items[0])
            //FinalView(item: Store.init().items[0])
        }
    }
}
