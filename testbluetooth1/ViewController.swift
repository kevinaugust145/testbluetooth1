//
//  ViewController.swift
//  testbluetooth1
//
//  Created by 洪宗燦 on 2024/10/9.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource {
    
   
      
    @IBOutlet weak var tableView: UITableView!
    
    var centralManager: CBCentralManager!
    var discoveredPeripherals: [(peripheral: CBPeripheral, rssi: NSNumber)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 初始化 CBCentralManager
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // CBCentralManagerDelegate 方法
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // 开始扫描设备
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    // 发现设备时调用
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: { $0.peripheral.identifier == peripheral.identifier }) {
            discoveredPeripherals.append((peripheral, RSSI))
            
            DispatchQueue.main.async {
                self.tableView.reloadData()  // 刷新TableView显示新设备
            }
        }
    }
    
    // UITableViewDataSource 方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothCell", for: indexPath)
        
        let peripheralInfo = discoveredPeripherals[indexPath.row]
        let peripheral = peripheralInfo.peripheral
        let rssi = peripheralInfo.rssi
        
        cell.textLabel?.text = peripheral.name ?? "未知设备"
        cell.detailTextLabel?.text = "UUID: \(peripheral.identifier.uuidString) | RSSI: \(rssi)"
        
        return cell
    }
}
