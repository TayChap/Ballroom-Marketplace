//
//  NetworkError.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-07-23.
//

enum NetworkError: Error {
    case notConnected
    case notFound
    case accessFailure
    
    var errorMessage: String {
        LocalizedString.string(errorMessageLocalizedKey)
    }
    
    private var errorMessageLocalizedKey: String {
        "network.error"
    }
}
