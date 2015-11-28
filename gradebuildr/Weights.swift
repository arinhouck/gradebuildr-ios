//
//  Weights.swift
//  gradebuildr
//
//  Created by Arin Houck on 11/21/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import Foundation

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

class Weights {
    var rows: [Weight] = []
    
    enum Router: URLRequestConvertible {
        static let baseURLString = API_URL
        static var token: String?
        
        case CreateWeight([String: AnyObject])
        case IndexWeight(NSDictionary)
        
        var method: Alamofire.Method {
            switch self {
            case .CreateWeight:
                return .POST
            case .IndexWeight:
                return .GET
            }
        }
        
        var path: String {
            switch self {
            case .CreateWeight:
                return "/weights"
            case .IndexWeight:
                return "/weights"
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
            case .CreateWeight(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .IndexWeight(let parameters):
                mutableURLRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
                return mutableURLRequest
            default:
                return mutableURLRequest
            }
        }
    }
    
}


class Weight
{
    private var id: Int
    private var name: String
    private var percentage: Double
    private var courseId: Int
    
    enum WeightFields: String {
        case Id = "id"
        case Name = "name"
        case Percentage = "percentage"
        case CourseId = "course_id"
    }
    
    required init (weight: JSON)
    {
        self.id = weight[WeightFields.Id.rawValue].int!
        self.name = weight[WeightFields.Name.rawValue].stringValue
        self.percentage = weight[WeightFields.Percentage.rawValue].doubleValue
        self.courseId = weight[WeightFields.CourseId.rawValue].intValue
    }
    
    internal func getName() -> String
    {
        return name
    }
    
    internal func getPercentage() -> Double
    {
        return percentage
    }
    
    
}