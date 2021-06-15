//
//  ViewController.swift
//  BookReport
//
//  Created by 이예민 on 2021/06/05.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailView" {
            let vc = segue.destination as? DetailViewController
            if let firstIndex = sender as? Book {
                vc?.bookInfo = firstIndex
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else {
            return UICollectionViewCell()
        }
        
        let book = books[indexPath.item]
        let url = URL(string: book.thumbnailPath)!
        
        cell.bookThumbnail.kf.setImage(with: url)
        cell.backgroundColor = .white
        
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 8
        let itemSpacing: CGFloat = 10
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing * 2) / 3
        let height = width * 10/7
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        //print(books[indexPath.item])
        performSegue(withIdentifier: "DetailView", sender: books[indexPath.item])
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
}

class ResultCell: UICollectionViewCell {
    @IBOutlet weak var bookThumbnail: UIImageView!
}

extension SearchViewController: UISearchBarDelegate {
    
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let searchTerm = searchBar.text,
              searchTerm.isEmpty == false else { return }
        SearchAPI.search(searchTerm) { books in
            print("--> counts : \(books.count), 첫 제목: \(String(describing: books.first?.title))")
            
            DispatchQueue.main.async {
                self.books = books
                // collectionView의 데이터를 리프레쉬 하는 것
                self.resultCollectionView.reloadData()
            }
        }
        print("--> 검섹어 : \(searchTerm)")
    }
}

class SearchAPI {
    static func search(_ term: String, completion: @escaping ([Book]) -> Void) {
        let headers = [
            "X-Naver-Client-Id": "PHZ7J_XkeqcNFKIZeSXu",
            "X-Naver-Client-Secret": "ukkhOKJBPU"
        ]
        let session = URLSession(configuration: .default)
        let urlString = "https://openapi.naver.com/v1/search/book.json?"
        var urlComponents = URLComponents(string: urlString)
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "query", value: term))
        queryItems.append(URLQueryItem(name: "display", value: "15"))

        urlComponents?.queryItems = queryItems

        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
                    completion([])
            }
            
            guard let resultData = data else {
                completion([])
                return
            }
            let books = SearchAPI.parseBooks(resultData)
            completion(books)
        }
        dataTask.resume()
    }
    
    static func parseBooks(_ data: Data) -> [Book] {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(Response.self, from: data)
            let books = response.books
            return books
        } catch let error {
            print("---> parsing error: \(error.localizedDescription)")
            return []
        }
    }
}
