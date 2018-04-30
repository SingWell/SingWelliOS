//
//  PracticeSettingsViewController.swift
//  SingWell
//
//  Created by Travis Siems on 2/27/18.
//  Copyright © 2018 Travis Siems. All rights reserved.
//

import UIKit
import IBAnimatable
import IoniconsKit

protocol PracticeSettingsDelegate: class {
    func updateSettings(_ tempo: Float?, _ metronomeOn: Bool?, _ partsToDisplay:[Int:[String:Any]])
}

class PracticeSettingsViewController: AnimatableModalViewController {
    
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var tempoSlider: UISlider!
    @IBOutlet weak var metronomeSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBtn: AnimatableButton!
    weak var delegate: PracticeSettingsDelegate?
    
    var metronomeOn = true
    var tempo:Float = 80
    var partsToDisplay:[Int:[String:Any]] = [:]
    
    let tempoMin:Float = 30
    let tempoMax:Float = 180
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        
        
        self.doneBtn?.titleLabel?.font = UIFont.ionicon(of: 20)
        self.doneBtn?.setTitle(String.ionicon(with: Ionicons.checkmarkRound ), for: .normal)
    }
    
    @objc func tempoSliderChanged(sender:UISlider) {
        tempo = sender.value
        tempoLabel.text = String(format:"Tempo: %.0f",tempo)
    }
    
    @objc func metronomeSwitchChanged(sender:UISwitch) {
        metronomeOn = sender.isOn
    }
    
    @objc func displayPartSwitchChanged(sender:UISwitch) {
        partsToDisplay[sender.tag]!["display"] = sender.isOn
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SETTING WILL DISAPPER")
        self.delegate?.updateSettings(tempo, metronomeOn, partsToDisplay)
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

class TempoSettingCell: AnimatableTableViewCell {
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var tempoSlider: UISlider!
}

class MetronomeSettingCell: AnimatableTableViewCell {
    @IBOutlet weak var metronomeSwitch: UISwitch!
}

class DisplayPartSettingCell: AnimatableTableViewCell {
    @IBOutlet weak var displaySwitch: UISwitch!
    @IBOutlet weak var partNameLabel: AnimatableLabel!
}

extension PracticeSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // basic settings
            return 2
        case 1: // parts to display
            return partsToDisplay.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: // basic settings
            return 50.0
        case 1: // parts to display
            return 50.0
        default:
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // basic settings
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
        default: //parts to display
            let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayPartSettingCell", for: indexPath) as! DisplayPartSettingCell
            if let shouldDisplay = partsToDisplay[Int(indexPath.row)]!["display"] as? Bool {
                cell.displaySwitch.isOn = shouldDisplay // true for selected parts
            } else {
                cell.displaySwitch.isOn = true // true for all parts
            }
            cell.displaySwitch.tag = indexPath.row
            
            cell.displaySwitch.addTarget(self, action:#selector(PracticeSettingsViewController.displayPartSwitchChanged(sender:)), for: .valueChanged )
            
            if let partName = partsToDisplay[indexPath.row]!["name"] as? String {
                cell.partNameLabel.text = partName
            } else {
                cell.partNameLabel.text = "Part "+String(indexPath.row)
            }
            
            return cell
        }
        
    }
    
   
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Basic Settings"
        case 1:
            return "Parts to Display"
        default:
            return ""
        }
    }
    
    
}
