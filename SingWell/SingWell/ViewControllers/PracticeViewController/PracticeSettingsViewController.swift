//
//  PracticeSettingsViewController.swift
//  SingWell
//
//  Created by Travis Siems on 2/27/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable

protocol PracticeSettingsDelegate: class {
    func updateSettings(_ tempo: Float?, _ metronomeOn: Bool?)
}

class PracticeSettingsViewController: AnimatableModalViewController {
    
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var tempoSlider: UISlider!
    @IBOutlet weak var metronomeSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: PracticeSettingsDelegate?
    
    var metronomeOn = true
    var tempo:Float = 80
    
    let tempoMin:Float = 30
    let tempoMax:Float = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
    }
    
    @objc func tempoSliderChanged(sender:UISlider) {
        tempo = sender.value
        tempoLabel.text = String(format:"Tempo: %.0f",tempo)
    }
    
    @objc func metronomeSwitchChanged(sender:UISwitch) {
        metronomeOn = sender.isOn
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SETTING WILL DISAPPER")
        self.delegate?.updateSettings(tempo, metronomeOn)
    }
    
    

}

class TempoSettingCell: AnimatableTableViewCell {
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var tempoSlider: UISlider!
}

class MetronomeSettingCell: AnimatableTableViewCell {
    @IBOutlet weak var metronomeSwitch: UISwitch!
    
}

extension PracticeSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // basic settings
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: // basic settings
            return 147.0
        default:
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0: // basic settings
        
        switch indexPath.row {
        case 0: // tempo cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "TempoSettingCell", for: indexPath) as! TempoSettingCell
            cell.tempoSlider.minimumValue = tempoMin
            cell.tempoSlider.maximumValue = tempoMax
            cell.tempoSlider.setValue(tempo, animated: true)
            cell.tempoLabel.text = String(format:"Tempo: %.0f",tempo)
            cell.tempoSlider.addTarget(self, action:#selector(PracticeSettingsViewController.tempoSliderChanged(sender:)), for: .valueChanged)
        
            
            
            self.tempoLabel = cell.tempoLabel
            return cell
        default: //metronome cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MetronomeSettingCell", for: indexPath) as! MetronomeSettingCell
            cell.metronomeSwitch.isOn = metronomeOn
            cell.metronomeSwitch.addTarget(self, action:#selector(PracticeSettingsViewController.metronomeSwitchChanged(sender:)), for: .valueChanged )
            return cell
        }
        
    }
    
   
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Basic Settings"
        default:
            return ""
        }
    }
    
    
}
