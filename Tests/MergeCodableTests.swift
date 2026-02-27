import Testing
@testable import MergeCodablePackage

struct SampleConfig: MergeCodable {
    var name: String = "default"
    var count: Int = 0
}

@Test func decodeValid() {
    let json = #"{"name":"hello","count":42}"#.data(using: .utf8)!
    let config = SampleConfig.decode(from: json)
    #expect(config.name == "hello")
    #expect(config.count == 42)
}

@Test func decodeMergesWithDefaults() {
    // JSON missing "count" should use default value
    let json = #"{"name":"saved"}"#.data(using: .utf8)!
    let config = SampleConfig.decode(from: json)
    #expect(config.name == "saved")
    #expect(config.count == 0)
}

@Test func encodeRoundTrip() {
    // Encode and decode
    var config = SampleConfig()
    config.name = "test"
    config.count = 7
    let data = config.encode()!
    let decoded = SampleConfig.decode(from: data)
    #expect(decoded.name == "test")
    #expect(decoded.count == 7)
}

