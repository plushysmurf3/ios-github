//
//  GithubRepo.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

private let personalAccessToken = "0d0a641e23175c4fe8249950b88790cefe652005"
private let reposUrl = "https://api.github.com/search/repositories"
private let clientId: String? = "4a05d034c9c749437325"
private let clientSecret: String? = "bfa811f02ab569c3caa588dacea9d8ddf79fbd82"

// Model class that represents a GitHub repository
class GithubRepo: CustomStringConvertible {

    var name: String? = ""
    var ownerHandle: String? = ""
    var ownerAvatarURL: String? = ""
    var stars: Int? = 0
    var forks: Int? = 0
    var repoDescription: String? = ""
    var language: String? = ""
    
    // Initializes a GitHubRepo from a JSON dictionary
    init(jsonResult: NSDictionary) {
        
        if let name = jsonResult["name"] as? String {
            self.name = name
        }
        
        if let stars = jsonResult["stargazers_count"] as? Int? {
            self.stars = stars
        }
        
        if let forks = jsonResult["forks_count"] as? Int? {
            self.forks = forks
        }
        
        if let owner = jsonResult["owner"] as? NSDictionary {
            if let ownerHandle = owner["login"] as? String {
                self.ownerHandle = ownerHandle
            }
            if let ownerAvatarURL = owner["avatar_url"] as? String {
                self.ownerAvatarURL = ownerAvatarURL
            }
        }

        if let repoDescription = jsonResult["description"] as? String? {
            self.repoDescription = repoDescription
        }

        if let language = jsonResult["language"] as? String? {
            self.language = language
        }
    }
    
    // Actually fetch the list of repositories from the GitHub API.
    // Calls successCallback(...) if the request is successful
    class func fetchRepos(_ settings: GithubRepoSearchSettings, successCallback: @escaping ([GithubRepo]) -> (), error: ((Error?) -> ())?) {
        let manager = AFHTTPRequestOperationManager()
        let params = queryParamsWithSettings(settings)

        manager.get(reposUrl, parameters: params, success: { (operation: AFHTTPRequestOperation, responseObject: Any) in
            if let response = responseObject as? NSDictionary, let results = response["items"] as? NSArray {
                var repos: [GithubRepo] = []
                for result in results as! [NSDictionary] {
                    repos.append(GithubRepo(jsonResult: result))
                }
                successCallback(repos)
            }
        }) { (operation: AFHTTPRequestOperation, requestError: Error) in
            if let errorCallback = error {
                errorCallback(requestError)
            }
        }
    }
    
    // Helper method that constructs a dictionary of the query parameters used in the request to the
    // GitHub API
    fileprivate class func queryParamsWithSettings(_ settings: GithubRepoSearchSettings) -> [String: String] {
        var params: [String:String] = [:]
        if let clientId = clientId {
            params["client_id"] = clientId
        }
        
        if let clientSecret = clientSecret {
            params["client_secret"] = clientSecret
        }
        
        var q = ""
        if let searchString = settings.searchString {
            q = q + searchString
        }
        q = q + " stars:>\(settings.minStars)"

        if (settings.searchWithLanguages) {
            for i in (0..<settings.languages.count) {
                q = q + " language:" + settings.languages[i]
            }
        }

        params["q"] = q
        
        params["sort"] = "stars"
        params["order"] = "desc"
        
        return params
    }

    // Creates a text representation of a GitHub repo
    var description: String {
        return "[Name: \(self.name!)]" +
            "\n\t[Stars: \(self.stars!)]" +
            "\n\t[Forks: \(self.forks!)]" +
            "\n\t[Owner: \(self.ownerHandle!)]" +
            "\n\t[Avatar: \(self.ownerAvatarURL!)]" +
            "\n\t[Description: \((self.repoDescription != nil) ? self.repoDescription! : "")]" +
            "\n\t[Language: \(self.language!)]"
    }
}
