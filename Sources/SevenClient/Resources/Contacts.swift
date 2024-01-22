import Foundation

enum OrderDirection: String, Codable {
    case asc
    case desc
}

struct ListParams: Codable {
    var order_by: String?
    var order_direction: OrderDirection?
    var search: String?
    var offset: Int?
    var limit: Int?
    var group_id: Int?
}

struct Contact: Codable {
    var id: Int?
    var avatar: String
    var initials: Initials
    var validation: Validation
    var properties: Properties
    var groups: Array<Int>
    var created: Date
}

struct Properties: Codable {
    var firstname: String
    var lastname: String
    var home_number: String
    var mobile_number: String
    var address: String
    var email: String
    var postal_code: String
    var city: String
    var birthday: Date
    var notes: String
}

struct Initials: Codable {
    var initials: String
    var color: String
}

struct Validation: Codable {
    var state: String
    var timestamp: Date
}

struct Contacts {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func create(contact: Contact) -> Contact? {
        let res = client.request(endpoint: "contacts", method: "POST", payload: contact)
        return try! JSONDecoder().decode(Contact.self, from: res!)
    }

    public func delete(id: Int) -> Void {
        struct Params: Codable {}
        client.request(endpoint: "contacts/\(id)", method: "DELETE", payload: (Params)())
    }

    public func get(id: Int) -> Contact? {
        struct Params: Codable {}
        let res = client.request(endpoint: "contacts/\(id)", method: "GET", payload: Params())
        return try! JSONDecoder().decode(Contact.self, from: res!)
    }

    public func list(params: ListParams?) -> [Contact]? {
        let res = client.request(endpoint: "contacts", method: "GET", payload: params)
        return try! JSONDecoder().decode([Contact].self, from: res!)
    }

    public func update(contact: Contact) -> Contact? {
        let res = client.request(endpoint: "contacts/\(contact.id)", method: "PATCH", payload: contact)
        return try! JSONDecoder().decode(Contact.self, from: res!)
    }
}