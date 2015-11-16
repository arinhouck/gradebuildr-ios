//
//  Courses.swift
//  gradebuildr
//
//  Created by Arin Houck on 11/16/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import Foundation
import KeychainAccess
import SwiftyJSON
import Alamofire

class Courses {
    var rows: [Course] = []
    
    enum Router: URLRequestConvertible {
        static let baseURLString = API_URL
        static var token: String?
        
        case CreateCourse([String: AnyObject])
        case ReadCourse([String: AnyObject])
        case UpdateCourse(String, [String: AnyObject])
        case DestroyCourse(String)
        
        var method: Alamofire.Method {
            switch self {
            case .CreateCourse:
                return .POST
            case .ReadCourse:
                return .GET
            case .UpdateCourse:
                return .PUT
            case .DestroyCourse:
                return .DELETE
            }
        }
        
        var path: String {
            switch self {
            case .CreateCourse:
                return "/courses"
            case .ReadCourse:
                return "/courses"
            case .UpdateCourse(let id, _):
                return "/courses/\(id)"
            case .DestroyCourse(let id):
                return "/courses/\(id)"
            }
        }
        
        // MARK: URLRequestConvertible
        
        var URLRequest: NSMutableURLRequest {
            let URL = NSURL(string: Router.baseURLString)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = Router.token {
                mutableURLRequest.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
            }
            
            switch self {
            case .CreateCourse(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .ReadCourse(let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateCourse(_, let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
            }
        }
    }
    
}


class Course
{
    private var id: Int
    private var subject: String
    private var number: Int
    private var creditHours: Int
    private var currentGrade: String
    private var letterGrade: String
    private var gradingScale: String
    private var userId: Int
    private var createdAt: String
    
    enum CourseFields: String {
        case Id = "id"
        case Subject = "subject"
        case Number = "number"
        case CreditHours = "credit_hours"
        case CurrentGrade = "current_grade"
        case LetterGrade = "letter_grade"
        case GradingScale = "grading_scale"
        case UserId = "user_id"
        case CreatedAt = "created_at"
    }
    
    required init (course: JSON)
    {
        self.id = course[CourseFields.Id.rawValue].int!
        self.subject = course[CourseFields.Subject.rawValue].stringValue
        self.number = Int(course[CourseFields.Number.rawValue].stringValue)!
        self.creditHours = course[CourseFields.CreditHours.rawValue].int!
        self.currentGrade = course[CourseFields.CurrentGrade.rawValue].stringValue
        self.letterGrade = course[CourseFields.LetterGrade.rawValue].stringValue
        self.gradingScale = course[CourseFields.GradingScale.rawValue].stringValue
        self.userId = course[CourseFields.UserId.rawValue].int!
        self.createdAt = course[CourseFields.CreatedAt.rawValue].stringValue
    }
    
    internal func getName() -> String
    {
        return subject + " \(number)"
    }
    
    internal func getCurrentGrade() -> String
    {
        return currentGrade
    }
    
    internal func getLetterGrade() -> String
    {
        return letterGrade
    }
    
}