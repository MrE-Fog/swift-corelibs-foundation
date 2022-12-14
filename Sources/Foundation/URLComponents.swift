// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//


/// A structure designed to parse URLs based on RFC 3986 and to construct URLs from their constituent parts.
///
/// Its behavior differs subtly from the `URL` struct, which conforms to older RFCs. However, you can easily obtain a `URL` based on the contents of a `URLComponents` or vice versa.
public struct URLComponents : ReferenceConvertible, Hashable, Equatable, _MutableBoxing {
    public typealias ReferenceType = NSURLComponents
    
    internal var _handle: _MutableHandle<NSURLComponents>
    
    /// Initialize with all components undefined.
    public init() {
        _handle = _MutableHandle(adoptingReference: NSURLComponents())
    }
    
    /// Initialize with the components of a URL.
    ///
    /// If resolvingAgainstBaseURL is `true` and url is a relative URL, the components of url.absoluteURL are used. If the url string from the URL is malformed, nil is returned.
    public init?(url: URL, resolvingAgainstBaseURL resolve: Bool) {
        guard let result = NSURLComponents(url: url, resolvingAgainstBaseURL: resolve) else { return nil }
        _handle = _MutableHandle(adoptingReference: result)
    }
    
    /// Initialize with a URL string.
    ///
    /// If the URLString is malformed, nil is returned.
    public init?(string: String) {
        guard let result = NSURLComponents(string: string) else { return nil }
        _handle = _MutableHandle(adoptingReference: result)
    }
    
    /// Returns a URL created from the URLComponents.
    ///
    /// If the URLComponents has an authority component (user, password, host or port) and a path component, then the path must either begin with "/" or be an empty string. If the URLComponents does not have an authority component (user, password, host or port) and has a path component, the path component must not start with "//". If those requirements are not met, nil is returned.
    public var url: URL? {
        return _handle.map { $0.url }
    }
    
    /// Returns a URL created from the URLComponents relative to a base URL.
    ///
    /// If the URLComponents has an authority component (user, password, host or port) and a path component, then the path must either begin with "/" or be an empty string. If the URLComponents does not have an authority component (user, password, host or port) and has a path component, the path component must not start with "//". If those requirements are not met, nil is returned.
    public func url(relativeTo base: URL?) -> URL? {
        return _handle.map { $0.url(relativeTo: base) }
    }
    
    // Returns a URL string created from the URLComponents. If the URLComponents has an authority component (user, password, host or port) and a path component, then the path must either begin with "/" or be an empty string. If the URLComponents does not have an authority component (user, password, host or port) and has a path component, the path component must not start with "//". If those requirements are not met, nil is returned.
    public var string: String? {
        return _handle.map { $0.string }
    }
    
    /// The scheme subcomponent of the URL.
    ///
    /// The getter for this property removes any percent encoding this component may have (if the component allows percent encoding). Setting this property assumes the subcomponent or component string is not percent encoded and will add percent encoding (if the component allows percent encoding).
    /// Attempting to set the scheme with an invalid scheme string will cause an exception.
    public var scheme: String? {
        get { return _handle.map { $0.scheme } }
        set { _applyMutation { $0.scheme = newValue } }
    }
    
    /// The user subcomponent of the URL.
    ///
    /// The getter for this property removes any percent encoding this component may have (if the component allows percent encoding). Setting this property assumes the subcomponent or component string is not percent encoded and will add percent encoding (if the component allows percent encoding).
    ///
    /// Warning: IETF STD 66 (rfc3986) says the use of the format "user:password" in the userinfo subcomponent of a URI is deprecated because passing authentication information in clear text has proven to be a security risk. However, there are cases where this practice is still needed, and so the user and password components and methods are provided.
    public var user: String? {
        get { return _handle.map { $0.user } }
        set { _applyMutation { $0.user = newValue } }
    }
    
    /// The password subcomponent of the URL.
    ///
    /// The getter for this property removes any percent encoding this component may have (if the component allows percent encoding). Setting this property assumes the subcomponent or component string is not percent encoded and will add percent encoding (if the component allows percent encoding).
    ///
    /// Warning: IETF STD 66 (rfc3986) says the use of the format "user:password" in the userinfo subcomponent of a URI is deprecated because passing authentication information in clear text has proven to be a security risk. However, there are cases where this practice is still needed, and so the user and password components and methods are provided.
    public var password: String? {
        get { return _handle.map { $0.password } }
        set { _applyMutation { $0.password = newValue } }
    }
    
