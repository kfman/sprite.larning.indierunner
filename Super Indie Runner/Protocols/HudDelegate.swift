//
//  HudDelegate.swift
//  Super Indie Runner
//
//  Created by Klaus Fischer on 29.11.20.
//

import Foundation


protocol HudDelegate {
    func updateCoinLabel(coins: Int)
    func addSuperCoin(index: Int)
}
