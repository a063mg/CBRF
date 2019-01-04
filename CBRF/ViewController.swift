//
//  ViewController.swift
//  CBRF
//
//  Created by Alekseev Artem on 05/12/2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl:UIRefreshControl = {
        let referControl = UIRefreshControl()
        referControl .addTarget(self, action: #selector(ViewController.updateData(_:)), for: .valueChanged)
//        referControl.tintColor = UIColor.blue
        return referControl
    }()
    
    var Valutes: [Currency] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        download()
        
        tableView.estimatedRowHeight = 50
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.addSubview(refreshControl)
        
    }
    
    @objc func updateData(_ refreshControl: UIRefreshControl) {
        
        download()
        tableView.reloadData()
        
        refreshControl.endRefreshing()
        
    }

    func download() -> Void {
        if let url = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js"){
            
            let urlRequest = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                guard error == nil else{
                    return
                }
                
                guard let unwrappedResponse = response else {
                    //print(unwrappedResponse)
                    return
                }
                
                guard let data = data else{
                    return
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else{
                    return
                }
    
                var char: [Currency] = []
                
                if let array = json as? [String: Any] {
                guard let valutes = array["Valute"] as? [String: Any] else { return }
                    valutes.forEach { (valute) in
                        guard let cur = valute.value as? [String: Any] else { return }
                        
                        guard let name = cur["Name"] as? String else { return }
                        guard let value = cur["Value"] as? NSNumber else { return }
                        guard let nominal = cur["Nominal"] as? NSNumber else { return }
                        guard let code = cur["CharCode"] as? String else { return }
                        
                        char.append(Currency(value: Float(round(100*Float(value)/Float(nominal))/100),name: name,photo: "it.png", code: code))
                        
                    }
                    
                    char.sort { $0.value > $1.value }
                    
                    DispatchQueue.main.async {
                        self.Valutes = char
                    }
                    
                }
                
            }).resume()
            
        }
        
    }


}