    /// The host subcomponent.
    ///
    /// The getter for this property removes any percent encoding this component may have (if the component allows percent encoding). Setting this property assumes the subcomponent or component string is not percent encoded and will add percent encoding (if the component allows percent encoding).
    public var host: String? {
        get { return _handle.map { $0.host } }
        set { _applyMutation { $0.host = newValue } }
    }
    
    /// The port subcomponent.
    ///
    /// The getter for this property removes any percent encoding this component may have (if the component allows percent encoding). Setting this property assumes the subcomponent or component string is not percent encoded and will add percent encoding (if the component allows percent encoding).
    /// Attempting to set a negative port number will cause a fatal error.
    public var port: Int? {
        get { return _handle.map { $0.port?.intValue } }
        set { _applyMutation { $0.port = newValue != nil ? NSNumber(value: newValue!) : nil as NSNumber?} }
    }
    
    /// The path subcomponent.
    ///
    /// The getter for this property removes any percent encoding this component may have (if the component allows percent encoding). Setting this property assumes the subcomponent or component string is not percent encoded and will add percent encoding (if the component allows percent encoding).
    public var path: String {
        get {
            return _handle.map { $0.path } ?? ""
        }
        set {
            _applyMutation { $0.path = newValue }
        }
    }
    
    /// The query subcomponent.
    ///
    /// The getter for this property removes any percent encoding this component may have (if the component allows percent encoding). Setting this property assumes the subcomponent or component string is not percent encoded and will add percent encoding (if the component allows percent encoding).
    public var query: String? {
        get { return _handle.map { $0.query } }
        set { _applyMutation { $0.query = newValue } }
    }
    
    /// The fragment subcomponent.
    ///
    /// The getter for this property removes any percent encoding this component may have (if the component allows percent encoding). Setting this property assumes the subcomponent or component string is not percent encoded and will add percent encoding (if the component allows percent encoding).
    public var fragment: String? {
        get { return _handle.map { $0.fragment } }
        set { _applyMutation { $0.fragment = newValue } }
    }
    
    
    /// The user subcomponent, percent-encoded.
    ///
    /// The getter for this property retains any percent encoding this component may have. Setting this properties assumes the component string is already correctly percent encoded. Attempting to set an incorrectly percent encoded string will cause a `fatalError`. Although ';' is a legal path character, it is recommended that it be percent-encoded for best compatibility with `URL` (`String.addingPercentEncoding(withAllowedCharacters:)` will percent-encode any ';' characters if you pass `CharacterSet.urlUserAllowed`).
    public var percentEncodedUser: String? {
        get { return _handle.map { $0.percentEncodedUser } }
        set { _applyMutation { $0.percentEncodedUser = newValue } }
    }
    
    /// The password subcomponent, percent-encoded.
    ///
    /// The getter for this property retains any percent encoding this component may have. Setting this properties assumes the component string is already correctly percent encoded. Attempting to set an incorrectly percent encoded string will cause a `fatalError`. Although ';' is a legal path character, it is recommended that it be percent-encoded for best compatibility with `URL` (`String.addingPercentEncoding(withAllowedCharacters:)` will percent-encode any ';' characters if you pass `CharacterSet.urlPasswordAllowed`).
    public var percentEncodedPassword: String? {
        get { return _handle.map { $0.percentEncodedPassword } }
        set { _applyMutation { $0.percentEncodedPassword = newValue } }
    }
    
    /// The host subcomponent, percent-encoded.
    ///
    /// The getter for this property retains any percent encoding this component may have. Setting this properties assumes the component string is already correctly percent encoded. Attempting to set an incorrectly percent encoded string will cause a `fatalError`. Although ';' is a legal path character, it is recommended that it be percent-encoded for best compatibility with `URL` (`String.addingPercentEncoding(withAllowedCharacters:)` will percent-encode any ';' characters if you pass `CharacterSet.urlHostAllowed`).
    public var percentEncodedHost: String? {
        get { return _handle.map { $0.percentEncodedHost } }
        set { _applyMutation { $0.percentEncodedHost = newValue } }
    }
    
