//
//  ApiManager.swift
//  CDSession
//
//  Created by mobile1 on 27/11/24.
//

import Foundation
import Alamofire

class ApiManager{
    let urlStr="https://official-joke-api.appspot.com/jokes/random/25"
    
    func fetchAF(completionHandler:@escaping(Result<[JokeModel],Error>)->Void){
        AF.request(urlStr).responseDecodable(of:[JokeModel].self){ response in
            switch response.result{
                case.success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
