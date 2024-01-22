import Foundation

struct Analytics {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func byDate(params: AnalyticsParams) -> [AnalyticGroupByDate]? {
        let res = client.request(endpoint: "analytics/date", method: "GET", payload: params)
        return try! JSONDecoder().decode([AnalyticGroupByDate].self, from: res!)
    }

    public func byLabel(params: AnalyticsParams) -> [AnalyticGroupByLabel]? {
        let res = client.request(endpoint: "analytics/label", method: "GET", payload: params)
        return try! JSONDecoder().decode([AnalyticGroupByLabel].self, from: res!)
    }

    public func bySubaccount(params: AnalyticsParams) -> [AnalyticGroupBySubaccount]? {
        let res = client.request(endpoint: "analytics/subaccount", method: "GET", payload: params)
        return try! JSONDecoder().decode([AnalyticGroupBySubaccount].self, from: res!)
    }

    public func byCountry(params: AnalyticsParams) -> [AnalyticGroupByCountry]? {
        let res = client.request(endpoint: "analytics/country", method: "GET", payload: params)
        return try! JSONDecoder().decode([AnalyticGroupByCountry].self, from: res!)
    }
}

struct AnalyticsParams: Codable {
    var end: String?
    var label: String?
    var start: String?
    var subaccounts: String?
}

protocol AnalyticBase: Codable {
    var hlr: Int? { get set }
    var inbound: Int? { get set }
    var mnp: Int? { get set }
    var rcs: Int? { get set }
    var sms: Int? { get set }
    var usage_eur: Float? { get set }
    var voice: Int? { get set }
}

struct AnalyticGroupByCountry: AnalyticBase {
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var rcs: Int?
    var sms: Int?
    var usage_eur: Float?
    var voice: Int?
    var country: String
}

struct AnalyticGroupByDate: AnalyticBase {
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var rcs: Int?
    var sms: Int?
    var usage_eur: Float?
    var voice: Int?
    var date: String
}

struct AnalyticGroupBySubaccount: AnalyticBase {
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var rcs: Int?
    var sms: Int?
    var usage_eur: Float?
    var voice: Int?
    var account: String
}

struct AnalyticGroupByLabel: AnalyticBase {
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var rcs: Int?
    var sms: Int?
    var usage_eur: Float?
    var voice: Int?
    var label: String
}
