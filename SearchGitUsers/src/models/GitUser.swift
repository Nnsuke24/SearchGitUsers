//
//  GitUser.swift
//  SearchGitUsers
//
//  Created by 福田光祐 on 2018/04/15.
//  Copyright © 2018年 福田光祐. All rights reserved.
//

import Foundation

/// gitユーザー情報を格納する構造体
///
struct GitUser: Codable{
    var name: String
    var htmlUrl: String
    var type: String
    var avatarUrl: String
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case htmlUrl = "html_url"
        case type
        case avatarUrl = "avatar_url"
    }
}

