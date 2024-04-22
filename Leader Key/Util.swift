//
//  Util.swift
//  Leader Key
//
//  Created by Mikkel Malmberg on 22/04/2024.
//

import Foundation

func delay(_ milliseconds: Int, callback: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: callback)
}
