//
//  JsonViewsViewModel.swift
//  PryanikMVVM
//
//  Created by Владимир on 04.02.2021.
//

import Foundation
import Moya

class JsonViewsViewModel {
    let provider = MoyaProvider<JSONService>()
    
    func getDataFromServer(result1: @escaping(DataView) -> Void) {
        provider.request(.getData) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(DataView.self)
                    result1(data)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
    }
    
    func getImageFromServer(url: String, result1: @escaping(UIImage?) -> Void) {
        provider.request(.getImage(url: url)) { result in
            switch result {
            case .success(let response):
                let data = response.data
                result1(UIImage(data: data))
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
    }
}
