//
//  GithubRepoSearchSettingsDelegate.swift
//  GithubDemo
//
//  Created by Savio Tsui on 10/23/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import Foundation

protocol GithubRepoSearchSettingsDelegate: class {
    func onSearchSettingsReturn(githubRepoSearchSettingsViewController: GithubRepoSearchSettingsViewController, didSave saved: Bool)
}
