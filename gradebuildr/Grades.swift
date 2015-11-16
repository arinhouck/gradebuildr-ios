//
//  Grade.swift
//  gradebuildr
//
//  Created by Arin Houck on 11/14/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import Foundation
import SwiftyJSON
class Grades {
    var rows: [Grade] = []
    
}


class Grade
{
    private var id: Int
    private var name:String
    private var score: Int
    private var scoreTotal: Int
    private var percentage: Double
    private var userId: Int
    private var courseId: Int
    private var weightId: Int
    private var createdAt:String
    
    enum GradeFields: String {
        case Id = "id"
        case Name = "name"
        case Score = "score"
        case ScoreTotal = "score_total"
        case Percentage = "percentage"
        case UserId = "user_id"
        case CourseId = "course_id"
        case WeightId = "weight_id"
        case CreatedAt = "created_at"
    }
    
    required init (grade: JSON)
    {
        self.id = grade[GradeFields.Id.rawValue].int!
        self.name = grade[GradeFields.Name.rawValue].stringValue
        self.score = grade[GradeFields.Score.rawValue].int!
        self.scoreTotal = grade[GradeFields.ScoreTotal.rawValue].int!
        self.percentage = grade[GradeFields.Score.rawValue].doubleValue
        self.userId = grade[GradeFields.UserId.rawValue].int!
        self.courseId = grade[GradeFields.CourseId.rawValue].int!
        self.weightId = grade[GradeFields.WeightId.rawValue].int!
        self.createdAt = grade[GradeFields.CreatedAt.rawValue].stringValue
    }
    
    internal func getName() -> String
    {
        return name
    }
    
    internal func getScore() -> Int
    {
        return score
    }
    
    internal func getScoreTotal() -> Int
    {
        return scoreTotal
    }
    
}