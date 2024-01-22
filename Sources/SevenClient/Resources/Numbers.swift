import Foundation

struct AvailableNumbersParams: Codable {
    var features_sms: Bool
    var features_a2p_sms: Bool
    var features_voice: Bool
}

struct AvailableNumbers: Decodable {
    var availableNumbers: Array<AvailableNumber>
}
struct AvailableNumber: Decodable {
    var country: String
    var number: String
    var number_parsed: String
    var fees: AvailableNumberFees
    var features: AvailableNumberFeatures
}
struct AvailableNumberFeatures: Decodable {
    var sms: Bool
    var a2p_sms: Bool
    var voice: Bool
}
struct AvailableNumberFees: Decodable {
    var annually: AvailableNumberFeesAnnually
    var monthly: AvailableNumberFeesMonthly
    var sms_mo: Float
    var voice_mo: Float
}
struct AvailableNumberFeesAnnually: Decodable {
    var basic_charge: Float
    var setup: Float
}
struct AvailableNumberFeesMonthly: Decodable {
    var basic_charge: Float
    var setup: Float
}

struct OrderNumberResponse: Codable {
    var error: String?
    var success: Bool
}
struct OrderNumberParams: Codable {
    var number: String
    var payment_interval: PaymentInterval?
}
enum PaymentInterval: String, Codable {
    case annually
    case monthly
}
struct DeleteNumberResponse: Codable {
    var success: Bool
}
struct DeleteNumberParams: Codable {
    var delete_immediately: Bool?
}
struct Number: Codable {
    var country: String
    var number: String
    var friendly_name: String
    var billing: NumberBilling
    var features: NumberFeatures
    var forward_sms_mo: NumberBillingForwardInboundSms
    var expires: Date?
    var created: Date
}
struct NumberBilling: Codable {
    var fees: NumberBillingFees
    var payment_interval: String
}
struct NumberBillingForwardInboundSms: Codable {
    var sms: NumberBillingForwardInboundSmsBySms
    var email: NumberBillingForwardInboundSmsByMail
}
struct NumberBillingForwardInboundSmsBySms: Codable {
    var enabled: Bool
    var number: Array<String>
}
struct NumberBillingForwardInboundSmsByMail: Codable {
    var enabled: Bool
    var address: Array<String>
}
struct NumberBillingFees: Codable {
    var setup: Float
    var basic_carge: Float
    var sms_mo: Float
    var voice_mo: Float
}
struct NumberFeatures: Codable {
    var sms: Bool
    var a2p_sms: Bool
    var voice: Bool
}
struct ActiveNumbers: Codable {
    var activeNumbers: Array<Number>
}
struct UpdateNumberParams: Codable {
    var email_forward: Array<String>?
   var friendly_name: String?
    var sms_forward: Array<String>?
}
struct Numbers {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func listAvailable(params: AvailableNumbersParams) -> AvailableNumbers? {
        let res = client.request(endpoint: "numbers/available", method: "GET", payload: params)
        return try! JSONDecoder().decode(AvailableNumbers.self, from: res!)
    }

    public func order(params: OrderNumberParams) -> OrderNumberResponse? {
        let res = client.request(endpoint: "numbers/order", method: "POST", payload: params)
        return try! JSONDecoder().decode(OrderNumberResponse.self, from: res!)
    }

    public func delete(id: Int, params: DeleteNumberParams) -> DeleteNumberResponse? {
        let res = client.request(endpoint: "numbers/active/\(id)", method: "DELETE", payload: params)
        return try! JSONDecoder().decode(DeleteNumberResponse.self, from: res!)
    }

    public func get(number: String) -> Number? {
        struct Params: Codable {}
        let res = client.request(endpoint: "numbers/active/\(number)", method: "GET", payload: Params())
        return try! JSONDecoder().decode(Number.self, from: res!)
    }

    public func listActive() -> ActiveNumbers? {
        struct Params: Codable {}
        let res = client.request(endpoint: "numbers/active", method: "GET", payload: Params())
        return try! JSONDecoder().decode(ActiveNumbers.self, from: res!)
    }

    public func update(number: String, params: UpdateNumberParams) -> Number? {
        let res = client.request(endpoint: "numbers/active/\(number)", method: "PATCH", payload: params)
        return try! JSONDecoder().decode(Number.self, from: res!)
    }
}