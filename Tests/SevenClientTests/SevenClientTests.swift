import XCTest
@testable import SevenClient

final class SevenClientTests: XCTestCase {
    func initClient() -> SevenClient {
        var seven = SevenClient(apiKey: ProcessInfo.processInfo.environment["SEVEN_API_KEY_SANDBOX"]!)

        seven.client.debug = true
        seven.client.sentWith = "Swift-Test"

        return seven
    }

    func testAnalyticsByDate() {
        for analytic in initClient().analytics.byDate(params: AnalyticsParams())! {
            XCTAssertNotEqual(analytic.date, "")

            XCTAssertGreaterThanOrEqual(analytic.hlr!, 0)
            XCTAssertGreaterThanOrEqual(analytic.inbound!, 0)
            XCTAssertGreaterThanOrEqual(analytic.mnp!, 0)
            XCTAssertGreaterThanOrEqual(analytic.rcs!, 0)
            XCTAssertGreaterThanOrEqual(analytic.sms!, 0)
            XCTAssertGreaterThanOrEqual(analytic.usage_eur!, Float(0))
            XCTAssertGreaterThanOrEqual(analytic.voice!, 0)
        }
    }

    func testAnalyticsByCountry() {
        for analytic in initClient().analytics.byCountry(params: AnalyticsParams())! {
            XCTAssertNotEqual(analytic.country, "")

            XCTAssertGreaterThanOrEqual(analytic.hlr!, 0)
            XCTAssertGreaterThanOrEqual(analytic.inbound!, 0)
            XCTAssertGreaterThanOrEqual(analytic.mnp!, 0)
            XCTAssertGreaterThanOrEqual(analytic.rcs!, 0)
            XCTAssertGreaterThanOrEqual(analytic.sms!, 0)
            XCTAssertGreaterThanOrEqual(analytic.usage_eur!, Float(0))
            XCTAssertGreaterThanOrEqual(analytic.voice!, 0)
        }
    }

    func testAnalyticsByLabel() {
        for analytic in initClient().analytics.byLabel(params: AnalyticsParams())! {
            XCTAssertNotEqual(analytic.label, "")

            XCTAssertGreaterThanOrEqual(analytic.hlr!, 0)
            XCTAssertGreaterThanOrEqual(analytic.inbound!, 0)
            XCTAssertGreaterThanOrEqual(analytic.mnp!, 0)
            XCTAssertGreaterThanOrEqual(analytic.rcs!, 0)
            XCTAssertGreaterThanOrEqual(analytic.sms!, 0)
            XCTAssertGreaterThanOrEqual(analytic.usage_eur!, Float(0))
            XCTAssertGreaterThanOrEqual(analytic.voice!, 0)
        }
    }

    func testAnalyticsBySubaccount() {
        for analytic in initClient().analytics.bySubaccount(params: AnalyticsParams())! {
            XCTAssertNotEqual(analytic.account, "")

            XCTAssertGreaterThanOrEqual(analytic.hlr!, 0)
            XCTAssertGreaterThanOrEqual(analytic.inbound!, 0)
            XCTAssertGreaterThanOrEqual(analytic.mnp!, 0)
            XCTAssertGreaterThanOrEqual(analytic.rcs!, 0)
            XCTAssertGreaterThanOrEqual(analytic.sms!, 0)
            XCTAssertGreaterThanOrEqual(analytic.usage_eur!, Float(0))
            XCTAssertGreaterThanOrEqual(analytic.voice!, 0)
        }
    }


    func testBalance() {
        let res = initClient().balance.get()!
        XCTAssertNotEqual(res.currency, "")
    }

    func testContacts() {
        let client = initClient()
        let listParams = ListParams()

        for contact in client.contacts.list(params: listParams)! {
            XCTAssertNotEqual(contact.id!, 0)
            XCTAssertNotNil(contact.properties.firstname)
        }
    }

    func testHooks() {
        let res = initClient().hooks.list()!

        for hook in res.hooks! {
            XCTAssertNotEqual(hook.created.count, 0)
            XCTAssertNotNil(hook.event_type)
            XCTAssertNotEqual(hook.id.count, 0)
            XCTAssertNotNil(hook.request_method)
            XCTAssertNotEqual(hook.target_url.count, 0)
        }

        // TODO: add test for subscribe
        // TODO: add test for unsubscribe
    }

