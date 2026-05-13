//
//  APIClient.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct ApiResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T?
    let errors: [String]?

    init(success: Bool, message: String, data: T?, errors: [String]?) {
        self.success = success
        self.message = message
        self.data = data
        self.errors = errors
    }
}

struct PagedResponse<T: Decodable>: Decodable {
    let items: [T]
    let pageIndex: Int
    let pageSize: Int
    let totalItems: Int
    let totalPages: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
}

struct EmptyResponse: Decodable {}

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int, message: String?)
    case apiMessage(String, errors: [String]?)
    case emptyData(message: String)
    case decoding(Error)
    case transport(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .httpStatus(let statusCode, let message):
            return message ?? "Request failed with status code \(statusCode)."
        case .apiMessage(let message, let errors):
            return errors?.joined(separator: "\n") ?? message
        case .emptyData(let message):
            return message
        case .decoding(let error):
            return "Could not read server response: \(error.localizedDescription)"
        case .transport(let error):
            return error.localizedDescription
        }
    }
}

final class APIClient {
    static let shared = APIClient()

    var baseURL: URL
    var tokenProvider: () -> String?

    private let session: URLSession
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    init(
        baseURL: URL = URL(string: "http://192.168.253.1:2609")!,
        session: URLSession = .shared,
        tokenProvider: @escaping () -> String? = { nil }
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenProvider = tokenProvider

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.jsonEncoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(Self.decodeDate)
        self.jsonDecoder = decoder
    }

    func request<T: Decodable>(
        _ path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        responseType: T.Type = T.self
    ) async throws -> T {
        let response: ApiResponse<T> = try await send(
            path,
            method: method,
            queryItems: queryItems,
            responseType: responseType
        )

        guard let data = response.data else {
            throw APIError.emptyData(message: response.message)
        }

        return data
    }

    func request<T: Decodable, Body: Encodable>(
        _ path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = [],
        body: Body,
        responseType: T.Type = T.self
    ) async throws -> T {
        
        print("======== APIClient =======")
        print("\(Date()): path: \(path)")
        print("\(Date()): method: \(method)")
        print("\(Date()): queryItems: \(queryItems)")
        print("\(Date()): body: \(body)")
        print(".......")
        
        do {
            let response: ApiResponse<T> = try await send(
                path,
                method: method,
                queryItems: queryItems,
                body: body,
                responseType: responseType
            )
            
            print("\(Date()): response: \(response)")
            
            guard let data = response.data else {
                throw APIError.emptyData(message: response.message)
            }
            
            return data
            
        } catch {
            // Log error response
            print("❌ \(Date()): Request failed")
            print("❌ Error: \(error)")
            throw error
        }
    }

    func send<T: Decodable>(
        _ path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        responseType: T.Type = T.self
    ) async throws -> ApiResponse<T> {
        let request = try makeRequest(
            path,
            method: method,
            queryItems: queryItems,
            bodyData: nil
        )
        
        return try await perform(request, responseType: responseType)
    }

    func send<T: Decodable, Body: Encodable>(
        _ path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = [],
        body: Body,
        responseType: T.Type = T.self
    ) async throws -> ApiResponse<T> {
        let bodyData: Data

        do {
            bodyData = try jsonEncoder.encode(body)
        } catch {
            throw APIError.transport(error)
        }

        let request = try makeRequest(
            path,
            method: method,
            queryItems: queryItems,
            bodyData: bodyData
        )

        return try await perform(request, responseType: responseType)
    }

    func sendWithoutData(
        _ path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = []
    ) async throws -> ApiResponse<EmptyResponse> {
        try await send(
            path,
            method: method,
            queryItems: queryItems,
            responseType: EmptyResponse.self
        )
    }

    func sendWithoutData<Body: Encodable>(
        _ path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = [],
        body: Body
    ) async throws -> ApiResponse<EmptyResponse> {
        try await send(
            path,
            method: method,
            queryItems: queryItems,
            body: body,
            responseType: EmptyResponse.self
        )
    }

    private func makeRequest(
        _ path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem],
        bodyData: Data?
    ) throws -> URLRequest {
        let normalizedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        let endpointURL = baseURL.appending(path: normalizedPath)

        guard var components = URLComponents(url: endpointURL, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = tokenProvider(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let bodyData {
            request.httpBody = bodyData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    private func perform<T: Decodable>(
        _ request: URLRequest,
        responseType: T.Type
    ) async throws -> ApiResponse<T> {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorResponse = try? jsonDecoder.decode(ApiResponse<EmptyResponse>.self, from: data)
            throw APIError.httpStatus(httpResponse.statusCode, message: errorResponse?.message)
        }

        if data.isEmpty, T.self == EmptyResponse.self {
            return ApiResponse(success: true, message: "Success", data: nil, errors: nil)
        }

        do {
            let apiResponse = try jsonDecoder.decode(ApiResponse<T>.self, from: data)

            guard apiResponse.success else {
                throw APIError.apiMessage(apiResponse.message, errors: apiResponse.errors)
            }

            return apiResponse
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.decoding(error)
        }
    }

    private static func decodeDate(decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        let fractionalFormatter = ISO8601DateFormatter()
        fractionalFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = fractionalFormatter.date(from: dateString) {
            return date
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        if let date = formatter.date(from: dateString) {
            return date
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Invalid ISO8601 date: \(dateString)"
        )
    }
}

extension URLQueryItem {
    static func item(_ name: String, _ value: String?) -> URLQueryItem? {
        guard let value else { return nil }

        return URLQueryItem(name: name, value: value)
    }

    static func item(_ name: String, _ value: Int?) -> URLQueryItem? {
        guard let value else { return nil }

        return URLQueryItem(name: name, value: String(value))
    }

    static func item(_ name: String, _ value: Double?) -> URLQueryItem? {
        guard let value else { return nil }

        return URLQueryItem(name: name, value: String(value))
    }

    static func item(_ name: String, _ value: Bool?) -> URLQueryItem? {
        guard let value else { return nil }

        return URLQueryItem(name: name, value: value ? "true" : "false")
    }
}
