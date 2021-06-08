//
//  ViewController.swift
//  BookReport
//
//  Created by 이예민 on 2021/06/05.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
        }
    }
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var searchResultLabel2: UILabel!
    
    @IBAction func tourchUpSearchButton(_ sender: Any) {
        let queryValue: String = searchField.text!
        requestAPIToNaver(queryValue: queryValue)
        view.endEditing(true)
    }
    
    let jsconDecoder: JSONDecoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ searchField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
    
    func requestAPIToNaver(queryValue: String) {
        let clientID: String = "PHZ7J_XkeqcNFKIZeSXu"
        let clientKEY: String = "ukkhOKJBPU"
        
        let query: String  = "https://openapi.naver.com/v1/search/book.json?query=\(queryValue)"
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
        
        var requestURL = URLRequest(url: queryURL)
        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else { print(error); return }
            guard let data = data else { print(error); return }
            
            do {
                let searchInfo: SearchResult = try self.jsconDecoder.decode(SearchResult.self, from: data)
                dataManager.shared.searchResult = searchInfo
                self.urlTaskDone()
            } catch {
                print(fatalError())
            }
        }
        task.resume()
    }

    func urlTaskDone() {
        let item1 = dataManager.shared.searchResult?.items[0]
        let item2 = dataManager.shared.searchResult?.items[1]
        
        do {
//            let imageURL = URL(string: item!.image)
//            let imageData = try Data(contentsOf: imageURL!)
//            let posterImage = UIImage(data: imageData)
            OperationQueue.main.addOperation {
                print(item1?.title)
                print(item2?.title)
                self.searchResultLabel.text = item1?.title
                self.searchResultLabel2.text = item2?.title
            }

        } catch { }
    }
    
}

