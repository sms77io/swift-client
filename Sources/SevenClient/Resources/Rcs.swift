import Foundation

struct RcsDeleteResponse: Codable {
    var success: Bool
}

enum RcsFallback: String, Codable {
    case sms
    case webview
}

enum RcsEvent: String, Codable {
    case IS_TYPING
    case READ
}

struct RcsEventParams: Codable {
    var event: RcsEvent
    var to: String?
    var msg_id: String?
}

struct RcsEventResponse: Codable {
    var success: Bool
}

struct RcsParams: Codable {
    var to: String
    var text: String
    var from: String?
    var delay: Date?
    var ttl: Int?
    var label: String?
    var performance_tracking: Bool?
    var foreign_id: String?
    var fallback: RcsFallback
}

struct RcsMessage: Decodable {
    var channel: String
    var encoding: String
    var error: String?
    var error_text: String?
    var id: String?
    var messages: [String]?
    var parts: Int
    var price: Float
    var recipient: String
    var sender: String
    var success: Bool
    var text: String
}

struct RcsResponse: Decodable {
    var debug: StringBool
    var balance: Float
    var messages: [RcsMessage]
    var sms_type: String
    var success: String
    var total_price: Float
}

struct Rcs {
   var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func delete(id: String) -> RcsDeleteResponse? {
        struct Params: Codable {}
        let res = client.request(endpoint: "rcs/messages/\(id)", method: "DELETE", payload: Params())
        return try! JSONDecoder().decode(RcsDeleteResponse.self, from: res!)
    }

    public func dispatch(params: RcsParams) -> RcsResponse? {
        let res = client.request(endpoint: "rcs/messages", method: "POST", payload: params)
        return try! JSONDecoder().decode(RcsResponse.self, from: res!)
    }

       public func dispatch(params: RcsEventParams) -> RcsEventResponse? {
        let res = client.request(endpoint: "rcs/events", method: "POST", payload: params)
        return try! JSONDecoder().decode(RcsEventResponse.self, from: res!)
    }
}