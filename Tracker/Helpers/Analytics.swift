import Foundation
import YandexMobileMetrica

final class Analytics {
    static let shared = Analytics()
    
    private func report(_ event: String, screen: String, item: String? = nil) {
        var params: [AnyHashable : Any] = ["event": event, "screen": screen]
        if let item = item {
            params["item"] = item
        }
        
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func openScreen(_ screen: Screen) {
        report("open", screen: screen.rawValue)
    }
    
    func closeScreen(_ screen: Screen) {
        report("close", screen: screen.rawValue)
    }
    
    func tapButton(on screen: Screen, itemType: ButtonType) {
        report("click", screen: screen.rawValue, item: itemType.rawValue)
    }
    
    enum ButtonType: String {
        case addTrack = "add_track"
        case track = "track"
        case filter = "filter"
        case edit = "edit"
        case delete = "delete"
    }
    
    enum Screen: String {
        case main = "Main"
    }
}
