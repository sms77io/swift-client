import Foundation

enum StringBool: String, Codable {
    case `true`
    case `false`
}

struct SevenClient {
    var analytics: Analytics
    var balance: Balance
    var client: ApiClient
    var contacts: Contacts
    var groups: Groups
    var hooks: Hooks
    var journal: Journal
    var lookup: Lookup
    var pricing: Pricing
    var rcs: Rcs
    var sms: Sms
    var status: Status
    var subaccounts: Subaccounts
    var voice: Voice

    init(apiKey: String = ProcessInfo.processInfo.environment["SEVEN_API_KEY"] ?? "") {
        self.client = try! ApiClient(apiKey: apiKey)
        self.analytics = Analytics(client: self.client)
        self.balance = Balance(client: self.client)
        self.contacts = Contacts(client: self.client)
        self.groups = Groups(client: self.client)
        self.hooks = Hooks(client: self.client)
        self.journal = Journal(client: self.client)
        self.lookup = Lookup(client: self.client)
        self.pricing = Pricing(client: self.client)
        self.rcs = Rcs(client: self.client)
        self.sms = Sms(client: self.client)
        self.status = Status(client: self.client)
        self.subaccounts = Subaccounts(client: self.client)
        self.voice = Voice(client: self.client)
    }
}
