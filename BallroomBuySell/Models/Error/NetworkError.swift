//
//  NetworkError.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-07-23.
//

enum NetworkError: Error { // TODO! move error message keys into here so more informative / standardized
    case notConnected
    case notFound
}
