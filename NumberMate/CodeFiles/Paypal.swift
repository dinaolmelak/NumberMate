//
//  Paypal.swift
//  NumberMate
//
//  Created by Dinaol Melak on 10/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import Foundation


class Payment{
        let price  = 25
        let senderItemId = 202003140001 // 201403140001
        func getToken(Token completion: @escaping (String)-> Void){
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = "grant_type=client_credentials"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.sandbox.paypal.com/v1/oauth2/token")!,timeoutInterval: Double.infinity)
        request.addValue("Basic QWJ4aUhTaWM5cmp2NUpQdEV2WUhaMi1hWmVySWFoTHdDVDEza004UURLY3RMWGtXN3lpTFRfVGpFVllVMXB5NFhKcGtxXzdYSVpYRmhkaFc6RVBUbUVZSWg2OE1FVG9FSjEyT0lHdzFKWkFGNTVza2Q2SjNiRmpLYkxMTEJiOTY3akRhQkdRREt1S29yTWN4amZ3Rm00X0VCa1dvUzJkejM=", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          //print(String(data: data, encoding: .utf8)!)
            let my4Data = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            let accessToken = my4Data["access_token"] as! String
            
            completion(accessToken)
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    func pay(BatchID batchID: Int, Token token: String,Email email:String){
        let semaphore = DispatchSemaphore (value: 0)
        
        let parameters = "{\n  \"sender_batch_header\": {\n    \"sender_batch_id\": \"\(batchID)\",\n    \"recipient_type\": \"EMAIL\",\n    \"email_subject\": \"You have money Dinaol!\",\n    \"email_message\": \"You received a payment. Thanks for using NumberMate!\"\n  },\n  \"items\": [\n    {\n      \"amount\": {\n        \"value\": \"\(String(price))\",\n        \"currency\": \"USD\"\n      },\n      \"sender_item_id\": \"\(senderItemId)\",\n      \"recipient_wallet\": \"PAYPAL\",\n      \"receiver\": \"\(email)\"\n    }\n  ]\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.sandbox.paypal.com/v1/payments/payouts")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    
    
    
}
