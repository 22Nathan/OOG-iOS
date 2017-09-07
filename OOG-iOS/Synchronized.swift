//
//  Synchronized.swift
//  OOG-iOS
//
//  Created by Nathan on 06/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

func synchronized(_ lock: Any, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