    /// The path subcomponent, percent-encoded.
    ///
    /// The getter for this property retains any percent encoding this component may have. Setting this properties assumes the component string is already correctly percent encoded. Attempting to set an incorrectly percent encoded string will cause a `fatalError`. Although ';' is a legal path character, it is recommended that it be percent-encoded for best compatibility with `URL` (`String.addingPercentEncoding(withAllowedCharacters:)` will percent-encode any ';' characters if you pass `CharacterSet.urlPathAllowed`).
    public var percentEncodedPath: String {
        get {
            return _handle.map { $0.percentEncodedPath } ?? ""
        }
        set {
            _applyMutation { $0.percentEncodedPath = newValue }
        }
    }
    
    /// The query subcomponent, percent-encoded.
    ///
    /// The getter for this property retains any percent encoding this component may have. Setting this properties assumes the component string is already correctly percent encoded. Attempting to set an incorrectly percent encoded string will cause a `fatalError`. Although ';' is a legal path character, it is recommended that it be percent-encoded for best compatibility with `URL` (`String.addingPercentEncoding(withAllowedCharacters:)` will percent-encode any ';' characters if you pass `CharacterSet.urlQueryAllowed`).
    public var percentEncodedQuery: String? {
        get { return _handle.map { $0.percentEncodedQuery } }
        set { _applyMutation { $0.percentEncodedQuery = newValue } }
    }
    
    /// The fragment subcomponent, percent-encoded.
    ///
    /// The getter for this property retains any percent encoding this component may have. Setting this properties assumes the component string is already correctly percent encoded. Attempting to set an incorrectly percent encoded string will cause a `fatalError`. Although ';' is a legal path character, it is recommended that it be percent-encoded for best compatibility with `URL` (`String.addingPercentEncoding(withAllowedCharacters:)` will percent-encode any ';' characters if you pass `CharacterSet.urlFragmentAllowed`).
    public var percentEncodedFragment: String? {
        get { return _handle.map { $0.percentEncodedFragment } }
        set { _applyMutation { $0.percentEncodedFragment = newValue } }
    }
    
    private func _toStringRange(_ r : NSRange) -> Range<String.Index>? {
        guard let s = self.string, r.location != NSNotFound else { return nil }
        let start = String.Index(utf16Offset: r.location, in: s)
        let end = String.Index(utf16Offset: r.location + r.length, in: s)
        return start..<end
    }
    
    /// Returns the character range of the scheme in the string returned by `var string`.
    ///
    /// If the component does not exist, nil is returned.
    /// - note: Zero length components are legal. For example, the URL string "scheme://:@/?#" has a zero length user, password, host, query and fragment; the URL strings "scheme:" and "" both have a zero length path.
    public var rangeOfScheme: Range<String.Index>? {
        return _toStringRange(_handle.map { $0.rangeOfScheme })
    }
    
    /// Returns the character range of the user in the string returned by `var string`.
    ///
    /// If the component does not exist, nil is returned.
    /// - note: Zero length components are legal. For example, the URL string "scheme://:@/?#" has a zero length user, password, host, query and fragment; the URL strings "scheme:" and "" both have a zero length path.
    public var rangeOfUser: Range<String.Index>? {
        return _toStringRange(_handle.map { $0.rangeOfUser})
    }
    
    /// Returns the character range of the password in the string returned by `var string`.
    ///
    /// If the component does not exist, nil is returned.
    /// - note: Zero length components are legal. For example, the URL string "scheme://:@/?#" has a zero length user, password, host, query and fragment; the URL strings "scheme:" and "" both have a zero length path.
    public var rangeOfPassword: Range<String.Index>? {
        return _toStringRange(_handle.map { $0.rangeOfPassword})
    }
    
    /// Returns the character range of the host in the string returned by `var string`.
    ///
    /// If the component does not exist, nil is returned.
    /// - note: Zero length components are legal. For example, the URL string "scheme://:@/?#" has a zero length user, password, host, query and fragment; the URL strings "scheme:" and "" both have a zero length path.
    public var rangeOfHost: Range<String.Index>? {
        return _toStringRange(_handle.map { $0.rangeOfHost})
    }
    
