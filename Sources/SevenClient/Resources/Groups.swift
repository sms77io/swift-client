import Foundation

struct ListGroupsParams: Codable {
    var offset: Int?
    var limit: Int?
}

struct Group: Codable {
    var id: Int
    var name: String
    var members_count: Int
    var created: Date
}

struct ListGroupsResponse: Codable {
    var pagingMetadata: ListGroupsPagingMetadata
    var data: Array<Group>
}
struct ListGroupsPagingMetadata: Codable {
    var offset: Int
    var count: Int
    var total: Int
    var limit: Int
    var has_more: Bool
}

struct DeleteGroupsParams: Codable {
    var delete_contacts: Bool?
}

struct CreateGroupParams: Codable {
    var name: String
}

struct Groups {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func create(params: CreateGroupParams) -> Group? {
        let res = client.request(endpoint: "groups", method: "POST", payload: params)
        return try! JSONDecoder().decode(Group.self, from: res!)
    }

    public func delete(id: Int, params: DeleteGroupsParams) -> Void {
        client.request(endpoint: "groups/\(id)", method: "DELETE", payload: params)
    }

    public func get(id: Int) -> Group? {
        struct Params: Codable {}
        let res = client.request(endpoint: "groups/\(id)", method: "GET", payload: Params())
        return try! JSONDecoder().decode(Group.self, from: res!)
    }

    public func list(params: ListGroupsParams) -> ListGroupsResponse? {
        let res = client.request(endpoint: "groups", method: "GET", payload: params)
        return try! JSONDecoder().decode(ListGroupsResponse.self, from: res!)
    }

    public func update(id: Int, params: CreateGroupParams) -> Group? {
        let res = client.request(endpoint: "groups/\(id)", method: "PATCH", payload: params)
        return try! JSONDecoder().decode(Group.self, from: res!)
    }
}