//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftIconFont

// Main ViewController
class RepoResultsViewController: UIViewController {

    var searchBar: UISearchBar!
    var navigateSettingsButton: UIBarButtonItem!
    var searchSettings = GithubRepoSearchSettings()

    @IBOutlet weak var searchTable: UITableView!
    
    var repos = [GithubRepo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem?.icon(from: .FontAwesome, code: "github", ofSize: 20)

        searchTable.dataSource = self
        searchTable.estimatedRowHeight = 135
        searchTable.rowHeight = UITableViewAutomaticDimension

        // Perform the first search when the view controller first loads
        doSearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let destinationViewController = navigationController.topViewController as! GithubRepoSearchSettingsViewController

        destinationViewController.delegate = self
        destinationViewController.searchSettings = self.searchSettings
    }

    // Perform the search.
    fileprivate func doSearch() {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in

            self.repos = [GithubRepo]()
            // Print the returned repositories to the output window
            for repo in newRepos {
                print(repo)
                self.repos.append(repo)
            }   

            self.searchTable.reloadData()

            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
}

extension RepoResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.ios-github.SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        let repo = self.repos[indexPath.row]

        cell.repoDescription.text = repo.repoDescription
        cell.repoName.text = repo.name

        cell.repoStars.font = UIFont.icon(from: .FontAwesome, ofSize: 13)
        cell.repoStars.text =  String.fontAwesomeIcon("star")! + " " + String(describing: repo.stars!)
        cell.repoBranches.font = UIFont.icon(from: .FontAwesome, ofSize: 13)
        cell.repoBranches.text = String.fontAwesomeIcon("code-fork")! + " " + String(describing: repo.forks!)
        cell.repoAuthor.text = repo.ownerHandle

        cell.repoImage.contentMode = .scaleAspectFit
        cell.repoImage.image = nil
        if (repo.ownerAvatarURL != nil)
        {
            let repoImageUrl = URL(string: repo.ownerAvatarURL!)

            cell.repoImage.setImageWith(repoImageUrl!)
        }

        return cell
    }
}

// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}

extension RepoResultsViewController: GithubRepoSearchSettingsDelegate {
    func onSearchSettingsReturn(githubRepoSearchSettingsViewController searchSettingsViewController: GithubRepoSearchSettingsViewController, didSave saved: Bool) {
        if (saved) {
            self.searchSettings = searchSettingsViewController.searchSettings
            doSearch()
        }
    }
}