    /// Returns the character range of the port in the string returned by `var string`.
    ///
    /// If the component does not exist, nil is returned.
    /// - note: Zero length components are legal. For example, the URL string "scheme://:@/?#" has a zero length user, password, host, query and fragment; the URL strings "scheme:" and "" both have a zero length path.
    public var rangeOfPort: Range<String.Index>? {
        return _toStringRange(_handle.map { $0.rangeOfPort})
    }
    
    /// Returns the character range of the path in the string returned by `var string`.
    ///
    /// If the component does not exist, nil is returned.
    /// - note: Zero length components are legal. For example, the URL string "scheme://:@/?#" has a zero length user, password, host, query and fragment; the URL strings "scheme:" and "" both have a zero length path.
    public var rangeOfPath: Range<String.Index>? {
        return _toStringRange(_handle.map { $0.rangeOfPath})
    }
    
    /// Returns the character range of the query in the string returned by `var string`.
    ///
    /// If the component does not exist, nil is returned.
    /// - note: Zero length components are legal. For example, the URL string "scheme://:@/?#" has a zero length user, password, host, query and fragment; the URL strings "scheme:" and "" both have a zero length path.
    public var rangeOfQuery: Range<String.Index>? {
        return _toStringRange(_handle.map { $0.rangeOfQuery})
    }
    
    /// Returns the character range of the fragment in the string returned by `var string`.
    ///
    /// If the component does not exist, nil is returned.
    /// - note: Zero length components are legal. For example, the URL string "scheme://:@/?#" has a zero length user, password, host, query and fragment; the URL strings "scheme:" and "" both have a zero length path.
    public var rangeOfFragment: Range<String.Index>? {
        return _toStringRange(_handle.map { $0.rangeOfFragment})
    }
    
    /// Returns an array of query items for this `URLComponents`, in the order in which they appear in the original query string.
    ///
    /// Each `URLQueryItem` represents a single key-value pair,
    ///
    /// Note that a name may appear more than once in a single query string, so the name values are not guaranteed to be unique. If the `URLComponents` has an empty query component, returns an empty array. If the `URLComponents` has no query component, returns nil.
    ///
    /// The setter combines an array containing any number of `URLQueryItem`s, each of which represents a single key-value pair, into a query string and sets the `URLComponents` query property. Passing an empty array sets the query component of the `URLComponents` to an empty string. Passing nil removes the query component of the `URLComponents`.
    ///
    /// - note: If a name-value pair in a query is empty (i.e. the query string starts with '&', ends with '&', or has "&&" within it), you get a `URLQueryItem` with a zero-length name and and a nil value. If a query's name-value pair has nothing before the equals sign, you get a zero-length name. If a query's name-value pair has nothing after the equals sign, you get a zero-length value. If a query's name-value pair has no equals sign, the query name-value pair string is the name and you get a nil value.
    public var queryItems: [URLQueryItem]? {
        get { return _handle.map { $0.queryItems } }
        set { _applyMutation { $0.queryItems = newValue } }
    }
    
    /// Returns an array of query items for this `URLComponents`, in the order in which they appear in the original query string. Any percent-encoding in a query item name or value is retained
    ///
    /// The setter combines an array containing any number of `URLQueryItem`s, each of which represents a single key-value pair, into a query string and sets the `URLComponents` query property. This property assumes the query item names and values are already correctly percent-encoded, and that the query item names do not contain the query item delimiter characters '&' and '='. Attempting to set an incorrectly percent-encoded query item or a query item name with the query item delimiter characters '&' and '=' will cause a `fatalError`.
    public var percentEncodedQueryItems: [URLQueryItem]? {
        get { return _handle.map { $0.percentEncodedQueryItems } }
        set { _applyMutation { $0.percentEncodedQueryItems = newValue } }
    }

public func hash(into hasher: inout Hasher) {
        hasher.combine(_handle.map { $0 })
    }

    // MARK: - Bridging
    