    func testJournal() {
        func baseAsserts(base: JournalBase) {
            XCTAssertNotNil(base.from.count)
            XCTAssertNotEqual(base.id.count, 0)
            XCTAssertNotEqual(base.price.count, 0)
            XCTAssertNotNil(base.text.count)
            XCTAssertNotEqual(base.timestamp.count, 0)
            XCTAssertNotNil(base.to.count)
        }

        let journals = initClient().journal.outbound(params: JournalParams())

        for journal in journals {
            baseAsserts(base: journal)

            XCTAssertNotEqual(journal.connection.count, 0)
            XCTAssertNotEqual(journal.type.count, 0)
        }

        // TODO: add test for inbound
        // TODO: add test for voice
        // TODO: add test for replies
    }

    func testLookup() {
        let client = initClient()
        let mnpParams = LookupParams(number: "491716992343")
        let res = client.lookup.mnp(params: mnpParams)
        let entry = res.first!

        XCTAssertEqual(res.count, 1)

        XCTAssertGreaterThan(entry.mnp.country.count, 0)
        XCTAssertGreaterThan(entry.mnp.international_formatted.count, 0)
        XCTAssertGreaterThan(entry.mnp.mccmnc.count, 0)
        XCTAssertGreaterThan(entry.mnp.national_format.count, 0)
        XCTAssertGreaterThan(entry.mnp.network.count, 0)
        XCTAssertEqual(entry.mnp.network, "Telekom Deutschland GmbH")
        XCTAssertGreaterThan(entry.mnp.number.count, 0)
        XCTAssertGreaterThanOrEqual(entry.code, 100)
        XCTAssertGreaterThanOrEqual(entry.price, Float(0))

        // TODO: add test for CNAM
        // TODO: add test for format
        // TODO: add test for HLR
    }

    func testPricing() {
        var params = PricingParams()

        let obj = initClient().pricing.get(params: params)!
        XCTAssertGreaterThanOrEqual(obj.countCountries, 0)
        XCTAssertGreaterThanOrEqual(obj.countNetworks, 0)
        XCTAssertEqual(obj.countCountries, obj.countries.count)

        for country in obj.countries {
            XCTAssertGreaterThan(country.countryName.count, 0)

            for network in country.networks {
                for feature in network.features {
                    XCTAssertGreaterThan(feature.count, 0)
                }
                XCTAssertGreaterThan(network.mcc.count, 0)
                for mncs in network.mncs {
                    XCTAssertGreaterThan(mncs.count, 0)
                }
                XCTAssertGreaterThan(network.price, Float(0))
            }
        }
    }

    func testSms() {
        // TODO: add test for deletion

        let client = initClient()
        let params = SmsParams(text: "HI2U!", to: "491716992343")
        let obj = client.sms.dispatch(params: params)

        XCTAssertGreaterThanOrEqual(obj.balance, 0)
        XCTAssertNotNil(obj.debug)
        XCTAssertNotNil(obj.sms_type)
        XCTAssertEqual(obj.success.count, 3)
        XCTAssertGreaterThanOrEqual(obj.total_price, Float(0))

        for msg in obj.messages {
            XCTAssertNotNil(msg.encoding)
            XCTAssertGreaterThan((msg.error ?? " ").count, 0)
            XCTAssertGreaterThan((msg.error_text ?? " ").count, 0)
            XCTAssertGreaterThan((msg.id ?? " ").count, 0)
            XCTAssertGreaterThan(msg.parts, 0)
            XCTAssertGreaterThanOrEqual(msg.price, Float(0))
            XCTAssertGreaterThan(msg.recipient.count, 0)
            XCTAssertGreaterThan(msg.sender.count, 0)
            XCTAssertNotNil(msg.success)
            XCTAssertGreaterThan(msg.text.count, 0)

            if nil != msg.messages {
                for message in msg.messages! {
                    XCTAssertGreaterThan(message.count, 0)
                }
            }
        }
    }

    func testStatus() {
        let client = initClient()
        let params = StatusParams(msg_id: "77133086945")
        let res = client.status.get(params: params)
        let entry = res.first

        XCTAssertGreaterThan(entry!.id.count, 0)
        XCTAssertGreaterThan(entry!.status.count, 0)
        XCTAssertGreaterThan(entry!.status_time.count, 0)
    }

