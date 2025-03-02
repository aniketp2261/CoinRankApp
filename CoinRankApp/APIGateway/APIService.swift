//
//  APIService.swift
//  CoinRankApp
//
//  Created by Aniket Patil on 02/03/25.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    static func getHeaderParams() -> [String : String] {
        return  ["x-access-token": "coinrankinge4d11119b1d460c22f73cd72c1bece64772612c25672e885"]
    }
    
    func GetRequest(url:String, time:TimeInterval? = 0.0, onCompletion:@escaping(Data?,Error?)-> Void){
        guard let APIUrl = URL(string: url) else {return}
        var urlRequest = URLRequest(url: APIUrl)
        urlRequest.httpMethod = "GET"
        let headers = APIService.getHeaderParams()
        for (key,value) in headers{
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.timeoutInterval = time!
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
            print("Result-", res)
            if error != nil{
                onCompletion(nil, error)
            } else {
                print("Result2-",try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers))
                onCompletion(data, nil)
            }
        }
        task.resume()
    }
    
    func PostRequest(url:String, body:[String:Any], time:TimeInterval? = 0.0, onCompletion:@escaping(Data?,Error?)-> Void){
        guard let APIUrl = URL(string: url) else {return}
        var urlRequest = URLRequest(url: APIUrl)
        urlRequest.httpMethod = "POST"
        let headers = APIService.getHeaderParams()
        for (key,value) in headers{
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.timeoutInterval = time!
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            urlRequest.httpBody = jsonData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Error creating JSON data: \(error)")
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
            print("Result-", res)
            if error != nil{
                onCompletion(nil, error)
            } else {
                print("Result2-",try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers))
                onCompletion(data, nil)
            }
        }
        task.resume()
    }

}
