import Foundation

struct Hooks {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func list() -> HooksReadResponse? {
        struct Params: Codable {}
        let res = client.request(endpoint: "hooks/read", method: "GET", payload: Params())
        return try! JSONDecoder().decode(HooksReadResponse.self, from: res!)
    }

    public func subscribe(params: HooksParams) -> HooksSubscribeResponse? {
        let res = client.request(endpoint: "hooks/subscribe", method: "POST", payload: params)
        return try! JSONDecoder().decode(HooksSubscribeResponse.self, from: res!)
    }

    public func unsubscribe(params: HooksParams) -> HooksUnsubscribeResponse? {
        let res = client.request(endpoint: "hooks/unsubscribe", method: "POST", payload: params)
        return try! JSONDecoder().decode(HooksUnsubscribeResponse.self, from: res!)
    }
}

struct HooksParams: Codable {
    var event_filter: String?
    var event_type: HookEventType?
    var request_method: HookRequestMethod?
    var target_url: String?
}

enum HookRequestMethod: String, Codable {
    case POST
    case GET
}

enum HookEventType: String, Codable {
    case all
    case dlr
    case sms_mo
    case tracking
    case voice_call
    case voice_dtmf
    case voice_status
}

struct Hook: Decodable {
    var created: String
    var event_filter: String?
    var event_type: HookEventType
    var id: String
    var request_method: HookRequestMethod
    var target_url: String
}

struct HooksSubscribeResponse: Decodable {
    var id: Int?
    var success: Bool
}

struct HooksUnsubscribeResponse: Decodable {
    var success: Bool
}

struct HooksReadResponse: Decodable {
    var hooks: [Hook]?
    var success: Bool
}
