//
//  ViewController.swift
//  SearchGitUsers
//
//  Created by 福田光祐 on 2018/04/12.
//  Copyright © 2018年 福田光祐. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var gitUserSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var jsonResults: GitUserList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "ユーザリスト"
        
        jsonResults = nil
        self.tableView.rowHeight = 100.0
        gitUserSearchBar.placeholder = "検索したいユーザ名を入力してください"
    }
    
    /// SearchBarの検索ボタンが押された時に呼ばれる
    ///
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        self.view.endEditing(true)
        
        // 検索文字列が空の場合は処理をしない
        let searchWord: String = searchBar.text!
        if searchWord == "" {return}
        
        // 検索ボックスのワードでgitのユーザを検索する
        // ※ RxSwiftを使用 ※
        GitApi().searchUsers(by: searchWord)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { data in
                    // APIからの戻り値がなければ処理を終了
//                    guard let responseData = data else{ return }
                    // Json解析
                    do {
                        self.jsonResults = try JSONDecoder().decode(GitUserList.self, from: data)
                        for gitUser in (self.jsonResults?.users)! {
                            print("name:" + gitUser.name)
                            print("htmlUrl:" + gitUser.htmlUrl)
                            print("type:" + gitUser.type)
                            print("avatarUrl:" + gitUser.avatarUrl)
                        }
                    } catch {
                        print("Json解析でエラー")
                    }
                    self.tableView.reloadData()
                },
                onError: { error in
                    
                }
            )
    }
    
    /// SearchBarのキャンセルボタンが押された時に呼ばれる
    ///
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // キャンセルされた場合、検索は行わない。
        searchBar.text = ""
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    /// 各セルの要素を設定する
    ///
    func tableView(_ table: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tableCell の ID で UITableViewCell のインスタンスを生成
        let cell = table.dequeueReusableCell(withIdentifier: "unitUserTableCell",
                                             for: indexPath)
        
        // Tag番号1
        let imageView = cell.viewWithTag(1) as! UIImageView
        let url: URL? = URL(string: (self.jsonResults?.users[indexPath.row].avatarUrl)!)
        do {
            let avatarData: Data? = try Data(contentsOf: url!)
            imageView.image = UIImage(data: avatarData!)
        } catch {
            print("画像取得失敗")
        }
        
        // Tag番号2
        let nameLabel = cell.viewWithTag(2) as! UILabel
        nameLabel.text = self.jsonResults?.users[indexPath.row].name
        
        // Tag番号3
        let typeLabel = cell.viewWithTag(3) as! UILabel
        typeLabel.text = self.jsonResults?.users[indexPath.row].type
        
        return cell
    }
    
    /// セルの数を決める
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let jsonResults = self.jsonResults {
            return jsonResults.users.count
        }
        return 0
    }
    
    /// セルをタップした時にWebを開く
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 遷移処理
        let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewController") as? WebViewController
        webViewController?.userName = self.jsonResults?.users[indexPath.row].name
        webViewController?.urlStr = self.jsonResults?.users[indexPath.row].htmlUrl
        self.navigationController?.pushViewController(webViewController!, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

