//
//  JSONService.swift
//  PryanikMVVM
//
//  Created by Владимир on 03.02.2021.
//

import Foundation
import Moya

enum JSONService:TargetType {
    
    case getData
    case getImage(url: String)
    
    var baseURL: URL {
        switch self {
        case .getData:
            return URL(string: "https://pryaniky.com/static/json")!
        case .getImage(let url):
            return URL(string: url)!
        }
    }
    
    var path: String {
        switch self {
        case .getData:
            return "/sample.json"
        case .getImage(_):
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        switch self {
        case .getData:
            return .requestPlain
        case .getImage(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

struct DataView: Decodable {
    let data: [NameData]
    let view: [String]
}

struct NameData: Decodable {
    let name: String
    let data: DataDescription
}

struct DataDescription: Decodable {
    let text: String?
    let url: String?
    let selectedId: Int?
    let variants: [Variants]?
}

struct Variants: Decodable {
    let id: Int
    let text: String
}


