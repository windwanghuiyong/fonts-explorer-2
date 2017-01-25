//
//  RootViewController.swift
//  FontsExplorer2
//
//  Created by wanghuiyong on 25/01/2017.
//  Copyright © 2017 Personal Organization. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {
    private var familyNames: [String]!
    private var cellPointSize: CGFloat!
    private var favoritesList: FavoritesList!
    private let familyCell = "FamilyName"
    private let favoritesCell = "Favorites"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferredTableViewFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)	// 获取标题字体大小
        
        familyNames = UIFont.familyNames.sorted() as [String]
        cellPointSize = preferredTableViewFont.pointSize	
        favoritesList = FavoritesList.sharedFavoritesList	// 引用收藏列表
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return favoritesList.favorites.isEmpty ? 1 : 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? familyNames.count : 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "All Font Families" : "My Favorite Fonts"
    }
    
    // 从其他视图回到根视图时, 重新加载表视图, 以显示新增的收藏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: familyCell, for: indexPath) // as UITableViewCell
            cell.textLabel?.font = fontForDisplay(atIndexPath: indexPath)
            cell.textLabel?.text = familyNames[indexPath.row]
            cell.detailTextLabel?.text = familyNames[indexPath.row]
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: favoritesCell, for: indexPath) // as UITableViewCell
        }
    }
    
    func fontForDisplay(atIndexPath indexPath: IndexPath) -> UIFont? {
        if indexPath.section == 0 {
            let familyName = familyNames[indexPath.row]
            let fontName = UIFont.fontNames(forFamilyName: familyName).first // as String
            
            return UIFont(name: fontName!, size: cellPointSize)
        } else {
            return nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let listViewController = segue.destination as! FontListViewController
        
        if indexPath.section == 0 {
            let familyName = familyNames[indexPath.row]
            listViewController.fontNames = UIFont.fontNames(forFamilyName: familyName).sorted()
            listViewController.navigationItem.title = familyName
            listViewController.showsFavorites = false
        } else {
            listViewController.fontNames = favoritesList.favorites
            listViewController.navigationItem.title = "Favorites"
            listViewController.showsFavorites = true
        }
    }
}
