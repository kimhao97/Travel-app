//
//  PersistentDataSaveable.swift
//  OlympicTokyo
//
//  Created by NeoLabx on 11/27/19.
//  Copyright © 2019 NeoLabx. All rights reserved.
//

protocol PersistentDataSaveable {
    func getItem(fromKey key: String) -> Any?
    func set(item: Any, toKey key: String)
}
