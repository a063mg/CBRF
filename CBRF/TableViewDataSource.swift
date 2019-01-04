//
//  TableViewDataSource.swift
//  CBRF
//
//  Created by Alekseev Artem on 05/12/2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Valutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currency-Cell") as! CurrencyCell
        
        let char = Valutes[indexPath.row]
        
        cell.name.text = char.name
        cell.value.text = String(char.value)
            
        cell.currencyImage.image = UIImage(named: "flags-normal/"+String(char.code.lowercased()[..<char.code.index(char.code.startIndex, offsetBy: 2)])+".png")
        
        return cell
        
    }
}

extension ViewController: UITableViewDelegate {
    
}