    fileprivate init(reference: NSURLComponents) {
        _handle = _MutableHandle(reference: reference)
    }
    
    public static func ==(lhs: URLComponents, rhs: URLComponents) -> Bool {
        // Don't copy references here; no one should be storing anything
        return lhs._handle._uncopiedReference().isEqual(rhs._handle._uncopiedReference())
    }
}

extension URLComponents : CustomStringConvertible, CustomDebugStringConvertible, CustomReflectable {
    public var description: String {
        if let u = url {
            return u.description
        } else {
            return self.customMirror.children.reduce("") {
                $0.appending("\($1.label ?? ""): \($1.value) ")
            }
        }
    }
    
    public var debugDescription: String {
        return self.description
    }
    
    public var customMirror: Mirror {
        var c: [(label: String?, value: Any)] = []
        
        if let s = self.scheme { c.append((label: "scheme", value: s)) }
        if let u = self.user { c.append((label: "user", value: u)) }
        if let pw = self.password { c.append((label: "password", value: pw)) }
        if let h = self.host { c.append((label: "host", value: h)) }
        if let p = self.port { c.append((label: "port", value: p)) }
        
        c.append((label: "path", value: self.path))
        if #available(macOS 10.10, iOS 8.0, *) {
            if let qi = self.queryItems { c.append((label: "queryItems", value: qi )) }
        }
        if let f = self.fragment { c.append((label: "fragment", value: f)) }
        let m = Mirror(self, children: c, displayStyle: .struct)
        return m
    }
}

extension NSURLComponents : _SwiftBridgeable {
    typealias SwiftType = URLComponents
    internal var _swiftObject: SwiftType { return URLComponents(reference: self) }
}

extension URLComponents : _NSBridgeable {
    typealias NSType = NSURLComponents
    internal var _nsObject: NSType { return _handle._copiedReference() }
}

extension URLComponents : _ObjectiveCBridgeable {
    public typealias _ObjectType = NSURLComponents
    
    public static func _getObjectiveCType() -> Any.Type {
        return NSURLComponents.self
    }
    
    @_semantics("convertToObjectiveC")
    public func _bridgeToObjectiveC() -> NSURLComponents {
        return _handle._copiedReference()
    }
    
    public static func _forceBridgeFromObjectiveC(_ x: NSURLComponents, result: inout URLComponents?) {
        if !_conditionallyBridgeFromObjectiveC(x, result: &result) {
            fatalError("Unable to bridge \(_ObjectType.self) to \(self)")
        }
    }
    
    public static func _conditionallyBridgeFromObjectiveC(_ x: NSURLComponents, result: inout URLComponents?) -> Bool {
        result = URLComponents(reference: x)
        return true
    }
    
    public static func _unconditionallyBridgeFromObjectiveC(_ source: NSURLComponents?) -> URLComponents {
        var result: URLComponents? = nil
        _forceBridgeFromObjectiveC(source!, result: &result)
        return result!
    }
}

extension URLComponents : Codable {
    private enum CodingKeys : Int, CodingKey {
        case scheme
        case user
        case password
        case host
        case port
        case path
        case query
        case fragment
    }

    public init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.scheme = try container.decodeIfPresent(String.self, forKey: .scheme)
        self.user = try container.decodeIfPresent(String.self, forKey: .user)
        self.password = try container.decodeIfPresent(String.self, forKey: .password)
        self.host = try container.decodeIfPresent(String.self, forKey: .host)
        self.port = try container.decodeIfPresent(Int.self, forKey: .port)
        self.path = try container.decode(String.self, forKey: .path)
        self.query = try container.decodeIfPresent(String.self, forKey: .query)
        self.fragment = try container.decodeIfPresent(String.self, forKey: .fragment)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.scheme, forKey: .scheme)
        try container.encodeIfPresent(self.user, forKey: .user)
        try container.encodeIfPresent(self.password, forKey: .password)
        try container.encodeIfPresent(self.host, forKey: .host)
        try container.encodeIfPresent(self.port, forKey: .port)
        try container.encode(self.path, forKey: .path)
        try container.encodeIfPresent(self.query, forKey: .query)
        try container.encodeIfPresent(self.fragment, forKey: .fragment)
    }
}
