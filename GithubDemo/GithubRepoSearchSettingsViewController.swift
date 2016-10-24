//
//  GithubRepoSearchSettingsViewController.swift
//  GithubDemo
//
//  Created by Savio Tsui on 10/21/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class GithubRepoSearchSettingsViewController: UIViewController {

    weak var delegate: GithubRepoSearchSettingsDelegate?

    @IBOutlet weak var navigateRepoResults: UIBarButtonItem!
    @IBOutlet weak var saveSettings: UIBarButtonItem!
    @IBOutlet weak var starValue: UILabel!
    @IBOutlet weak var starSlider: UISlider!
    @IBOutlet weak var languageTable: UITableView!

    var searchSettings: GithubRepoSearchSettings!

    internal let items = [
        ["Filter by Language"],
        ["Java", "JavaScript", "Assembly", "Objective-C", "C"]
    ]
    internal var showLanguages: Bool = false
    internal var languageToggleStates: [String:Bool] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        searchSettings = searchSettings ?? GithubRepoSearchSettings()

        languageTable.delegate = self
        languageTable.dataSource = self
        languageTable.estimatedRowHeight = 60
        languageTable.rowHeight = UITableViewAutomaticDimension
        languageTable.isScrollEnabled = false

        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func getSettingsFromView() -> GithubRepoSearchSettings {
        var settings: GithubRepoSearchSettings = GithubRepoSearchSettings()

        settings.minStars = Int(self.starSlider.value)
        settings.searchWithLanguages = self.showLanguages

        if (self.showLanguages) {
            let numLanguages = self.languageTable.numberOfRows(inSection: 1)
            for i in (0..<numLanguages) {
                let indexPath = IndexPath(row: i, section: 1)
                let cell = self.languageTable.cellForRow(at: indexPath) as! LanguagesTableViewCell

                if (cell.accessoryType == .checkmark) {
                    settings.languages.append(cell.languageLabel.text!)
                }
            }
        }

        return settings
    }

    internal func getAccessoryType(language: String) -> UITableViewCellAccessoryType {
        let val = self.languageToggleStates[language]

        if (val == nil)
        {
            return .none
        }

        return val! ? .checkmark : .none
    }

    @IBAction func navigateRepoResults(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveSettings(_ sender: UIBarButtonItem) {
        self.searchSettings = self.getSettingsFromView()

        delegate?.onSearchSettingsReturn(githubRepoSearchSettingsViewController: self, didSave: true)

        navigateRepoResults(sender)
    }

    @IBAction func starSliderChanged(_ sender: UISlider) {
        starValue.text = String(format: "%.0f", starSlider.value)
    }

    @IBAction func toggleLanguages(_ sender: UISwitch) {
        self.showLanguages = sender.isOn
        self.languageTable.reloadData()
    }

    private func initialize() {
        starSlider.value = Float(searchSettings.minStars)
        starValue.text = String(searchSettings.minStars)

        showLanguages = searchSettings.searchWithLanguages

        let numLanguages = searchSettings.languages.count
        for i in (0..<numLanguages) {
            languageToggleStates[searchSettings.languages[i]] = true
        }

        self.languageTable.reloadData()
    }
}

extension GithubRepoSearchSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section != 1) {
            return;
        }

        let cell = tableView.cellForRow(at: indexPath) as! LanguagesTableViewCell
        cell.accessoryType = (cell.accessoryType == .none) ? .checkmark : .none

        let language = cell.languageLabel.text!
        let val = self.languageToggleStates[language]
        if (val != nil) {
            self.languageToggleStates[language] = !val!
        }
        else {
            self.languageToggleStates[language] = true
        }

        self.languageTable.reloadRows(at: [indexPath], with: .automatic)

        print("Selected " + String(indexPath.row) + " " + String(describing: cell.accessoryType == .none ? "none" : "checked"))
    }
}

extension GithubRepoSearchSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.ios-github.LanguagesTableViewCell", for: indexPath) as! LanguagesTableViewCell

        let data = self.items[indexPath.section][indexPath.row]

        if (indexPath.section == 0)
        {
            cell.languageLabel.text = data
            cell.accessoryType = .none
            cell.languageSwitch.isHidden = false
            cell.languageSwitch.isOn = showLanguages
        }
        else {
            cell.languageLabel.text = data
            cell.accessoryType = self.getAccessoryType(language: data)
            cell.languageSwitch.isHidden = true
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.showLanguages ? self.items.count : 1
    }
}
