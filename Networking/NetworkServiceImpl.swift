//
//  NetworkServiceImpl.swift
//  Networking
//
//  Created by Konstantin Lyashenko on 29.04.2025.
//

import Foundation

public class NetworkServiceImpl: NetworkService {

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<T: Decodable>(url: URL,
                                      completion: @escaping (Result<T, NetworkError>) -> Void) {

        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(.requestFailed(error)))
                return
            }
            guard let http = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            guard (200...299).contains(http.statusCode) else {
                completion(.failure(.httpError(statusCode: http.statusCode)))
                return
            }
            guard let data else {
                completion(.failure(.emptyData))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }
}
