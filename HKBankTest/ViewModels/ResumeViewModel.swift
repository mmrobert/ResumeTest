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
    typealias ErrorListener = (String) -> ()
    
    var listener: Listener?
    var errorListener: ErrorListener?
    
    // data model reference
    var resumeData: ResumeDataModel?
    
    // variables for view model
    var name: String?
    var email: String?
    var telephone: String?
    var summary: [String]
    var techKnowledge: SkillsViewModel?
    var experience: [ExperienceViewModel]
    
    var finishedLoading: Bool {
        didSet {
            listener?(true)
        }
    }
    
    var errorStr: String {
        didSet {
            errorListener?(errorStr)
        }
    }
    
    init() {
        finishedLoading = false
        errorStr = ""
        summary = []
        experience = []
    }
    
    func getResume() {
        let resumeRouter = ResumesAPI.resumes(queryParas: nil, bodyParas: nil)
        do {
            let netRequest = try resumeRouter.getURLRequest()
            resumeRouter.netWorks(request: netRequest) { [unowned self] result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(ResumeDataModel.self, from: data)
                        self.processRes(res: jsonData)
                    } catch let errData {
                        self.errorStr = "Error: \(errData.localizedDescription)"
                    }
                case .failure(let err):
                    switch err {
                    case ResumesAPI.RequestErrors.netConnectionFailed:
                        self.errorStr = "Net connection failed!"
                    case ResumesAPI.RequestErrors.returnedDataNil:
                        self.errorStr = "No returned data!"
                    default:
                        self.errorStr = "Something wrong!"
                    }
                }
            }
        } catch let error {
            switch error {
            case ResumesAPI.RequestErrors.invalidURL:
                self.errorStr = "Invalid URL!"
            case ResumesAPI.RequestErrors.jsonProcessingFailed:
                self.errorStr = "Wrong body parameters or format!"
            default:
                self.errorStr = "Something wrong!"
            }
        }
    }
    
    private func processRes(res: ResumeDataModel) {
        
        self.resumeData = res
        
        self.name = res.name
        self.email = res.email
        self.telephone = res.telephone
        self.summary = res.summary
        self.techKnowledge = SkillsViewModel(dataModel: res.techKnowledge)
        
        self.experience.removeAll()
        for exp in res.experience {
            self.experience.append(ExperienceViewModel(dataModel: exp))
        }
        
        self.finishedLoading = true
    }
    
    // loading company logo image
    static func getImageData(path: String, completion: @escaping (Data?, String?) -> Void) {
        let imgRouter = ResumesAPI.imgData(path: path)
        do {
            let netRequest = try imgRouter.getURLRequest()
            imgRouter.netWorks(request: netRequest) { result in
                switch result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let err):
                    switch err {
                    case ResumesAPI.RequestErrors.netConnectionFailed:
                        completion(nil, "Net connection failed!")
                    case ResumesAPI.RequestErrors.returnedDataNil:
                        completion(nil, "No returned data!")
                    default:
                        completion(nil, "Something wrong!")
                    }
                }
            }
        } catch let error {
            switch error {
            case ResumesAPI.RequestErrors.invalidURL:
                completion(nil, "Invalid URL!")
            case ResumesAPI.RequestErrors.jsonProcessingFailed:
                completion(nil, "Wrong body parameters or format!")
            default:
                completion(nil, "Something wrong!")
            }
        }
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindError(listener: ErrorListener?) {
        self.errorListener = listener
    }
}