    func testValidateForVoice() {
        let client = initClient()
        let params = ValidateForVoiceParams(number: "491716992343")
        let res = client.voice.validate(params: params)

        XCTAssertGreaterThan((res!.code ?? " ").count, 0)
        XCTAssertGreaterThan((res!.error ?? " ").count, 0)
        XCTAssertGreaterThan((res!.formatted_output ?? " ").count, 0)
        XCTAssertGreaterThan((res!.id ?? " ").count, 0)
        XCTAssertGreaterThan((res!.sender ?? " ").count, 0)
    }

    func testVoice() {
        let client = initClient()
        let params = VoiceParams(text: "Hey friend!", to: "491716992343")
        let res = client.voice.call(params: params)

        // TODO: implement assertions
    }
    
    func testSubaccountsRead() {
        let client = initClient()
        let subaccounts = client.subaccounts.read()!
        
        for subaccount in subaccounts {
            let amount = subaccount.auto_topup.amount
            let threshold = subaccount.auto_topup.threshold
            
            if (amount == nil) {
                XCTAssertNil(threshold)
            }
            else {
                XCTAssertGreaterThan(amount!, 0.0)
            }
        }
    }
    
    func testSubaccountsCreate() {
        let client = initClient()
        let createParams = SubaccountsCreateParams(email: "tom_test@seven.dev", name: "Tom Test")
        let createRes = client.subaccounts.create(params: createParams)!
        
        if (createRes.error == nil) {
            XCTAssertTrue(createRes.success)
        }
        else {
            XCTAssertFalse(createRes.success)
        }
    }
    
    func testSubaccountsDelete() {
        let client = initClient()
        let params = SubaccountsDeleteParams(id: 0)
        let res = client.subaccounts.delete(params: params)!

        XCTAssertNotNil(res.error)
        XCTAssertFalse(res.success)
    }

    func testSubaccounts() {
        let client = initClient()
        var subaccount: Subaccount? = nil
        
        // create
        let timestamp = Date().timeIntervalSince1970
        let email = String(timestamp) + "@seven.dev"
        let createParams = SubaccountsCreateParams(email: email, name: "Tom Test")
        let createRes = client.subaccounts.create(params: createParams)!
        
        if (createRes.error == nil) {
            subaccount = createRes.subaccount!
            
            XCTAssertTrue(createRes.success)
        }
        else {
            XCTAssertFalse(createRes.success)
        }
        
        // transfer credits
        
        let transferCreditsParams = SubaccountsTransferCreditsParams(id: subaccount!.id, amount: 1.0)
        let transferCreditsRes = client.subaccounts.transferCredits(params:transferCreditsParams)!
        
        if (transferCreditsRes.error == nil) {
            XCTAssertTrue(transferCreditsRes.success)
        }
        else {
            XCTAssertFalse(transferCreditsRes.success)
        }

        // auto charge

        let autoChargeParams = SubaccountsAutoChargeParams(id: subaccount!.id, amount: 1.0, threshold: 1.0)
        let autoChargeRes = client.subaccounts.autoCharge(params: autoChargeParams)!

        if (autoChargeRes.error == nil) {
            XCTAssertTrue(autoChargeRes.success)
        }
        else {
            XCTAssertFalse(autoChargeRes.success)
        }

        // delete

        let deleteParams = SubaccountsDeleteParams(id: subaccount!.id)
        let deleteRes = client.subaccounts.delete(params:deleteParams)!

        if (deleteRes.error == nil) {
            XCTAssertTrue(deleteRes.success)
        }
        else {
            XCTAssertFalse(deleteRes.success)
        }
    }
    
    func testGroups() {
        // TODO: test groups
    }
    
    func testNumbers() {
        // TODO: test Rcs
    }
    
    func testRcs() {
        // TODO: test Rcs
    }

    static var allTests = [
        ("testAnalyticsBySubaccount", testAnalyticsBySubaccount),
        ("testAnalyticsByLabel", testAnalyticsByLabel),
        ("testAnalyticsByCountry", testAnalyticsByCountry),
        ("testAnalyticsByDate", testAnalyticsByDate),
        ("testBalance", testBalance),
        ("testContacts", testContacts),
        ("testGroups", testGroups),
        ("testHooks", testHooks),
        ("testJournal", testJournal),
        ("testNumbers", testNumbers),
        ("testLookup", testLookup),
        ("testPricing", testPricing),
        ("testRcs", testRcs),
        ("testSms", testSms),
        ("testStatus", testStatus),
        ("testSubaccounts", testSubaccounts),
        ("testValidateForVoice", testValidateForVoice),
        ("testVoice", testVoice),
    ]
}
