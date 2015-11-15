//
//  Grade.swift
//  gradebuildr
//
//  Created by Arin Houck on 11/14/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import Foundation

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
    
    init (id: Int, name: String,  score: Int, scoreTotal: Int, percentage: Double, userId: Int, courseId: Int, weightId: Int, createdAt: String)
    {
        self.id = id
        self.name = name
        self.score = score
        self.scoreTotal = scoreTotal
        self.percentage = percentage
        self.userId = userId
        self.courseId = courseId
        self.weightId = weightId
        self.createdAt = createdAt
    }
    
    internal func getName() -> String
    {
        return name
    }
    
}