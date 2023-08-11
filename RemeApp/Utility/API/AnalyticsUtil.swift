

import Foundation
import Firebase
import FirebaseAnalytics

final class AnalyticsUtil {



    static func send(event: String , paramters: [String: Any]? = nil) {
        Analytics.logEvent(event, parameters: paramters)
    }
}
