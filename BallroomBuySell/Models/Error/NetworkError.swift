//
//  NetworkError.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-07-23.
//

enum NetworkError: Error {
    case notConnected // Phone is not connected to the network
    case notFound // GET failed operation
    case accessFailure // PUT or DELETE failed operation
    case internalSystemError // Database/File issue
    
    var errorMessageLocalizedKey: String {
        "alert.network.message"
    }
}
