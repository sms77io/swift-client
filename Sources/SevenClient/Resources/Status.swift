import Foundation

struct SmsStatus: Decodable {
    var id: String
    var status: String
    var status_time: String
}

enum StatusReportCode: String, Codable {
    case DELIVERED
    case NOTDELIVERED
    case BUFFERED
    case TRANSMITTED
    case ACCEPTED
    case EXPIRED
    case REJECTED
    case FAILED
    case UNKNOWN
}

struct StatusParams: Codable {
    var msg_id: String

    init(msg_id: String) {
        self.msg_id = msg_id
    }
}

struct Status {
   var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func get(params: StatusParams) -> [SmsStatus] {
        let res = client.request(endpoint: "status", method: "GET", payload: params)
        return try! JSONDecoder().decode([SmsStatus].self, from: res!)
    }
}
