//
//  ShopAPI.swift
//  Docent_swift
//
//  Created by 성재 on 2022/10/20.
//

import Foundation
import SwiftUI
import Firebase

class ShopAPI : ObservableObject {
    @Published var Top_key: String?
    @Published var Top_sent_gr : [SentModel]? = []
    @Published var Top_rand: Int?
    @Published var searchResult : Welcome?
    let jsonDecoder: JSONDecoder = JSONDecoder()


   // var Top_sent_grr: [SentModel] = []
    
    func getTop_key(id: String) {
        let db = Firestore.firestore()
        let ref = db.collection("rec")
        
        // 제목 가져오기
        ref.document(id).getDocument(completion: {(document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                //print("Document data: \(dataDescription)")
                let data = document.data()
                self.Top_key = data!["type"]! as? String ?? ""
                self.requestAPIToNaver(queryValue: self.Top_key ?? "")
//                print(self.Top_key!)
            } else {
                print("Docuement does not exist")
            }
        })
        
        // 문장 가져오기
        let rand = Int.random(in: 1...6)
        print("rand : \(rand)")
        self.Top_rand = rand
        let reff = ref.document(id)
        reff.collection("\(rand)").getDocuments(completion: {(querySnapshot, err) in
            if let err = err  {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    self.Top_sent_gr!.append(SentModel(sentence: data["sent"] as! String, emotion: rand, tone: document.documentID))
                }
            }
        })
        
    }
    
    
    func requestAPIToNaver(queryValue: String) {

        let clientID: String = "dm1QYQpHveKRAjzEN0ll"
        let clientKEY: String = "zvD2Bgl5nH"

        let query: String  = "https://openapi.naver.com/v1/search/shop.json?query=\(queryValue)"
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!

        var requestURL = URLRequest(url: queryURL)
        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
//        print(requestURL)

        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else { print(error); return }
            guard let data = data else { print(error); return }

            do {
//                print(String(data: data, encoding: .utf8))
                let searchInfo: Welcome = try self.jsonDecoder.decode(Welcome.self, from: data)
                DispatchQueue.main.async {
                    self.searchResult = searchInfo
                }
//                self.urlTaskDone()
            } catch {
                print(fatalError())
            }
        }
        task.resume()
    }
    
}
