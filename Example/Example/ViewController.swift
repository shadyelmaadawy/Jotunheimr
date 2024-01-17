//
//  ViewController.swift
//  Example
//
//  Created by Shady El-Maadawy on 16/01/2024.
//

import UIKit
import CoreNFC
import Jotunheimr

class ViewController: UIViewController {

    @IBOutlet var valueTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    let jotunheimr = Jotunheimr.shared

    
    var records: [NFCNDEFPayload] = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    @IBAction func scanRecordsButtonClicked(_ sender: Any) {
        
        Task {
            do {
                let jotunheimrClient = try await jotunheimr.scanForTag(scanMessage: "Hello, Scan your tag!")
                records = try await jotunheimrClient.getPayloads()

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print(error)
            }
        }

    }
    
    
    @IBAction func addRecordButtonClicked(_ sender: Any) {
        guard valueTextField.text?.count ?? 0 > 0 else {
            return
        }

        Task {
            do {
                let jotunheimrClient = try await jotunheimr.scanForTag(scanMessage: "Hello, Scan your tag!")
           
                let nfcPayload = NFCNDEFPayload.init(
                    format: NFCTypeNameFormat.nfcWellKnown,
                    type: "T".data(using: .utf8)!,
                    identifier: Data.init(count: 0),
                    payload: valueTextField.text!.data(using: .utf8)!,
                    chunkSize: 0
                )
                

                try await jotunheimrClient.addPayload(nfcPayload)
                
                valueTextField.resignFirstResponder()
                valueTextField.text = ""
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func writeRecordButtonClicked(_ sender: Any) {
    
        guard valueTextField.text?.count ?? 0 > 0 else {
            return
        }
        
        Task {
            do {
                
                let jotunheimrClient = try await jotunheimr.scanForTag(scanMessage: "Hello, Scan your tag!")
           
                let nfcPayload = NFCNDEFPayload.init(
                    format: NFCTypeNameFormat.nfcWellKnown,
                    type: "T".data(using: .utf8)!,
                    identifier: Data.init(count: 0),
                    payload: valueTextField.text!.data(using: .utf8)!,
                    chunkSize: 0
                )
                try await jotunheimrClient.writePayload(nfcPayload)
                
                valueTextField.resignFirstResponder()
                valueTextField.text = ""
                
            } catch {
                print(error)
            }
        }

    }
    
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") else {
            fatalError()
        }
        
        let record = records[indexPath.row].payload
        cell.textLabel?.text = String.init(data: record, encoding: .utf8)
        
        return cell
    }
    
}

extension UIView {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
    
}

