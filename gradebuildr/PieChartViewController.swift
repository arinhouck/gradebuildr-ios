//
//  PieChartViewController.swift
//  gradebuildr
//
//  Created by Arin Houck on 11/21/15.
//  Copyright © 2015 Gradebuildr. All rights reserved.
//

import UIKit
import Charts
import KeychainAccess
import SwiftyJSON
import Alamofire

class PieChartViewController: UIViewController {
    
    var weights: Weights = Weights()
    var course: Course?

    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadWeights()

        // Do any additional setup after loading the view.
    }
    
    let keychain = Keychain(service: "com.gradebuildr.user-token")
    
    private func loadWeights() {
        Weights.Router.token = keychain["user-token"]
        
        let params = [
            "user_id": keychain["user-id"]!,
            "ids": course!.getWeightIds()
        ]
        
        _ = Alamofire.request(Weights.Router.IndexWeight(params))
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json: JSON = JSON(value)
                        for weight in json["weights"].arrayValue {
                            
                            self.weights.rows.append(Weight(weight: weight))
                        }
                    }
                    self.loadPieGraph()
                case .Failure(let error):
                    print(error)
                }
            })
        
    }
    
    private func loadPieGraph() {
        let names: [String]? = weights.rows.map({weight in weight.getName()})
        let percentages: [Double]? = weights.rows.map({weight in weight.getPercentage()})
        self.setChart(names!, values: percentages!)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    func setChart(dataPoints: [String], values: [Double]) {
        pieChartView.noDataText = "Weights Unvailable."
        pieChartView.descriptionText = ""
        pieChartView.centerText = "Weights"
        pieChartView.animate(xAxisDuration: 1)
        pieChartView.drawSliceTextEnabled = false
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        

        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        pieChartDataSet.colors = ChartColorTemplates.colorful()
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        pieChartView.data?.setValueFont(UIFont (name: "HelveticaNeue", size: 12))
    }

}
