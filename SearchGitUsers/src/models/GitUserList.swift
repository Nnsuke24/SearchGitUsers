//
//  GitUserList.swift
//  SearchGitUsers
//
//  Created by 福田光祐 on 2018/04/15.
//  Copyright © 2018年 福田光祐. All rights reserved.
//

import Foundation

/// GitUserのリストを格納する構造体
///
struct GitUserList: Codable {
    let users: [GitUser]
    enum CodingKeys: String, CodingKey {
        case users = "items"
    }
}
