//
//  ResumeViewModel.swift
//  HKBankTest
//
//  Created by boqian cheng on 2019-06-01.
//  Copyright © 2019 boqiancheng. All rights reserved.
//

import Foundation

class ResumeViewModel {
    
    // for view and view model binding
    typealias Listener = (Bool) -> ()
    
    var listener: Listener?
    // data model reference
    var resumeData: ResumeDataModel
    
    var name: String?
    var email: String?
    var telephone: String?
    var summary: [String]?
    let techKnowledge: String
    let experience: [Experience]
    
    
    var searchText: String {
        didSet {
            // listener?(searchByTitle(searchTitle: searchText))
            let filted = searchByTitle(searchTitle: searchText)
            self.filtedViewModel = filted
        }
    }
    
    var filtedViewModel: [StoryViewModel] {
        didSet {
            listener?(true)
        }
    }
    
    init() {
        storiesData = Stories()
        searchText = ""
        storiesListViewModel = []
        filtedViewModel = []
    }
    
    func getStoriesListView(offset: Int = 0, limit: Int = 30, fields: String = "stories(id,title,cover,user)") {
        
        httpServices.getStories(offset: offset, limit: limit, fields: fields) { [weak self] (results) in
            self?.storiesData = results
            // transfer data model to view model
            var tempListVM: [StoryViewModel] = []
            for story in results.stories {
                let storyVM = StoryViewModel(dataModel: story)
                tempListVM.append(storyVM)
            }
            self?.storiesListViewModel = tempListVM
            self?.filtedViewModel = tempListVM
        }
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func searchByTitle(searchTitle: String) -> [StoryViewModel] {
        let filted = self.storiesListViewModel.filter({ (storyVM) -> Bool in
            if searchTitle.isEmpty {
                return true
            }
            return storyVM.title.lowercased().hasPrefix(searchTitle.lowercased())
        })
        
        return filted
    }
}

