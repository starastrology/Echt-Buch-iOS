//
//  Friendship.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 4/14/22.
//

import Foundation

struct Friendship: Codable {
    let ind1, ind2: Individual
    let pending: Bool
}
