//
//  Network.swift
//  Network
//
//  Created by Konstantin Lyashenko on 01.04.2025.
//

import Foundation

public protocol NetworkService {
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}
