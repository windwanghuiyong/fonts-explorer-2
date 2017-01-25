//
//  FavoritesList.swift
//  FontsExplorer2
//
//  Created by wanghuiyong on 25/01/2017.
//  Copyright © 2017 Personal Organization. All rights reserved.
//

import Foundation
import UIKit

// 收藏列表, 基类
class FavoritesList {
    class var sharedFavoritesList: FavoritesList {	// 只读的计算型的类型属性
        struct Singleton {
    		static let instance = FavoritesList()	// 结构体的存储型静态属性, 在需要时初始化(线程安全)
		}
        return Singleton.instance	// 返回同一个类实例
    }
    
    private(set) var favorites:[String]				// 收藏内容的数组, set 表示可以在类外读取
    
    init() {
        // 使用用户默认设置初始化收藏列表数组
        let defaults = UserDefaults.standard
        let storedFavorites = defaults.object(forKey: "favorites") as? [String]
        favorites = storedFavorites != nil ? storedFavorites! : []
    }
    
    func addFavorite(fontName: String) {
        if !favorites.contains(fontName) {
            favorites.append(fontName)
            saveFavorites()
        }
    }
    
    func removeFavorite(fontName: String) {
        if let index = favorites.index(of: fontName) {
            favorites.remove(at: index)
            saveFavorites()
        }
    }
    
    private func saveFavorites() {
        let defaults = UserDefaults.standard
        defaults.set(favorites, forKey: "favorites")
        defaults.synchronize()
    }
}
