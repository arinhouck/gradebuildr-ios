//
//  User.swift
//  gradebuildr
//
//  Created by Arin Houck on 11/18/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import Foundation
import KeychainAccess
import SwiftyJSON
import Alamofire

class User
{
    private var id: Int
    private var email: String
    private var firstName: String
    private var lastName: String
    private var organization: String
    private var accountType: String
    private var isStudent: Bool
    private var isOrganization: Bool
    private var gradePoints: Float
    private var gradeUnits: Int
    private var activeSemester: String
    //private var activeUntil: NSDate
    private var subscription: String
    private var canceledSubscription: Bool
    private var semesterGpa: Float
    private var cumulativeGpa: Float
    private var gradeCount: Int
    private var courseCount: Int
    
    enum UserFields: String {
        case Id = "id"
        case Email = "email"
        case FirstName = "first_name"
        case LastName = "last_name"
        case Organization = "organization"
        case AccountType = "account_type"
        case IsStudent = "is_student"
        case IsOrganization = "is_organization"
        case GradePoints = "grade_points"
        case GradeUnits = "grade_units"
        case ActiveSemester = "active_semester"
        case ActiveUntil = "active_until"
        case Subscription = "subscription"
        case CanceledSubscription = "canceled_subscription"
        case SemesterGpa = "semester_gpa"
        case CumulativeGpa = "cumulative_gpa"
        case GradeCount = "grade_count"
        case CourseCount = "course_count"
    }
    
    required init (user: JSON)
    {
        self.id = user[UserFields.Id.rawValue].intValue
        self.email = user[UserFields.Email.rawValue].stringValue
        self.firstName = user[UserFields.FirstName.rawValue].stringValue
        self.lastName = user[UserFields.LastName.rawValue].stringValue
        self.organization = user[UserFields.Organization.rawValue].stringValue
        self.accountType = user[UserFields.AccountType.rawValue].stringValue
        self.isStudent = user[UserFields.IsStudent.rawValue].boolValue
        self.isOrganization = user[UserFields.IsOrganization.rawValue].boolValue
        self.gradePoints = user[UserFields.GradePoints.rawValue].floatValue
        self.gradeUnits = user[UserFields.GradeUnits.rawValue].intValue
        self.activeSemester = user[UserFields.ActiveSemester.rawValue].stringValue
        //self.activeUntil = NSDate(course[UserFields.ActiveSemester.rawValue].stringValue)
        self.subscription = user[UserFields.Subscription.rawValue].stringValue
        self.canceledSubscription = user[UserFields.CanceledSubscription.rawValue].boolValue
        self.semesterGpa = user[UserFields.SemesterGpa.rawValue].floatValue
        self.cumulativeGpa = user[UserFields.CumulativeGpa.rawValue].floatValue
        self.gradeCount = user[UserFields.GradeCount.rawValue].intValue
        self.courseCount = user[UserFields.CourseCount.rawValue].intValue
    }
    
    enum Router: URLRequestConvertible {
        static let baseURLString = API_URL
        static var token: String?
        
        case CreateUser([String: AnyObject])
        case ReadUser([String: AnyObject])
        case UpdateUser(NSDictionary)
        case DestroyUser(String)
        
        var method: Alamofire.Method {
            switch self {
            case .CreateUser:
                return .POST
            case .ReadUser:
                return .GET
            case .UpdateUser:
                return .PUT
            case .DestroyUser:
                return .DELETE
            }
        }
        
        var path: String {
            switch self {
            case .CreateUser:
                return "/users"
            case .ReadUser(let id):
                return "/users/\(id["id"]!)"
            case .UpdateUser(let params):
                return "/users/\(params["id"]!)"
            case .DestroyUser(let id):
                return "/users/\(id)"
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
            case .CreateUser(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .ReadUser(let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateUser(let parameters):
                mutableURLRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
                return mutableURLRequest
            default:
                return mutableURLRequest
            }
        }
    }

    
    internal func getEmail() -> String
    {
        return email
    }
    
    internal func getName() -> String
    {
        return firstName + " " + lastName
    }
    
    internal func getFirstName() -> String
    {
        return firstName
    }
    
    internal func getLastName() -> String
    {
        return lastName
    }
    
    internal func getGradePoints() -> Float
    {
        return gradePoints
    }
    
    internal func getGradeUnits() -> Int
    {
        return gradeUnits
    }
    
}