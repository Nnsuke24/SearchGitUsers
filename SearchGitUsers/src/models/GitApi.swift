//
//  GitApi.swift
//  SearchGitUsers
//
//  Created by 福田光祐 on 2018/04/15.
//  Copyright © 2018年 福田光祐. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GitApi {
    
    
    /// gitのユーザ情報を取得する関数
    ///
    /// - Parameter searchWord: ユーザ名（ID）
    func searchUsers(by searchWord:String) -> Observable<Data> {
        return Observable.create { observer in
            
            // API通信処理で使用するURLを作成
            var gitUrlStr: String = "https://api.github.com/search/users?q="
            gitUrlStr += searchWord
            gitUrlStr = gitUrlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            print(gitUrlStr)
            let url: URL = URL(string: gitUrlStr)!
            
            var jsonResults: GitUserList?
            // URLRequestを生成してJSONのデータを取得
            let request: URLRequest = URLRequest(url: url)
            let session = URLSession.shared
            let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
//                    observer.onError(error ?? MyError.FailedToFetchServerData)
                }
            })
            task.resume()
            return Disposables.create { print("Disposed") }
        }
    }
    
//    func searchUsers(by searchWord:String) -> GitUserList? {
//        // API通信処理で使用するURLを作成
//        var gitUrlStr: String = "https://api.github.com/search/users?q="
//        gitUrlStr += searchWord
//        gitUrlStr = gitUrlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//        print(gitUrlStr)
//        let url: URL = URL(string: gitUrlStr)!
//
//        var jsonResults: GitUserList?
//        // URLRequestを生成してJSONのデータを取得
//        let request: URLRequest = URLRequest(url: url)
//        let session = URLSession.shared
//        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
//
//            // APIからの戻り値がなければ処理を終了
//            guard let responseData = data else{ return }
//
//            // Json解析
//            do {
//                jsonResults = try JSONDecoder().decode(GitUserList.self, from: responseData)
//                for gitUser in (jsonResults?.users)! {
//                    print("name:" + gitUser.name)
//                    print("htmlUrl:" + gitUser.htmlUrl)
//                    print("type:" + gitUser.type)
//                    print("avatarUrl:" + gitUser.avatarUrl)
//                }
//
//            } catch {
//                print("Json解析でエラー")
//            }
//
//            DispatchQueue.main.async {
//                // セルの値を更新
//                //                self.tableView.reloadData()
//            }
//        })
//        task.resume()
//
//        return jsonResults
//    }
}
