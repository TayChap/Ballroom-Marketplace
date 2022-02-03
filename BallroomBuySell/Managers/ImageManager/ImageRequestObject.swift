//
//  ImageRequestObject.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-15.
//

import UIKit

struct ImageRequestObject {
    var url: String
    var success: (_ image: Data/*, _ fileName: String*/) -> Void // TODO! remove fileName
}
